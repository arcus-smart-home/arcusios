//
//  AnalyticsAppService.swift
//  i2app
//
//  Created by Arcus Team on 11/14/17.
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

import RxSwift
import Cornea

/**

 */
class AnalyticsAppService: ArcusApplicationServiceProtocol, ArcusPlaceCapability {

  /**

   */
  let disposeBag = DisposeBag()

  /**

   */
  required init(eventPublisher: ArcusApplicationServiceEventPublisher) {
    observeApplicationEvents(eventPublisher)
  }

  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent) {
    setUpApptentive()
    setUpGlobalTags()
  }

  func serviceDidBecomeActive(_ event: ArcusApplicationServiceEvent) {
    ArcusAnalytics.tag(named: AnalyticsTags.Background)
  }

  private func setUpGlobalTags() {
    GlobalTagAttributes.getInstance().put(AnalyticsTags.PersonIdKey) { () -> AnyObject in
      guard let value = RxCornea.shared.settings?.currentPerson?.modelId else {
        return "" as AnyObject
      }
      return value as AnyObject
    }

    GlobalTagAttributes.getInstance().put(AnalyticsTags.PlaceIdKey) { () -> AnyObject in
      guard let value = RxCornea.shared.settings?.currentPlace?.modelId else {
        return "" as AnyObject
      }
      return value as AnyObject
    }

    // TODO: Add number of paired devices to each tag
    GlobalTagAttributes.getInstance().put(AnalyticsTags.DeviceCount) { () -> AnyObject in
      return "" as AnyObject
    }
    
    GlobalTagAttributes.getInstance().put(AnalyticsTags.Source) { () -> AnyObject in
      return "IOS" as AnyObject
    }
    
    GlobalTagAttributes.getInstance().put(AnalyticsTags.Version) { () -> AnyObject in
      guard let dictionary = Bundle.main.infoDictionary,
        let appVersion = dictionary["CFBundleShortVersionString"] else {
          return "" as AnyObject
      }
      return appVersion as AnyObject
    }

    GlobalTagAttributes.getInstance().put(AnalyticsTags.ServiceLevel) { () -> AnyObject in
      guard let currentPlace = RxCornea.shared.settings?.currentPlace else {
        return "" as AnyObject
      }

      if let serviceLevel = self.getPlaceServiceLevel(currentPlace) {
        return serviceLevel.rawValue as AnyObject
      } else {
        return "UNKNOWN" as AnyObject
      }
    }
  }

  private func setUpApptentive() {
    let apptentiveRouteBuilder = TagRouteBuilder.routeTagsMatchingAny(ApptentiveAnalyticsEndpoint())
    _ = apptentiveRouteBuilder.whereNameEquals(AnalyticsTags.DashboardHistoryClick)
    _ = apptentiveRouteBuilder.whereNameEquals(AnalyticsTags.Dashboard)

    ArcusAnalytics.deleteAllRoutes()
    ArcusAnalytics.addRoute(TagRouteBuilder.routeAllTagsTo(LogAnalyticsEndpoint()))
    ArcusAnalytics.addRoute(TagRouteBuilder.routeAllTagsTo(FabricAnalyticsEndpoint()))
    ArcusAnalytics.addRoute(TagRouteBuilder.routeAllTagsTo(CorneaAnalyticsEndpoint()))
    ArcusAnalytics.addRoute(apptentiveRouteBuilder.build())
  }

}
