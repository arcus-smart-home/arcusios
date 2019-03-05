//
//  RxSwannWifiSmartSwitchConfigClient.swift
//  i2app
//
//  Created by Arcus Team on 5/9/18.
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
import Cornea

extension Constants {
  static let kWSSAddress: String = "192.168.1.1"
  static let kWSSPort: Int = 2501
}

/**
 `RxSwannSmartSwitchConfigClient` is a concrete utility that implements `ArcusSimpleSocket` and
 conforms to `ArcusSimpleSocketDelegate`, and is used to configure a WiFi Smart Switch's network settings.
 - seealso: `WSSPairingPresenter`
 */
class RxSwannSmartSwitchConfigClient: WSSConfigurator {
  // Communication Socket
  var socket: ArcusSimpleSocket!

  // WiFi Config Requests
  var ssidRequest: SwannSmartSwitchPairingRequest!
  var keyRequest: SwannSmartSwitchPairingRequest!
  var macRequest: SwannSmartSwitchPairingRequest!
  var resetRequest: SwannSmartSwitchPairingRequest!

  // Indicates if the an attempt to connect is the first attempt.
  var intialConnection: Bool = true

  // Typealias used by `delegateSubject`.
  typealias ResponseTuple = (message: SwannSmartSwitchPairingRequest, data: NSData)

  // PublishSubject used to communicate `ArcusSimpleSocketDelegate` callbacks privately.
  fileprivate let delegateSubject: PublishSubject<ResponseTuple> = PublishSubject<ResponseTuple>()

  // Connected is a private Variable<Bool> used to inidicate when the switch has been connecte.
  fileprivate var connected: Variable<Bool> = Variable<Bool>(false)

  // MARK: - Initialization

  init() {
    // Create MAC & Reset requests as they do not require payloads.
    self.macRequest = SwannSmartSwitchPairingRequest(type: .getMAC)
    self.resetRequest = SwannSmartSwitchPairingRequest(type: .reset)

    // Create the socket to communicate with the switch.
    self.socket = ArcusSimpleSocket(delegate: self)
  }

  // MARK: - Configure Switch Method

  func provisionSwitch(_ ssid: String, key: String) -> Single<String> {
    // Create SSID & Key requests with received params as payload.
    self.ssidRequest = SwannSmartSwitchPairingRequest(type: .setSSID,
                                                      payload: ssid)

    self.keyRequest = SwannSmartSwitchPairingRequest(type: .setKey,
                                                     payload: key)

    // Attempt to connect to the switch.
    return connect().flatMap { _ in
      // Once connected, attempt to provision the switch with the pre-configured requests.
      return self.startConfigurationAttempt()
    }
  }

  // MARK: - Private Network Configuration Methods

  /**
   Private method used to attempt to connect to the switch.

   - Returns: Observable Single indicating if the switch is connected.
   */
  private func connect() -> Single<Void> {
    return Single<Void>.create { single in
      let timer = Observable<Int>.interval(120.0, scheduler: MainScheduler.instance)
      let timerDisposable = timer.subscribe(
        onNext: { _ in
          single(.error(ClientError(errorType: .unknown)))
      })

      // Subscribe to connection state.
      let disposable = self.connected
        .asObservable()
        .subscribe(
          onNext: { isConnected in
            // Return success if connected.
            if !self.intialConnection && isConnected {
              single(.success())
            }
        })

      // Attempt to connect to the switch.
      self.socket.connect(Constants.kWSSAddress, port: Constants.kWSSPort)

      return Disposables.create {
        // Dispose of connection state subscriptions.
        timerDisposable.dispose()
        disposable.dispose()
      }
    }
  }

  /**
   Method used to start network configuration attempt.  Requires that the switch is already connected.

   - Returns: Observable Single that returns the switch's MAC address if configuration is successful.
   */
  private func startConfigurationAttempt() -> Single<String> {
    // Request MAC Address from Switch
    return requestMAC()
      .flatMap { mac in
        // Set Switch SSID
        return self.configureSSID(mac)
      }
      .flatMap { mac in
        // Set Switch Network Key
        return self.configureKey(mac)
      }
      .flatMap { mac in
        // Reset The Swtich
        return self.sendReset(mac)
      }
  }

  // MARK: - Convenience Methods

  /**
   Private convenience method for requesting the MAC address from the WiFi Smart Switch.

   - Returns: Observable Single that returns the switch's MAC address.
   */
  private func requestMAC() -> Single<String> {
    // Send the MAC Request message.
    self.socket.sendMessage(self.macRequest)

    // Subscribe to `delegateSubject` and create single/trigger onSuccess/onError based on response.
    return Single<String>.create { [delegateSubject, macRequest] single in
      let disposable = delegateSubject
        .filter {
          // Observe only request MAC messages.
          $0.message.type == macRequest?.type
        }
        .subscribe(
          onNext: { [single] response in
            let macAddress: String = response.message.messageReceived(response.data)
            single(.success(macAddress))
        })
      return Disposables.create {
        disposable.dispose()
      }
    }
  }

