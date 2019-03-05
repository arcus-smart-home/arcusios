//
//  DashboardCamerasProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/5/17.
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
import Cornea

protocol DashboardCamerasProvider {
  // MARK: Extended
  func fetchDashboardCameras()
}

extension DashboardCamerasProvider where Self: DashboardProvider {
  func fetchDashboardCameras() {
    DispatchQueue.global(qos: .background).async {
      let viewModel = DashboardCamerasViewModel()

      let controller: CameraSubsystemController? = SubsystemsController.sharedInstance().camerasController
      if controller == nil || (controller?.allDeviceIds.count)! < 1 {
        self.storeViewModel(viewModel)
        return
      }

      viewModel.isEnabled = true

      var currentPlaceID = ""
      if let modelId: String = RxCornea.shared.settings?.currentPlace?.modelId {
        currentPlaceID = modelId
      }

      // TODO: FIX ME!  Update missing parameters!
      _ = VideoService.pageRecordings(withPlaceId: currentPlaceID as String,
                                      withLimit: 1,
                                      withToken: "",
                                      withAll: false,
                                      withInprogress: false,
                                      withType: kEnumRecordingTypeRECORDING,
                                      withLatest: 99999999999999.0,
                                      withEarliest: 0,
                                      withCameras: [String](), 
                                      withTags:[String]())
        .swiftThenInBackground({ res in
          guard let pageRecordingsResponse = res as? VideoServicePageRecordingsResponse,
            let recordings: [Any] = pageRecordingsResponse.getRecordings(),
            let first = recordings.first as? [String: AnyObject],
            let recordTime: Date = RecordingCapability.getTimestampFrom(RecordingModel(attributes: first)),
            var timeString: String = (recordTime as NSDate).formatDeviceLastEvent() else {
              return nil
          }
          if timeString.range(of: "at") != nil {
            while timeString.hasPrefix("a") || timeString.hasPrefix("t") {
              timeString.remove(at: timeString.startIndex)
            }
          }

          let timeComponents: [String] = timeString.components(separatedBy: ",")
          if timeComponents.count > 1 {
            timeString = timeComponents[0]
          }

          self.storeViewModel(viewModel)
          return nil
        })
    }
  }
}
