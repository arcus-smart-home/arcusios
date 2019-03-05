//
//  AnalyticsTags.swift
//  i2app
//
//  Created by Arcus Team on 7/22/16.
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

import UIKit
import Cornea

class AnalyticsTags: NSObject {

  // Tag Keys
  static let TargetAddressKey = "target.address"
  static let PersonIdKey = "person.id"
  static let PlaceIdKey = "place.id"
  static let SelectedState = "selected.state"
  static let SelectedType = "selected.type"
  static let SelectedItem = "selected.item"
  static let SelectedStep = "selected.step"
  static let DeviceCount = "device.count"
  static let ServiceLevel = "service.level"
  static let TrackerState = "tracker.state"
  static let Source = "source"
  static let Version = "version"

  // Alarm Events

  static let AlarmsStatusSecurity              = "arcus.client.alarms.security"
  static let AlarmsStatusSecurityOn            = "arcus.client.alarms.security.on"
  static let AlarmsStatusSecurityPartial       = "arcus.client.alarms.security.partial"
  static let AlarmsStatusSecurityOff           = "arcus.client.alarms.security.off"
  static let AlarmsStatusSecurityCancelled     = "arcus.client.alarms.security.canceled"

  static let AlarmsDevices                     = "arcus.client.alarms.security.devices"
  static let AlarmsDevicesSmokeDevice          = "arcus.client.alarms.smoke.devices"
  static let AlarmsDevicesCoDevice             = "arcus.client.alarms.co.devices"
  static let AlarmsDevicesWaterDevice          = "arcus.client.alarms.water.devices"
  static let AlarmsDevicesSecurityDevice       = "arcus.client.alarms.security.devices"

  static let AlarmsTracker                     = "arcus.client.alarms.tracker.launched"
  static let AlarmsTrackerAutoDismissed        = "arcus.client.alarms.tracker.dismissed"
  static let AlarmsTrackerCancelled            = "arcus.client.alarms.tracker.canceled"
  static let AlarmsTrackerConfirmed            = "arcus.client.alarms.tracker.confirmed"

  static let AlarmsActivity                    = "arcus.client.alarms.alarms.activity"
  static let AlarmsActivityFilter              = "arcus.client.alarms.activity.filter"
  static let AlarmsActivityFilterSecurityPanic = "arcus.client.alarms.activity.filter.securitypanic"
  static let AlarmsActivityFilterSmokeCo       = "arcus.client.alarms.activity.filter.smokeco"
  static let AlarmsActivityFilterWater         = "arcus.client.alarms.activity.filter.water"
  static let AlarmsActivityIncident            = "arcus.client.alarms.activity.incident"

  static let AlarmsGlobalSounds                = "arcus.client.alarms.settings.sounds"
  static let AlarmsGlobalSoundsSecurityOn      = "arcus.client.alarms.settings.sounds.security.on"
  static let AlarmsGlobalSoundsSecurityOff     = "arcus.client.alarms.settings.sounds.security.off"
  static let AlarmsGlobalSoundsSmokeCoOn       = "arcus.client.alarms.settings.sounds.smokeco.on"
  static let AlarmsGlobalSoundsSmokeCoOff      = "arcus.client.alarms.settings.sounds.smokeco.off"
  static let AlarmsGlobalSoundsWaterOn         = "arcus.client.alarms.settings.sounds.water.on"
  static let AlarmsGlobalSoundsWaterOff        = "arcus.client.alarms.settings.sounds.water.off"

  static let AlarmsNotification                = "arcus.client.alarms.settings.notification"
  static let AlarmsNotificationAdded           = "arcus.client.alarms.settings.notification.added"
  static let AlarmsNotificationRemoved         = "arcus.client.alarms.settings.notification.removed"