  /**
   Private convenience method for configuring the WiFi Smart Switch's netowrk.

   - Returns: Observable Single that indicates if configuration was successful.
   */
  private func configureSSID(_ macAddress: String = "") -> Single<String> {
    // Send the SSID Config Request message.
    self.socket.sendMessage(self.ssidRequest)

    // Subscribe to `delegateSubject` and create single/trigger onSuccess/onError based on response.
    return Single<String>.create { [delegateSubject, ssidRequest, macAddress] single in
      let disposable = delegateSubject
        .filter {
          // Observe only ssid config messages.
          $0.message.type == ssidRequest?.type
        }
        .subscribe(
          onNext: { [single, macAddress] response in
            // Verify received a good response, or produce .badMessage error.
            if response.message.messageReceived(response.data) ==
              SwannSmartSwitchPairingResponseMessage.goodMessageResponse {
              single(.success(macAddress))
            } else {
              single(.error(WSSConfigError(type: .badMessage)))
            }
        })
      return Disposables.create {
        disposable.dispose()
      }
    }
  }

  /**
   Private convenience method for configuring the WiFi Smart Switch's netowrk key.

   - Returns: Observable Single that indicates if configuration was successful.
   */
  private func configureKey(_ macAddress: String = "") -> Single<String> {
    // Send the Key Config Request message.
    self.socket.sendMessage(self.keyRequest)

    // Subscribe to `delegateSubject` and create single/trigger onSuccess/onError based on response.
    return Single<String>.create { [delegateSubject, keyRequest, macAddress] single in
      let disposable = delegateSubject
        .filter {
          // Observe only key config messages.
          $0.message.type == keyRequest?.type
        }
        .subscribe(
          onNext: { [single, macAddress] response in
            // Verify received a good response, or produce .badMessage error.
            if response.message.messageReceived(response.data) ==
              SwannSmartSwitchPairingResponseMessage.goodMessageResponse {
              single(.success(macAddress))
            } else {
              single(.error(WSSConfigError(type: .badMessage)))
            }
        })
      return Disposables.create {
        disposable.dispose()
      }
    }
  }

  /**
   Private convenience method for requesting a reset of the WiFi Smart Switch.  Reset will sometimes occur
   without a response from the switch.  So this method will use a timer to attempt to confirm reset and
   close the socket after 5 seconds.

   - Returns: Observable Single that idicates if the switch was reset.
   */
  private func sendReset(_ macAddress: String = "") -> Single<String> {
    // Send the Reset Request message.
    self.socket.sendMessage(self.resetRequest)

    // Device will sometimes reset before response is sent, therefore must
    // manually check for timeout
    let timer = Observable<Int>.interval(5.0, scheduler: MainScheduler.instance)
    var timerDisposable: Disposable!
    timerDisposable = timer.subscribe(
      onNext: { _ in
        // Dispose of the timer.
        timerDisposable.dispose()
    },
      onDisposed: { [socket] _ in
        // Close the socket.
        socket?.close()
    })

    // Subscribe to `delegateSubject` and create single/trigger onSuccess/onError based on response.
    let single = Single<String>.create { [delegateSubject, resetRequest, macAddress] single in
      // Create delegate subscription.
      let disposable = delegateSubject
        .filter {
          // Observe only reset messages.
          $0.message.type == resetRequest?.type
        }
        .subscribe(
          onNext: { [single, macAddress] response in
            // Verify received a good response, or produce .badMessage error.
            if response.message.messageReceived(response.data) ==
              SwannSmartSwitchPairingResponseMessage.goodMessageResponse {
              single(.success(macAddress))
            } else {
              single(.error(WSSConfigError(type: .badMessage)))
            }
          },
          onError: { [single] error in
            single(.error(error))
        })
      return Disposables.create {
        // Dispose of the delegate subscription.
        disposable.dispose()
      }
    }

    // Side Effects:  Dispose of the timer if the reset response is received.
    _ = single.do(
      onNext: { [timerDisposable] _ in
        timerDisposable?.dispose()
      },
      onError: { [timerDisposable] _ in
        timerDisposable?.dispose()
    })

    return single
  }
}

extension RxSwannSmartSwitchConfigClient: ArcusSimpleSocketDelegate {

  // MARK: - ArcusSimpleSocketDelegate Methods

  func socketReadyForMessage(_ socket: ArcusSimpleSocket) {
    // Only set connected on the first readyForMessage callback.
    // This is used instead of the `socketDidConnect()` method because the WiFiSmartSwitch does not
    // give a proper didConnect() callback.
    if intialConnection == true {
      intialConnection = false
      connected.value = true
    }
  }

  func socketConnectionFailed(_ socket: ArcusSimpleSocket, reason: NSError) {
    // Update connection state.
    intialConnection = true
    connected.value = false
  }

  func socketReceivedMessage(_ socket: ArcusSimpleSocket,
                             request: ArcusSimpleSocketMessageProtocol,
                             data: NSData) {
    // Add message to the delegateSubect.
    if let swannRequest: SwannSmartSwitchPairingRequest = request as? SwannSmartSwitchPairingRequest {
      delegateSubject.onNext((swannRequest, data))
    }
  }

  func socketReceivedError(_ socket: ArcusSimpleSocket,
                           request: ArcusSimpleSocketMessageProtocol,
                           error: NSError) {
    // Forward message to delegateSubject.
    delegateSubject.onError(error)
  }

  func socketDidClose(_ socket: ArcusSimpleSocket) {
    intialConnection = true
    connected.value = false
  }

  // MARK: ArcusSimpleSocketDelegate Unused Methods

  func socketDidConnect(_ socket: ArcusSimpleSocket) {}
}
