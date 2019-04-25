//
//  RxArcusSession.swift
//  i2app
//
//  Created by Arcus Team on 6/9/17.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import Foundation
import RxSwift
import CocoaLumberjack

extension Constants {
  public static let kActiveUserPlaceholder: String = "kActiveUserPlaceholder"
}

public enum ArcusPlatformInstance: String {
  case prod = "PROD"
  case devTest = "DEV-TEST"
  case other = "OTHER"
}

public enum ArcusSessionStatus {
  case initialized
  case inactive
  case loading
  case disconnecting
  case unreachable
  case active
  case suspended
  case ended
}

public struct ArcusSessionError: Error {
  enum ErrorType {
    case alreadyAuthenticated
    case cannotAuthenticate
    case invalidConfig
  }
  
  let type: ErrorType
}

public class RxArcusSession: ArcusSession, RxSwiftSession, UrlBuilder, ArcusSessionService, ArcusNotificationConverter {
  
  public var client: ArcusClient
  public var token: ArcusKeychain?
  public var activeUser: ArcusKeychain?
  public var userAgent: String = "" {
    didSet {
      configureSessionUrl(platform)
    }
  }

  public var clientVersion: String = "" {
    didSet {
      configureSessionUrl(platform)
    }
  }
  public var sessionInfo: ArcusSessionInfo?
  public var socketConfig: ArcusSocketConfig?
  public var platform: ArcusPlatformInstance = RxArcusSession.fetchPlatformType() {
    didSet {
      RxArcusSession.cachePlatformType(platform)
    }
  }
  
  private var sessionUrl: URL?
  private var state: ArcusSessionStatus = .initialized {
    didSet {
      DDLogVerbose("RxArcusSession.state = \(state)")
      stateObservable.onNext(state)
    }
  }
  
  public var disposeBag: DisposeBag = DisposeBag()
  public var reachabilityHandler: RxReachabilityHandler? = ReachabilityHandler()
  
  public var stateObservable: BehaviorSubject<ArcusSessionStatus> =
    BehaviorSubject<ArcusSessionStatus>(value: .initialized)
  public var eventObservable: PublishSubject<ArcusSessionEvent> = PublishSubject<ArcusSessionEvent>()
  
  required public init(_ client: ArcusClient) {
    self.client = client

    if let rxClient = client as? RxSwiftClient {
      observeClientState(rxClient)
      observeClientMessages(rxClient)
      observeSessionEvents()
    }
    
    configureSessionUrl(platform)
    
    loadKeychains()
      .subscribe(onSuccess: { _ in })
      .disposed(by: disposeBag)
  }
  
  /**
   Attempt to authenticate the client with the platform using username and password combination.
   
   - Parameters:
   - username: `String` representing the user to be authenticated.
   - password: `String` representing the password of the user to be authenticated.
   */
  public func login(_ username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    guard state == .inactive || state == .initialized || state == .ended else {
      completion(false, ArcusSessionError(type: .alreadyAuthenticated))
      return
    }

    guard let authRequest = authenticationRequest(username, password: password) else {
      completion(false, ArcusSessionError(type: .invalidConfig))
      return
    }
    
    client.sendHttp(authRequest) {
      (response, error) in
      guard error == nil else {
        DDLogDebug(error!.localizedDescription)
        completion(false, error!)
        return
      }
      
      var status = -1
      if let code = response?.statusCode() {
        status = code
      }
      guard status != 401 else {
        let error = NSError(domain: "ArcusError", code: status, userInfo: nil)
        DDLogDebug(error.localizedDescription)
        completion(false, error)
        return
      }
      
      if let tokenValue = response?.getValue("irisAuthToken") {
        completion(true, nil)
        
        self.setActiveUser(username)
        self.setToken(tokenValue, account: username)
        if self.token != nil {
          self.socketConfig = self.tokenBasedSocketConfig()
        }
        self.connect()
      }
    }
  }
  
  /**
   Logout from platform.
   */
  public func logout() {
    // Send Logout Request to the Platform.
    if let request: HttpRequest = logoutRequest() {
      client.sendHttp(request) { _ in }
    }

    // Process Logout.
    processLogout()
  }