  static let AlarmsMoreGrace                   = "arcus.client.alarms.settings.grace"
  static let AlarmsMoreGraceOnEntrance         = "arcus.client.alarms.settings.grace.on.entrance"
  static let AlarmsMoreGraceOnExit             = "arcus.client.alarms.settings.grace.on.exit"
  static let AlarmsMoreGracePartialEntrance    = "arcus.client.alarms.settings.grace.partial.entrance"
  static let AlarmsMoreGracePartialExit        = "arcus.client.alarms.settings.grace.partial.exit"

  static let AlarmsRequirements                = "arcus.client.alarms.settings.requirements"
  static let AlarmsRequirementsOn              = "arcus.client.alarms.settings.requirements.on"
  static let AlarmsRequirementsPartial         = "arcus.client.alarms.settings.requirements.partial"

  static let AlarmsWaterOn                     = "arcus.client.alarms.settings.water.on"
  static let AlarmsWaterOff                    = "arcus.client.alarms.settings.water.off"

  static let AlarmsProMonBannerClicked         = "arcus.client.alarms.banner"

  // Dashboard Events
  static let Dashboard = "arcus.client.dashboard"
  static let DashboardPlaceSelect = "arcus.client.dashboard.place.select"
  static let DashboardAddClick = "arcus.client.dashboard.add.menu"
  static let DashboardCareClick = "arcus.client.dashboard.care"
  static let DashboardHistoryClick = "arcus.client.dashboard.history"
  static let DashboardSafetyClick = "arcus.client.dashboard.safety"
  static let DashboardSecurityClick = "arcus.client.dashboard.security"
  static let DashboardLightswitchesClick = "arcus.client.dashboard.lightsswitches"
  static let DashboardClimateClick = "arcus.client.dashboard.climate"
  static let DashboardDoorslocksClick = "arcus.client.dashboard.doorslocks"
  static let DashboardHomeFamilyClick = "ris.client.dashboard.homefamily"
  static let DashboardCamerasClick = "arcus.client.dashboard.cameras"
  static let DashboardWaterClick = "arcus.client.dashboard.water"
  static let DashboardLawnGardgenClick = "arcus.client.dashboard.lawngarden"
  static let DashboardFavoritesScene = "arcus.client.dashboard.favorites.scene"

  // Favorites Events
  static let FavoritesClick = "arcus.client.dashboard.favorites.click"
  static let FavoritesDeviceClick = "arcus.client.dashboard.favorites.device"
  static let FavoritesSceneClick = "arcus.client.dashboard.favorites.scene"

  // Dashboard Settings
  static let DashboardSettings = "arcus.client.dashboard.settings"
  static let DashboardSettingsBackground = "arcus.client.dashboard.settings.background"
  static let DashboardSettingsBackgroundChanged = "arcus.client.dashboard.settings.background.changed"
  static let DashboardSettingsBackgroundCamera = "arcus.client.dashboard.settings.background.camera"
  static let DashboardSettingsBackgroundGallery = "arcus.client.dashboard.settings.background.gallery"
  static let DashboardSettingsFavorites = "arcus.client.dashboard.settings.favorites"
  static let DashboardSettingsFavoritesEditStart = "arcus.client.dashboard.settings.favorites.edit.start"
  static let DashboardSettingsFavoritesEditEnd = "arcus.client.dashboard.settings.favorites.edit.end"
  static let DashboardSettingsFavoritesEditReorder = "arcus.client.dashboard.settings.favorites.edit.reorder"
  static let DashboardSettingsFavoritesEditRemove = "arcus.client.dashboard.settings.favorites.edit.remove"

  // History Filters
  static let HistoryFilter = "arcus.client.history.filter"
  static let HistoryFilterDay = "arcus.client.history.filter.day"
  static let HistoryFilterDayToday = "arcus.client.history.filter.day.today"
  static let HistoryFilterDayYesterday = "arcus.client.history.filter.day.yesterday"
  static let HistoryFilterDay2WeeksAgo = "arcus.client.history.filter.day.weeksago"
  static let HistoryFilterVariableDays = "arcus.client.history.filter.day.daysago"
  static let HistoryFilterDaysAgo = "arcus.client.history.filter.day.daysago"
  static let HistoryFilterDevice = "arcus.client.history.filter.device"
  static let HistoryFilterDevice1Device = "arcus.client.history.filter.device.onedevice"

