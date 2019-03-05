//
//  RxCBCentralManagerDelegateProxy.swift
//  i2app
//
//  Created by Arcus Team on 6/25/18.
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

import CoreBluetooth
import RxSwift
import RxCocoa

public class RxCBCentralManagerDelegateProxy: DelegateProxy, CBCentralManagerDelegate, DelegateProxyType {
  public weak fileprivate(set) var central: CBCentralManager?

  internal var stateBehaviorSubject: BehaviorSubject<CBManagerState>!

  // MARK: - Initialization

  public required init(parentObject: AnyObject) {
    self.central = parentObject as? CBCentralManager
    self.stateBehaviorSubject = BehaviorSubject<CBManagerState>(value: central?.state ?? .unknown)
    super.init(parentObject: parentObject)
  }

  deinit {
    stateBehaviorSubject.onCompleted()
  }

  // MARK: - Delegate Methods

  public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    self.stateBehaviorSubject?.onNext(central.state)
    self._forwardToDelegate?.centralManagerDidUpdateState(central)
  }

  // MARK: - Delegate Proxy

  public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
    guard let central: CBCentralManager = object as? CBCentralManager else { fatalError() }
    return central.rxDelegateProxy()
  }

  public static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    guard let central: CBCentralManager = object as? CBCentralManager else { fatalError() }
    central.delegate = delegate as? CBCentralManagerDelegate
  }

  public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    guard let central: CBCentralManager = object as? CBCentralManager else { fatalError() }
    return central.delegate
  }
}
