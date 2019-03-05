//
//  AlarmConfiguration.h
//  i2app
//
//  Created by Arcus Team on 8/25/15.
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
typedef enum {
    AlarmTypeSafety     = 0,
    AlarmTypeSecurity,
    AlarmTypeCare,
} AlarmType;

typedef enum {
    AlarmDeviceTypeSafety     = 0,
    AlarmDeviceTypeSecurityOnMode   = 1,
    AlarmDeviceTypeSecurityPartialMode = 2,
    AlarmDeviceTypeSecurityDevicesMore = 3
} AlarmDevicePageType;

#define AlarmTypeToString(enum) [@[@"Safety", @"Security",  @"Care"] objectAtIndex:enum]
#define AlarmControllerNameToEnum(str) (AlarmType)[@[@"SafetyAlarmViewController", @"SecurityAlarmViewController", @"CareAlarmViewController"] indexOfObject:str]