  /**
   Connect the client to the platform.
   */
  // TODO: Update to throw?
  public func connect() {
    guard state != .active
      && state != .loading
      && state != .suspended
      && state != .unreachable else {
        return
    }

    let connectClosure: () -> Void = { [weak self] in
      // If config is set, then configure client.
      if let config: ArcusSocketConfig = self?.socketConfig,
        let url: URL = self?.sessionUrl,
        let headers = self?.sessionHeaders(),
        let cookies = self?.sessionCookies() {
        self?.client.configureClient(url,
                                     clientHeaders: headers,
                                     clientCookies: cookies,
                                     socketConfig: config)
      }
      self?.client.connect()
    }

    if token == nil {
      loadKeychains()
        .subscribe(
          onSuccess: { [connectClosure] _ in
            // If config is set, then configure client.
            connectClosure()
          },
          onError: { [connectClosure] _ in
            // If config is set, then configure client.
            connectClosure()
        })
        .disposed(by: disposeBag)

    } else {
      connectClosure()
    }
  }

  public func connectWithToken(_ value: String) {
    guard state != .suspended
      && state != .unreachable else {
        return
    }

    if state == .active || state == .loading {
      logout()
    }

    setActiveUser(Constants.kActiveUserPlaceholder)
    setToken(value, account: Constants.kActiveUserPlaceholder)

    connect()
  }
  
  /**
   Disconnect client from the platform.
   */
  public func disconnect() {
    guard state != .ended else { return }

    state = .disconnecting

    self.client.disconnect()
  }
  
  /**
   Temporarily halts client communications with the platform without closing the connection.
   (Assumes client has been connected.)
   */
  public func suspend() {
    state = .suspended

    self.client.disconnect()
  }
  
  /**
   Resume halted client communications with the platform.
   (Assumes client has been connected, and suspended.)
   */
  public func resume() {
    guard state == .suspended else {
      DDLogInfo("Session was not suspended, call to resume does nothing.")
      return
    }

    if let config: ArcusSocketConfig = socketConfig,
      let url: URL = sessionUrl {
      client.configureClient(url,
                             clientHeaders: sessionHeaders(),
                             clientCookies: sessionCookies(),
                             socketConfig: config)
    }
    client.connect()
  }
  
  /**
   Set Active Place using placeId
   
   - Parameters:
   - placeId: Id of place to set as active
   */
  // TODO: Refactor
  public func setActivePlace(_ placeId: String) {
    do {
      try _ = requestSessionServiceSetActivePlace(placeId)
      sessionInfo?.lastKnownPlaceId = placeId
    } catch {}
  }
  
  /**
   Send message with client.
   
   - Parameters:
   - message: `ArcusClientMessage` to submit to client
   */
  public func send(_ message: ArcusClientMessage) {
    if message.isRequest {
      sendRequest(message)
    } else {
      sendMessage(message)
    }
  }
  
  fileprivate func sendMessage(_ message: ArcusClientMessage) {
    guard state == .active || state == .loading else { return }
    
    // Based on previous ArcusClient, when sending a socket message we always send with isRequest == true.
    var message = message
    message.isRequest = true
    client.send(message)
  }
  
  fileprivate func sendRequest(_ message: ArcusClientMessage) {
    client.sendHttp(message)
  }
  
  public func fetchCameraPreview(_ cameraId: String,
                                 placeId: String,
                                 completion: @escaping CameraPreviewHandler) {
    guard let request: HttpRequest = cameraPreviewHttpRequest(placeId, cameraId: cameraId) else { return }
    client.sendHttp(request) {
      (response, error) in
      completion(response?.data, error)
    }
  }
  
  private func cameraPreviewHttpRequest(_ placeId: String, cameraId: String) -> HttpRequest? {
    let fullPath: String = "/preview/\(placeId)/\(cameraId)"
    guard sessionUrl != nil,
      let tokenValue: String = token?.value,
      let baseUrl: String = self.sessionInfo?.cameraPreviewBaseUrl,
      let url: URL = URL(string: baseUrl + fullPath) else {
        return nil
    }

    let headers: [String: AnyObject] = ["Authorization": tokenValue as AnyObject]

    return HttpRequest(url: url,
                       method: .get,
                       json: "",
                       formParams: [:],
                       headers: headers,
                       cookies: [:])
  }
  
