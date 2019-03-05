//
//  SwannSmartSwitchPairingClient.swift
//  i2app
//
//  Created by Arcus Team on 7/20/16.
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

protocol SwannSmartSwitchPairingDelegate: class {
  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     connectionEstablished connected: Bool)
  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     receivedMACAddress macAddress: String)
  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     completedPairing success: Bool,
                     error: NSError?)
}

class SwannSmartSwitchPairingClient: ArcusSimpleSocketDelegate {
  var socket: ArcusSimpleSocket!
  weak var delegate: SwannSmartSwitchPairingDelegate?

  var ssidRequest: SwannSmartSwitchPairingRequest?
  var keyRequest: SwannSmartSwitchPairingRequest?
  var macRequest: SwannSmartSwitchPairingRequest?
  var resetRequest: SwannSmartSwitchPairingRequest?

  var activeMessage: SwannSmartSwitchPairingRequest?

  var intialConnection: Bool = true

  var timeoutTimer: Timer?

  // MARK: Initialization
  init(delegate: SwannSmartSwitchPairingDelegate) {
    self.delegate = delegate
    self.socket = ArcusSimpleSocket(delegate: self)
    self.socket.connect("192.168.1.1", port: 2501)
  }

  func startPairing(_ ssid: String,
                    key: String) {
    self.ssidRequest = SwannSmartSwitchPairingRequest(type: .setSSID,
                                                      payload: ssid)

    self.keyRequest = SwannSmartSwitchPairingRequest(type: .setKey,
                                                     payload: key)

    self.macRequest = SwannSmartSwitchPairingRequest(type: .getMAC,
                                                     payload: nil)

    self.resetRequest = SwannSmartSwitchPairingRequest(type: .reset,
                                                       payload: nil)

    self.sendNextMessage()
  }

  // MARK: Convenience Methods
  func requestMAC() {
    self.activeMessage = self.macRequest
    self.socket.sendMessage(self.macRequest!)
  }

  func configureSSID() {
    self.activeMessage = self.ssidRequest
    self.socket.sendMessage(self.ssidRequest!)
  }

  func configureKey() {
    self.activeMessage = self.keyRequest
    self.socket.sendMessage(self.keyRequest!)
  }

  func sendReset() {
    self.activeMessage = self.resetRequest
    self.socket.sendMessage(self.resetRequest!)

    // Device will sometimes reset before response is sent, therefore must
    // manually check for timeout
    self.timeoutTimer = Timer
      .scheduledTimer(timeInterval: 5.0,
                      target: self,
                      selector: #selector(resetTimedOut(_:)),
                      userInfo: nil,
                      repeats: false)

  }

  func sendNextMessage() {
    if self.activeMessage == nil {
      self.requestMAC()
    } else if self.activeMessage === self.macRequest {
      self.configureSSID()
    } else if self.activeMessage === self.ssidRequest {
      self.configureKey()
    } else if self.activeMessage === self.keyRequest {
      self.sendReset()
    } else if self.activeMessage === self.resetRequest {
      if self.timeoutTimer?.isValid == true {
        self.timeoutTimer?.invalidate()
        self.delegate?.pairingClient(self,
                                     completedPairing: true,
                                     error: nil)
        self.socket.close()
      } else {
        // Assume that the timer has already wrapped up notifying delegate
        // and has closed the socket.  This should prevent notifying the
        // delegate twice.
      }
    }
  }

  func retryActiveMessage() {
    if self.activeMessage != nil {
      self.socket.sendMessage(self.activeMessage!)
    }
  }

  func errorReceived(_ command: String, error: NSError) {
    self.delegate?.pairingClient(self,
                                 completedPairing: false,
                                 error: error)
  }

  @objc func resetTimedOut(_ sender: AnyObject) {
    self.delegate?.pairingClient(self,
                                 completedPairing: true,
                                 error: nil)

    self.socket.close()
  }

  // MARK: ArcusSimpleSocketDelegate
  func socketDidConnect(_ socket: ArcusSimpleSocket) {

  }

  func socketConnectionFailed(_ socket: ArcusSimpleSocket, reason: NSError) {
    self.delegate?.pairingClient(self,
                                 completedPairing: false,
                                 error: reason)
  }

  func socketReadyForMessage(_ socket: ArcusSimpleSocket) {
    if self.intialConnection == true {
      self.delegate?.pairingClient(self, connectionEstablished: true)
      self.intialConnection = false
    }
  }

  func socketReceivedMessage(_ socket: ArcusSimpleSocket,
                             request: ArcusSimpleSocketMessageProtocol,
                             data: NSData) {
    if let swannRequest: SwannSmartSwitchPairingRequest = request as? SwannSmartSwitchPairingRequest {
      if swannRequest === self.macRequest {
        let macAddress: String? = swannRequest.messageReceived(data)
        if macAddress != nil {
          self.delegate?.pairingClient(self, receivedMACAddress: macAddress!)
          self.sendNextMessage()
        } else {

        }
      } else {
        if swannRequest.messageReceived(data) ==
          SwannSmartSwitchPairingResponseMessage.goodMessageResponse {
          self.sendNextMessage()
        } else {

        }
      }
    }
  }

  func socketReceivedError(_ socket: ArcusSimpleSocket,
                           request: ArcusSimpleSocketMessageProtocol,
                           error: NSError) {
    self.delegate?.pairingClient(self,
                                 completedPairing: false,
                                 error: error)
  }

  func socketDidClose(_ socket: ArcusSimpleSocket) {

  }
}