  // Left Sliding Menu
  static let LeftSlidingMenuDashboard = "arcus.client.nav.dashboard"
  static let LeftSlidingMenuDevice = "arcus.client.nav.devices"
  static let LeftSlidingMenuSettings = "ris.client.nav.settings"
  static let LeftSlidingMenuSupport = "arcus.client.nav.support"
  static let LeftSlidingMenuShop = "arcus.client.nav.show"
  static let LeftSlidingMenuRule = "arcus.client.nav.rules"
  static let LeftSlidingMenuScene = "arcus.client.nav.scenes"
  static let LeftSlidingMenuLogout = "arcus.client.nav.logout"

  // Add Clicks
  static let AddHubClick = "arcus.client.dashboard.add.hub"
  static let AddDeviceClick = "arcus.client.dashboard.add.device"
  static let AddPlaceClick = "arcus.client.dashboard.add.place"
  static let AddPersonClick = "arcus.client.dashboard.add.person"
  static let AddRuleClick = "arcus.client.dashboard.add.rule"
  static let AddSceneClick = "arcus.client.dashboard.add.scene"
  static let AddBehaviorClick = "arcus.client.dashboard.add.behavior"
  
  // Rules
  static let RulesMyRules = "arcus.client.rules.myrules" // N/A
  static let RulesLibrary = "arcus.client.rules.library" // N/A
  static let RulesTutorial = "arcus.client.rules.tutorial" // N/A

  // Security
  static let SecurityAlarm = "arcus.client.alarms.security"
  static let SecurityAlarmFullyArmed = "arcus.client.alarms.security.fullyarmed"
  static let SecurityAlarmPartiallyArmed = "arcus.client.alarms.security.partialarmed"
  static let SecurityAlarmDisarmed = "arcus.client.alarms.security.disarmed"

  // Safety alarm
  static let SafetyAlarm = "arcus.client.alarms.safety"

  // Care alarm
  static let CareAlarm = "arcus.client.alarms.care"
  static let CareAlarmOn = "arcus.client.alarms.care.on"
  static let CareAlarmOff = "arcus.client.alarms.care.off"
  static let CareGraphSwiped = "arcus.client.care.graph.swiped"

  // Lights & Switches
  static let LightsSwitchesScheduleEventAdded = "arcus.client.lightswitches.schedule.event.add"

  // Climate
  static let ClimateScheduleEventAdded = "arcus.client.climate.schedule.event.add"
  static let ClimateModeChanged = "arcus.client.climate.mode.change"
  static let ClimateTempTab = "arcus.client.climate.temp"

  // Devices
  static let DeviceRgbTuned = "arcus.client.device.rgb.tuned"
  static let DeviceCameraStreamOpened = "arcus.client.device.stream.opened"
  static let DeviceCameraStreamClosed = "arcus.client.device.stream.closed"
  static let DeviceCameraStreamTimeout = "arcus.client.device.stream.timeout"
  static let DeviceCameraStreamError = "arcus.client.device.stream.error"
  static let DeviceCameraStreamFailed = "arcus.client.device.stream.failed"

  // Forgot Password
  static let ForgotPassword = "arcus.client.login.forgot"
  static let ForgotPasswordStepStarted = "arcus.client.login.forgot.start"
  static let ForgotPasswordStepEmailSent = "arcus.client.login.forgot.email"
  static let ForgotPasswordCodeEntered = "arcus.client.login.forgot.code"
  
  // Account Creation
  static let AccountCreationBillingSkipCreditCard = "arcus.client.account.create.skipcreditcard"
  
