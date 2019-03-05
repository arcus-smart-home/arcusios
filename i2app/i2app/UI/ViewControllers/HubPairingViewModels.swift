//
//  HubPairingViewModels.swift
//  i2app
//
//  Created by Arcus Team on 5/29/17.
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
import Cornea

let hubIDPlaceHolder = "<hub>"
let errorPlaceholder = "<error>"

struct HubPairingViewModel {
  var percentageFinished: Double?
  var navTitle: String?
  var title: String?
  var subtitle: String?
  var buttonTitle: String?
  var buttonEnabled: Bool = true
  var textFieldPrompt: String?
  var warningText: String?
  var errorText: String?
  var hasBackButton: Bool = true
  var hasFactoryResetButton: Bool = false
  var exitPairingDisabled: Bool = true
}

// MARK: - Constants
// swiftlint:disable line_length

let PairingHubNavTitle = "Pairing Hub"
let PairingHubTitleFormat =
"Your Hub, \(hubIDPlaceHolder), is looking for a connection to the Arcus Cloud Platform."
let PairingHubSubtitle =
"It may take a 5-10 minutes to connect your Hub to the Arcus Cloud Platform. Depending on your Hub type, " +
"your light will either blink or rotate while connecting."

let SearchingForHubNavTitle = "Searching For Hub"
let SearchingForHubTitleFormat =
"Your Hub, \(hubIDPlaceHolder), is looking for a connection to the Arcus Cloud Platform."

let SearchingForHubTextFieldPrompt = "Wrong Hub ID? No worries.\nEnter the correct Hub ID below:"
let SearchingForHubButtonTitle = "Continue"

let HubErrorNavTitle = "Hub Error"
let HubErrorButtonTitle = "Call Support"

let UpdateAvailableNavTitle = "Update Available"
let UpdateAvailableTitle = "Your Hub is downloading the latest firmware."
let UpdateAvailableSubtitle = "This may take 5-10 minutes depending on the speed of your internet " +
"connection. \n\n Once the update is installed, the Hub will reboot automatically."

let DownloadFailedNavTitle = "Download Failed"
let DownloadFailedTitle = "There was an issue downloading the hub's firmware."
let DownloadFailedSubtitle = "Tap the Call Support button below to speak with our Support team."
let DownloadFailedButtonTitle = "Call Support"

let ApplyingUpdateNavTitle = "Applying Update"
let ApplyingUpdateTitle = "Your Hub is applying the latest firmware."
let ApplyingUpdateSubtitle = "This may take a few minutes and it will reboot. It is normal for the " +
"hub to flash several lights during the reboot process."

let InstallFailedNavTitle = "Install Failed"
let InstallFailedTitle = "There was an issue installing the hub's firmware."
let InstallFailedSubtitle = "Tap the Call Support button below to speak with our Support team."
let InstallFailedButtonTitle = "Call Support"

let Error01Title = "Please make sure the Hub ID, \(hubIDPlaceHolder), was entered correctly. " +
"Tap the Call Support button below to speak with our Support team."
let Error02Title = "Please make sure the Hub ID, \(hubIDPlaceHolder), was entered correctly. " +
"If it is accurate, a factory reset of the hub is required to resolve the issue."

let TimeoutWarningTextFormat = "Hub ID, \(hubIDPlaceHolder), is taking longer than usual."

let HubErrorCodeTextFormat = "Your Hub, \(hubIDPlaceHolder), is reporting error code \(errorPlaceholder). "