  public func configureSessionUrl(_ platform: ArcusPlatformInstance, host: String? = nil, port: Int? = nil) {
    guard let url: URL = url(true,
                             instanceType: platform,
                             host: host) else { return }
    self.platform = platform
    self.sessionUrl = url

    if state == .active || state == .loading {
      logout()
    } else {
      // If not logged in, then client must be configured w/ the session url in order to support HTTP requests
      // that can be initiated w/o a token.  (Create Account, Reset Password, Etc.)
      client.configureClient(url,
                             clientHeaders: sessionHeaders(),
                             clientCookies: [:],
                             socketConfig: SocketConfig.emptyConfig())
    }
  }
  
  // MARK: RxSwiftSession Implementation
  
  /**
   Observe Client Messages
   
   - Parameters:
   - rxClient: instance of class conforming to `RxSwiftClient`.
   */
  public func observeClientMessages(_ rxClient: RxSwiftClient) {
    rxClient.getMessages()
      .subscribe(
        onNext: { [weak self] message in
          self?.processClientMessage(message)
      })
      .addDisposableTo(disposeBag)
  }
  
  /**
   Observe Client Connection State
   
   - Parameters:
   - rxClient: instance of class conforming to `RxSwiftClient`.
   */
  public func observeClientState(_ rxClient: RxSwiftClient) {
    rxClient.getState()
      .subscribe(
        onNext: { [weak self] clientState in
          guard self?.state != .suspended && self?.state != .unreachable else {
            return
          }
          /**
           We are only concerned with updating state if the socket closes, because connecting to the socket
           will always be followed by a `SessionCreatedEvent`.
           */
          switch clientState {
          case .disconnected:
            self?.state = .inactive
          case .closed:
            self?.processLogout()
          default:
            break
          }
          
      })
      .addDisposableTo(disposeBag)
  }
  
  public func observeSessionEvents() {
    getEvents()
      .subscribe(
        onNext: { [weak self] event in
          // Handle SessionCreatedEvent
          if let sessionCreated = event as? SessionCreatedEvent {
            self?.processSessionCreated(sessionCreated)
          } else if let placeAddedEvent = event as? AccountAddPlaceResponse {
            guard let placeAttributes = placeAddedEvent.getPlace() as? [String: AnyObject] else { return }
            let place: PlaceModel = PlaceModel(attributes: placeAttributes)
            let placeInfo: PlaceInfo = PlaceInfo(place)
            self?.sessionInfo?.updatePlaceInfo(placeInfo)
          } else if let placeDeletedEvent = event as? PlaceDeleteResponse {
            self?.sessionInfo?.removePlaceInfo(placeDeletedEvent.source)
          } else if event is SessionServiceSetActivePlaceResponse {
            self?.state = .active
          }
      })
      .addDisposableTo(disposeBag)
  }
  
  public func startReachabilityHandler(_ handler: RxReachabilityHandler) {
    reachabilityHandler = handler
    reachabilityHandler?.startReachabilityNotifier()
    reachabilityHandler?.getReachabilityEvents()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
      .subscribe(
        onNext: { status in
          guard self.state != .suspended else { return }
          
          if status == .notReachable {
            self.state = .unreachable
            self.client.disconnect(true)
          } else {
            if self.state == .unreachable || self.state == .inactive {
              // Connect Socket.  Cannot call Connect(), because it guards against state == .unreachable
              if let config: ArcusSocketConfig = self.socketConfig,
                let url: URL = self.sessionUrl {
                self.client.configureClient(url,
                                            clientHeaders: self.sessionHeaders(),
                                            clientCookies: self.sessionCookies(),
                                            socketConfig: config)
              }
              self.client.connect()
            }
          }
      })
      .addDisposableTo(disposeBag)

    // Check initial reachability state
    if reachabilityHandler?.reachability?.isReachable == false {
      state = .unreachable
    }
  }

