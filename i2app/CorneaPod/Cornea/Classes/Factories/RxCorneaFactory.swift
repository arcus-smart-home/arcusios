//
//  RxCorneaFactory.swift
//  i2app
//
//  Created by Arcus Team on 7/19/17.
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
import CocoaLumberjack
/**
 `RxCorneaFactory`
 */
internal class RxCorneaFactory: CorneaFactory,
ArcusSessionFactory,
ArcusClientFactory,
ArcusSocketFactory,
ArcusModelCacheFactory,
ArcusSettingsFactory {
  
  static func build() -> RxCornea {
    guard let cornea = RxCorneaFactory.createCornea() as? RxCornea else {
      DDLogError("RxCornea could not be properly instantiated.")
      return RxCornea()
    }
    return cornea
  }

  static func createCornea() -> Cornea {
    let socket = createArcusSocket(SocketConfig.emptyConfig())
    let client = createArcusClient(socket)
    let session = createArcusSession(client)
    let cache = createArcusModelCache(session)
    let settings = createArcusSettings(session, cache: cache)
    let cacheLoader = createArcusModelCacheLoader(settings)

    let cornea = RxCornea()
    cornea.session = session
    cornea.modelCache = cache
    cornea.cacheLoader = cacheLoader
    cornea.settings = settings

    return cornea
  }

  static func createArcusSession(_ client: ArcusClient) -> ArcusSession {
    let session = RxArcusSession(client)
    session.startReachabilityHandler(ReachabilityHandler())

    return session
  }

  static func createArcusClient(_ socket: ArcusSocket) -> ArcusClient {
    return RxArcusClient(socket)
  }

  static func createArcusSocket(_ config: ArcusSocketConfig) -> ArcusSocket {
    let socket = SSArcusSocket()
    socket.config = config

    return socket
  }

  static func createArcusModelCache(_ session: ArcusSession) -> ArcusModelCache {
    let cache = RxArcusModelCache()
    if let rxSession = session as? RxSwiftSession {
      cache.observeModelChangeEvents(rxSession)
    }

    return cache
  }

  static func createArcusModelCacheLoader(_ settings: ArcusSettings) -> ArcusModelCacheLoader {
    let cacheLoader = RxArcusModelCacheLoader()
    if let rxSettings = settings as? RxSwiftSettings {
      cacheLoader.observeSettingsEvents(rxSettings)
    }

    return cacheLoader
  }

  static func createArcusSettings(_ session: ArcusSession, cache: ArcusModelCache) -> ArcusSettings {
    let settings = RxArcusSettings()
    if let rxSession = session as? RxArcusSession {
      settings.observeSessionEvents(rxSession)
    }
    if let rxCache = cache as? RxArcusModelCache {
      settings.observeModelCacheEvents(rxCache)
    }

    return settings
  }
}