  // Hub Pairing
  static let HubPairingComplete = "arcus.client.hub.pairing.complete"
  static let HubPairingFailedUserError = "arcus.client.hub.pairing.failed.usererror"
  static let HubPairingFailedOrphanHub = "arcus.client.hub.pairing.failed.orphanedhub"
  static let HubPairingFailedAlreadyRegistered = "arcus.client.hub.pairing.failed.alreadyregistered"
  static let HubPairingFailedActiveHub = "arcus.client.hub.pairing.failed.activehub" // N/A
  static let HubPairingFailedFWUpgrade = "arcus.client.hub.pairing.failed.fwupgrade"
  
  // Device Pairing
  static let DevicePairingFatalError = "arcus.client.device.pairing.fatalerror"
  static let DevicePairingComplete = "arcus.client.device.pairing.complete"
  static let DevicePairingFailedMispaired = "arcus.client.device.pairing.failed.mispaired" // N/A
  static let DevicePairingFailedMisconfigured = "arcus.client.device.pairing.failed.misconfigured" // N/A
  static let DevicePairingCartFatalError = "arcus.client.device.pairing.cart.fatalerror"
  static let DevicePairingRemove = "arcus.client.device.pairing.remove"
  static let DevicePairingForceRemove = "arcus.client.device.pairing.forceremove"
  static let DevicePairingCustomizeName = "arcus.client.device.pairing.customize.name"
  static let DevicePairingCustomizePresenceAssignment = "arcus.client.device.pairing.customize.presenceassignment"
  static let DevicePairingCustomizeContactType = "arcus.client.device.pairing.customize.contacttype"
  static let DevicePairingCustomizeSecurityMode = "arcus.client.device.pairing.customize.securitymode"
  static let DevicePairingCustomizeMultiButtonAssignment = "arcus.client.device.pairing.customize.multibuttonassignment"
  static let DevicePairingCustomizeRoom = "arcus.client.device.pairing.customize.room"
  static let DevicePairingCustomizeWeatherRadioStation = "arcus.client.device.pairing.customize.weatherradiostation"
  static let DevicePairingCustomizeStateCountySelect = "arcus.client.device.pairing.customize.statecountyselect"
  static let DevicePairingCustomizeWaterHeater = "arcus.client.device.pairing.customize.waterheater"
  static let DevicePairingCustomizeIrrigationZone = "arcus.client.device.pairing.customize.irrigationzone"
  static let DevicePairingCustomizeMultiIrrigationZone = "arcus.client.device.pairing.customize.multiirrigationzone"
  
  // Rules
  static let RuleAdd = "arcus.client.rules.add"
  static let RuleCategory = "arcus.client.rules.add.category"
  static let RuleCategoryClick = "arcus.client.rules.add.category"
  static let RuleDelete = "arcus.client.rules.delete"
  static let RuleEditSchedule = "arcus.client.rules.schedule.edit"
  static let RuleScheduleEventAdded = "arcus.client.rules.schedule.event.add"
  
  // Scenes AnalyticsTags
  static let SceneAdd = "arcus.client.scenes.add"
  static let SceneExamples = "arcus.client.scenes.examples" // N/A
  static let SceneTutorial = "arcus.client.scenes.tutorial" // N/A
  static let SceneFav = "arcus.client.scenes.fav"
  static let SceneDelete = "arcus.client.scenes.delete"
  static let SceneEdit = "arcus.client.scenes.edit"
  static let SceneScheduleEdit = "arcus.client.scenes.schedule.edit  "
  static let SceneScheduleEventAdd = "arcus.client.scenes.schedule.event.add"
  
  // Navigation
  static let NavigationAboutUs = "arcus.client.nav.aboutus" // N/A
  static let NavigationBlog = "arcus.client.nav.blog" // N/A
  static let NavigationTwitter = "arcus.client.nav.twitter" // N/A
  static let NavigationFacebook = "arcus.client.nav.facebook" // N/A
  static let NavigationYoutube = "arcus.client.nav.youtube" // N/A
  static let NavigationBuy = "arcus.client.nav.buy" // N/A
  static let NavigationSidebar = "arcus.client.nav.sidebar"
  