  public func suspendSession() -> Single<ArcusSessionStatus> {
    suspend()

    return Single<ArcusSessionStatus>.create { single in
      let timer = Observable<Int>.interval(15.0, scheduler: MainScheduler.instance)
      var timerDisposable: Disposable!
      timerDisposable = timer.subscribe(
        onNext: { [single] _ in
          // Produce Timeout Error
          single(.error(ClientError(errorType: .operationTimeout)))

          // Dispose of the timer.
          timerDisposable.dispose()
      })

      let disposable = self.getState().subscribe(onNext: { state in
        if state == .suspended {
          single(.success(state))
        }
      })
      return Disposables.create {
        disposable.dispose()
        timerDisposable.dispose()
      }
    }
  }

  public func resumeSession() -> Single<ArcusSessionStatus> {
    guard self.state == .suspended else {
      return Single<ArcusSessionStatus>.just(state)
    }

    resume()

    return Single<ArcusSessionStatus>.create { single in
      let timer = Observable<Int>.interval(15.0, scheduler: MainScheduler.instance)
      var timerDisposable: Disposable!
      timerDisposable = timer.subscribe(
        onNext: { [single] _ in
          // Produce Timeout Error
          single(.error(ClientError(errorType: .operationTimeout)))

          // Dispose of the timer.
          timerDisposable.dispose()
      })

      let disposable = self.getState().subscribe(onNext: { state in
        if state == .active {
          single(.success(state))
        }
      })
      return Disposables.create {
        disposable.dispose()
        timerDisposable.dispose()
      }
    }
  }

  // MARK: Private Functions

  /**
   Private function used to process `SessionCreateEvent`.
   
   - Parameters:
   - event: `SessionCreatedEvent` to process.
   */
  private func processSessionCreated(_ event: SessionCreatedEvent) {
    guard event.attributes.keys.count > 0 else { return }
    
    self.sessionInfo = SessionInfo(event.attributes)
    
    if let lastPlace = sessionInfo?.lastKnownPlaceId,
      sessionInfo?.places?.filter({ return $0.placeId == lastPlace }).count == 1 {
      setActivePlace(lastPlace)
    } else if let placeInfo = sessionInfo?.places?.first,
      let placeId = placeInfo.placeId {
      setActivePlace(placeId)
    }
  }
  
  /**
   Private function used to process `ArcusClientMessage`.
   
   - Parameters:
   - message: `ArcusClientMessage` to process.
   */
  private func processClientMessage(_ message: ArcusClientMessage) {
    // Result Event
    var event: ArcusSessionEvent = SessionMessageEvent(message)
    
    // If message is an error.
    if let errorEvent = message as? SessionErrorEvent {
      event = errorEvent
    } else if message.type == "Error" {
      event = SessionErrorEvent(message)
    }
    
    // If event is a response to a request, then produce response event.
    if let clientResponse = message as? ArcusClientResponse {
      do {
        if let responseEvent = try clientResponse.getResponseEvent() as? ArcusSessionEvent {
          event = responseEvent
        }
      } catch {} // TODO: Catch
    } else { // Model Cache related Events
      if message.type == Events.baseAdded
        || message.type == Events.baseValueChanged
        || message.type == Events.baseDeleted {
        event = SessionModelChangeEvent(message)
      } else if message.type == "SessionCreated" {
        event = SessionCreatedEvent(message)
        self.state = .loading
      } else if message.type == "sess:ActivePlaceCleared" {
        event = SessionActivePlaceClearedEvent(message)
      } else if message.type == "sess:SessionExpired" {
        processLogout(message)
        return
      } else {
        event = SessionMessageEvent(message)
      }
    }

    publishEvent(event)
  }
  /**
   Private convenience method to handle logout.

   - Parameters:
   - message: Optional `ArcusClientMessage`, defaults to nil.
   */
  private func processLogout(_ message: ArcusClientMessage? = nil) {
    // Clear activeUser and token from Keychain.
    clearActiveUser()
    clearToken()

    // Disconnect the client.
    disconnect()

    // Remove configuration from client
    client.configureClient(sessionUrl,
                           clientHeaders: sessionHeaders(),
                           clientCookies: [:],
                           socketConfig: SocketConfig.emptyConfig())

    // Clear session's socket config
    socketConfig = SocketConfig.emptyConfig()

    // Publish SessionEndedEvent
    if let message = message {
      publishEvent(SessionEndedEvent(message))
    } else {
      publishEvent(SessionEndedEvent())
    }

    // Update State.
    state = .ended
  }

