//
//  AlarmSubsystemTest.swift
//  i2app
//
//  Created by Paul Wood on 2/6/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import XCTest
@testable import i2app

class AlarmSubsystemTest: XCTestCase {

  class MockPresenter: AlarmSubsystemController, AlarmModelController {
    var subsystemModel: SubsystemModel = SubsystemModel()

  }

  var mockPresenter = MockPresenter()

  override func setUp() {
    super.setUp()
    mockPresenter = MockPresenter()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

}