  // Dashboard Info
  static let DashboardCamerasStorage = "arcus.client.dashboard.cameras.storage"
  static let DashboardCamerasInfo = "arcus.client.dashboard.cameras.info"
  static let DashboardCareInfo = "arcus.client.dashboard.care.info"
  static let DashboardClimateInfo = "arcus.client.dashboard.climate.info"
  static let DashboardDoorslocksInfo = "arcus.client.dashboard.doorslocks.info"
  static let DashboardLawngardenInfo = "arcus.client.dashboard.lawngarden.info"
  static let DashboardLightsswitchesInfo = "arcus.client.dashboard.lighsswitches.info"
  static let DashboardHomefamilyInfo = "arcus.client.dashboard.homefamily.info"
  static let DashboardWaterInfo = "arcus.client.dashboard.water.info"
  
  // Account Creation
  static let AccountDelete = "arcus.client.account.delete"
  static let AccountCreateLogin = "arcus.client.account.create.login"
  static let AccountCreateZipcode = "arcus.client.account.create.zipcode" // N/A
  static let AccountCreateName = "arcus.client.account.create.name" // N/A
  static let AccountCreatePlan = "arcus.client.account.create.plan" // N/A
  static let AccountCreateAddress = "arcus.client.account.create.address" // N/A
  static let AccountCreateSecurityQuestions = "arcus.client.account.create.securityquestions" // N/A
  static let AccountCreatePin = "arcus.client.account.create.pin" // N/A
  static let AccountCreateBilling = "arcus.client.account.create.billing" // N/A
  static let AccountCreatePromonAcknowledged = "arcus.client.account.create.promon.acknowledged" // N/A
  static let AccountCreatePromonAdditionalInfo = "arcus.client.account.create.promon.additonalinfo" // N/A
  static let AccountCreatePromonPermitRequired = "arcus.client.account.create.promon.permitrequired  " // N/A
  static let AccountCreatePromonTest = "arcus.client.account.create.promon.test" // N/A
  static let AccountCreatePromonTestTimeout = "arcus.client.account.create.promon.test.timeout" // N/A
  static let AccountCreatePromonComplete = "arcus.client.account.create.promon.complete" // N/A
  static let AccountCreateNavIOS = "arcus.client.account.create.nav.ios *"
  static let AccountCreationSignUpComplete = "Sign Up Complete"
  
  // Logging in
  static let Logon = "Logon"
  static let LogonMode = "Mode"
  static let LogonManual = "arcus.client.login.manual"
  static let LogonAuto = "arcus.client.login.auto"
  
  // Device Settings
  static let DevicesFav = "arcus.client.devices.fav"
  static let DevicesScheduleEdit = "arcus.client.devices.schedule.edit"
  static let DevicesScheduleEventAdd = "arcus.client.devices.schedule.event.add"
  static let DevicesSettings = "arcus.client.devices.settings"
  static let DevicesMore = "arcus.client.devices.more"
  static let DevicesMoreRemove = "arcus.client.device.more.remove"
  static let DevicesMoreForceRemove = "arcus.client.device.more.forceremove"

  // Background - Foreground
  static let Background = "arcus.client.background"
  static let Foreground = "arcus.client.foreground"
  
  // Nest, Lutron, Honeywell - Revoked/Removed
  static let NestRemoved = "arcus.client.devices.nest.removed"
  static let NestRevoked = "arcus.client.devices.nest.revoked"
  static let LutronRemoved = "arcus.client.devices.lutron.removed"
  static let LutronRevoked = "arcus.client.devices.lutron.revoked"
  static let HoneywellRemoved = "arcus.client.devices.honeywell.removed"
  
  // Invitation
  static let InvitationAccept = "arcus.client.invitation.accept"
  static let InvitationReject = "arcus.client.invitation.reject"

  // Unexpected Failures
  static let ImageURLCreationFatalError = "arcus.client.image.url.creation.fatalerror"
  static let ErrorUniqueDeviceIdentifier = "arcus.client.error.uniqueDeviceIdentifier"
  
}