  private func publishEvent(_ event: ArcusSessionEvent) {
    // Legacy Notification Handling.
    if let notifiableEvent = event as? ArcusNotifiableEvent {
      notifyForEvent(notifiableEvent)
    }
    eventObservable.onNext(event)
  }

  private func tokenBasedSocketConfig() -> ArcusSocketConfig? {
    guard let sessionUrl = sessionUrl,
      let url: URL = url(sessionUrl, path: "/websocket"),
      let headers = sessionHeaders() as? [String: String],
      let _ = headers["Authorization"] else {
        return nil
    }

    let config = SocketConfig(url,
                              headers: headers,
                              retryAttempts: Constants.Platform.retryAttempts,
                              retryDelay: Constants.Platform.retryDelay,
                              maxFrameSize: Constants.Platform.maxFrameSize)
    return config
  }
  
  /**
   Get ArcusPlatformInstance Type from defaults. Defaults to PROD if not found.
   
   - Returns: `ArcusPlatformInstance` enum from defaults if found.
   */
  fileprivate static func fetchPlatformType() -> ArcusPlatformInstance {
    let defaults: UserDefaults = UserDefaults.standard
    if let type: String = defaults.string(forKey: "PlatformType"),
      let instance = ArcusPlatformInstance(rawValue: type) {
      return instance
    }
    return .prod
  }
  
  fileprivate static func cachePlatformType(_ instance: ArcusPlatformInstance) {
    let defaults: UserDefaults = UserDefaults.standard
    let type: String = instance.rawValue
    defaults.set(type, forKey: "PlatformType")
    defaults.synchronize()
  }

  /**
   Private function used to reset active username and token to persisted value.
   */
  private func loadKeychains() -> Single<Void> {
    return Single<Void>.create { [weak self] single in
      let tokenSingle: Single<LSArcusKeychain> = self!.fetchActiveUser()
        .flatMap { keychain in
          self?.activeUser = keychain
          return self!.fetchToken(keychain.value)
      }
      let disposable = tokenSingle.subscribe(
        onSuccess: { [weak self] keychain in
          self?.token = keychain
          self?.socketConfig = self?.tokenBasedSocketConfig()
          single(.success())
        }, onError: { error in
          self?.socketConfig = SocketConfig.emptyConfig()
          single(.error(error))
      })
      disposable.disposed(by: self!.disposeBag)

      return Disposables.create {
        disposable.dispose()
      }
    }
  }

  /**
   Private function used to set the active username in the keychain.
   
   - Parameters:
   - username: `String` of the current active user.
   */
  private func setActiveUser(_ username: String) {
    activeUser = LSArcusKeychain(value: username, account: "arcusSession", service: "activeUser")
    if let keychain = activeUser as? LSArcusKeychain {
      saveKeychain(keychain)
    }
  }

  /**
   Private function used to fetch the active user from the keychain.
   
   - Returns: Single observable `ArcusKeychain` of the active user if found in the keychain.
   */
  private func fetchActiveUser() -> Single<LSArcusKeychain> {
    return LSArcusKeystore.fetchKeychain("arcusSession",
                                        service: "activeUser",
                                        retry: 5,
                                        delay: 0.5)
  }

  /**
   Private function used to save the token/account combination to the keychain.
   
   - Parameters:
   - value: `String` value of the token received from the platform.
   - account: `String` value of the user that successfully authenticated to the platform.
   */
  private func setToken(_ value: String, account: String) {
    token = LSArcusKeychain(value: value, account: account, service: "token")
    if let keychain = token as? LSArcusKeychain {
      saveKeychain(keychain)
    }
  }
  
  /**
   Private function used to fetch the token from the keychain.
   
   - Parameters:
   - account: `String` of the account used to look-up an existing token.
   
   - Returns: Single observable of `LSArcusKeychain` of the token if found in the keychain.
  */
  private func fetchToken(_ account: String) -> Single<LSArcusKeychain> {
    return LSArcusKeystore.fetchKeychain(account,
                                        service: "token",
                                        retry: 5,
                                        delay: 2.0)
  }

