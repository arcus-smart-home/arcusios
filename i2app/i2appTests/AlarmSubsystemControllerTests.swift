//
//  AlarmSubsystemControllerTests.swift
//  i2app
//
//  Created by Paul Wood on 2/8/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import XCTest
@testable import i2app

class AlarmSubsystemControllerTests: XCTestCase {

  var safetyController: SafetySubsystemAlertController!
  var subsystemModel: SubsystemModel!

  override func setUp() {
    super.setUp()
    let fixt = FixtureJSONToDictionary.fixture(withName: "EmptySecuritySubsystem")
    safetyController = SafetySubsystemAlertController(attributes: fixt)
  }

  override func tearDown() {
    super.tearDown()
  }
//  
//  class SetHobbitsTestStub : AlarmSubsystemController {
//    var safetyController : SafetySubsystemAlertController!
//    var subsystemModel: SubsystemModel!
//    init(safetyController : SafetySubsystemAlertController) {
//      
//    }
//  }
//  
//  func testCanSetHobbits() {
//    let setHobbitsTestStub = SetHobbitsTestStub(safetyController: self.safetyController)
//    
//  }
}
