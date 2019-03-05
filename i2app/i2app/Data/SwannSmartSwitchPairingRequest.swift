//
//  SwannSmartSwitchPairingRequest.swift
//  testSwann
//
//  Created by Arcus Team on 7/25/16.
//
//

import Foundation
import Cornea

struct SwannSmartSwitchPairingResponseMessage {
  static let goodMessageResponse = "#/SAMOK#"
  static let badMessageResponse = "#/SAMNG#"
  static let requestMACResponse = "#/SAMM4#"
}

enum SwannSmartSwitchPairingRequestType: Int {
  case setSSID = 0
  case setKey = 1
  case getMAC = 2
  case reset = 3

  func command() -> String {
    switch self {
    case .setSSID:
      return "#/SAMSS#"
    case .setKey:
      return "#/SAMPW#"
    case .getMAC:
      return "#/SAMMR#"
    case .reset:
      return "#/SAMRS#"
    }
  }
}

class SwannSmartSwitchPairingRequest: ArcusSimpleSocketMessageProtocol {
  let type: SwannSmartSwitchPairingRequestType
  var length: Int = 0
  let payload: String?

  required init(type: SwannSmartSwitchPairingRequestType,
                payload: String? = nil) {
    self.type = type
    self.payload = payload
    if let payload = self.payload {
      self.length = payload.count
    }
  }

  func messageData() -> NSData {
    let commandData: NSMutableData =
      NSMutableData(data: self.type.command().data(using: String.Encoding.utf8)!)

    let lengthData: NSData = NSData(bytes: &self.length,
                                    length: MemoryLayout<Int>.size)
    let range: NSRange = NSRange.init(location: 0,
                                      length: 1)
    commandData.append(lengthData.subdata(with: range))

    if self.payload != nil {
      let payloadData: NSData = self.payload!.data(using: String.Encoding.utf8)! as NSData
      if self.type == .setKey {
        commandData.append(self.obfuscateData(data: payloadData, encodingShift: 10) as Data)
      } else {
        commandData.append(payloadData as Data)
      }
    }

    return commandData
  }

  func obfuscateData(data: NSData, encodingShift: Int) -> NSData {
    var resultBytes: [UInt8] = []
    let count = data.length / MemoryLayout<UInt8>.size
    var dataArray = [UInt8](repeating: 0, count: count)
    data.getBytes(&dataArray, length:count * MemoryLayout<UInt8>.size)

    for byte: UInt8 in dataArray {
      let newByte: UInt8 = byte + 0x0A
      resultBytes.append(newByte)
    }

    return NSData(bytes: resultBytes, length: resultBytes.count)
  }

  func messageReceived(_ data: NSData) -> String {
    switch self.type {
    case .setSSID:
      return self.processCommandResponse(data)
    case .setKey:
      return self.processCommandResponse(data)
    case .getMAC:
      return self.processMACResponse(data)
    case .reset:
      return self.processCommandResponse(data)
    }
  }

  // MARK: Response Handling
  func processCommandResponse(_ data: NSData) -> String {
    var result: String = SwannSmartSwitchPairingResponseMessage.badMessageResponse

    let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
    if message != nil {
      if message!.contains(SwannSmartSwitchPairingResponseMessage.goodMessageResponse) {
        result = SwannSmartSwitchPairingResponseMessage.goodMessageResponse
      } else if message!.contains(SwannSmartSwitchPairingResponseMessage.badMessageResponse) {
        result = SwannSmartSwitchPairingResponseMessage.badMessageResponse
      }
    }

    print("Command: \(self.type) Result: \(result)")

    return result
  }

  func processMACResponse(_ data: NSData) -> String {
    var result: String = SwannSmartSwitchPairingResponseMessage.badMessageResponse

    let asciiMessage = NSString(data: data as Data, encoding: String.Encoding.ascii.rawValue)
    if asciiMessage?.contains(SwannSmartSwitchPairingResponseMessage.requestMACResponse) == true {
      let hexMessage: String? = (data as Data).hexString
      let hexString: NSString? = hexMessage as NSString?
      let macRange: NSRange = NSRange(location: 18,
                                      length: 12)
      let macAddress: String? = hexString?.substring(with: macRange)

      if macAddress != nil {
        result = macAddress!
      }
    }

    print("MAC Result: \(result)")

    return result
  }
}