  private func fetchToken(_ account: String) -> ArcusKeychain? {
    if let keychain: LSArcusKeychain = LSArcusKeystore.fetchKeychain(account, service: "token") {
      return keychain
    }
    return nil
  }
  
  /**
   Private convenience function used to save a `LSArcusKeychain` to `LSArcusKeystore`.
   
   - Parameters:
   - keychain: `LSArcusKeychain` to save.
   */
  private func saveKeychain(_ keychain: LSArcusKeychain) {
    do {
      try LSArcusKeystore.saveKeychain(keychain)
    } catch {
      DDLogDebug(error.localizedDescription)
    }
  }
  
  /**
   Private convenience function used to create `HttpRequest` used to authenticate against the platform.
   
   - Parameters:
   - username: `String` of the user to attempt to login.
   - password: `String` of the password to be used to attempt to login.
   
   - Returns: Optional `HttpRequest` that can be used to authenticate against the platform.
   */
  private func authenticationRequest(_ username: String, password: String) -> HttpRequest? {
    guard let _ = sessionUrl,
      let url: URL = url(sessionUrl!, scheme: Constants.Platform.httpScheme, path: "/login") else {
        return nil
    }

    let formParams: [String: String] = ["user": username, "password": password]
    let headers = sessionHeaders()
    let cookies: [String: String] = [:]
    
    return HttpRequest(url: url,
                       method: .post,
                       json: "",
                       formParams: formParams,
                       headers: headers,
                       cookies: cookies)
  }
  
  /**
   Private convenience function used to create `HttpRequest` used to logout from the platform.
   
   - Returns: Optional `HttpRequest` that can be used to logout from the platform.
   */
  private func logoutRequest() -> HttpRequest? {
    guard sessionUrl != nil, let url: URL = url(sessionUrl!,
                                                scheme: Constants.Platform.httpScheme,
                                                path: "/logout") else {
                                                  return nil
    }
    
    let formParams: [String: String] = [:]
    let headers: [String: AnyObject] = ["Content-Type": "application/x-www-form-urlencoded" as AnyObject,
                                        "Host": url.host! as AnyObject]
    let cookies: [String: String] = [:]
    
    return HttpRequest(url: url,
                       method: .post,
                       json: "",
                       formParams: formParams,
                       headers: headers,
                       cookies: cookies)
  }

  private func sessionHeaders() -> [String: AnyObject] {
    guard let sessionUrl = sessionUrl,
      let url: URL = url(sessionUrl, path: "/websocket"),
      let host = url.host else {
        return [:]
    }

    var headers: [String: AnyObject] = ["Host": host as AnyObject,
                                        "User-Agent": userAgent as AnyObject,
                                        "X-Client-Version": clientVersion as AnyObject]

    if let token = token?.value {
      headers["Authorization"] = token as AnyObject
    }

    return headers
  }

  private func sessionCookies() -> [String: String] {
    var cookies: [String: String] = [:]
    if let tokenValue = token?.value {
      cookies = ["arcusAuthToken": tokenValue]
    }
    return cookies
  }

  /**
   Private function used to clear the activeUser keychain.
   */
  private func clearActiveUser() {
    guard let user = activeUser as? LSArcusKeychain else { return }
    
    clearKeychain(user)
    activeUser = nil
  }
  
  /**
   Private function used to clear the session token keychain.
   */
  private func clearToken() {
    guard let token = token as? LSArcusKeychain else { return }
    
    clearKeychain(token)
    self.token = nil
  }
  
  /**
   Private convenience function used to delete a class conforming to `ArcusKeychain`.
   
   - Parameters:
   - keychain: `ArcusKeychain` to be removed from the keychain.
   */
  private func clearKeychain(_ keychain: ArcusKeychain) {
    if let lsKeychain = keychain as? LSArcusKeychain {
      do {
        try LSArcusKeystore.deleteKeychain(lsKeychain)
      } catch {
        DDLogDebug(error.localizedDescription)
      }
    }
  }
}
