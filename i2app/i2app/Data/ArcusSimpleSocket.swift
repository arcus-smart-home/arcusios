//
//  ArcusSimpleSocket.swift
//  testSwann
//
//  Created by Arcus Team on 7/25/16.
//
//

import Foundation
import Cornea

//http://stackoverflow.com/a/40089462/283460
extension Data {
  var hexString: String? {
    return map { String(format: "%02hhx", $0) }.joined()
  }
}

protocol ArcusSimpleSocketDelegate: class {
    func socketDidConnect(_ socket: ArcusSimpleSocket)
    func socketConnectionFailed(_ socket: ArcusSimpleSocket, reason: NSError)
    func socketReadyForMessage(_ socket: ArcusSimpleSocket)
    func socketReceivedMessage(_ socket: ArcusSimpleSocket,
                               request: ArcusSimpleSocketMessageProtocol,
                               data: NSData)
    func socketReceivedError(_ socket: ArcusSimpleSocket,
                             request: ArcusSimpleSocketMessageProtocol,
                             error: NSError)
    func socketDidClose(_ socket: ArcusSimpleSocket)
}

protocol ArcusSimpleSocketMessageProtocol {
    func messageData() -> NSData
    func messageReceived(_ data: NSData) -> String
}

class ArcusSimpleSocket: NSObject, StreamDelegate {
    var readStream: CFReadStream?
    var writeStream: CFWriteStream?

    var inputStream: InputStream?
    var outputStream: OutputStream?

    weak var delegate: ArcusSimpleSocketDelegate?

    var activeMessage: ArcusSimpleSocketMessageProtocol?

    // MARK: Initialization
    required init(delegate: ArcusSimpleSocketDelegate) {
        self.delegate = delegate

        super.init()
    }

    // MARK: Connection Handling
    func connect(_ address: String, port: Int) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(nil,
                                           address as CFString!,
                                           UInt32(port),
                                           &readStream,
                                           &writeStream)

        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()

        self.open()
    }

    func open() {
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self

        self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

        self.inputStream?.open()
        self.outputStream?.open()
    }

    func close() {
        self.inputStream?.close()
        self.outputStream?.close()

        self.inputStream?.remove(from: .current,
                                            forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream?.remove(from: .current,
                                             forMode: RunLoopMode.defaultRunLoopMode)
        self.inputStream?.delegate = nil
        self.outputStream?.delegate = nil

        self.inputStream = nil
        self.outputStream = nil

        self.delegate?.socketDidClose(self)
    }

    // MARK: NSStreamDelegate
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            self.errorReceived(aStream)
            break
        case Stream.Event.endEncountered:
            self.close()
            break
        case Stream.Event.hasBytesAvailable:
            self.bytesReceived(aStream)
            break
        case Stream.Event.openCompleted:
            self.delegate?.socketDidConnect(self)
            break
        case Stream.Event.hasSpaceAvailable:
            self.delegate?.socketReadyForMessage(self)
            break
        default:
            break
        }
    }

    // MARK: Data I/O - Sending
    func sendMessage(_ message: ArcusSimpleSocketMessageProtocol) {
      self.activeMessage = message
      let messageData: NSData = message.messageData()
      self.outputStream?.write(messageData.bytes.bindMemory(to: UInt8.self, capacity: messageData.length),
                               maxLength: messageData.length)
    }

    // MARK: Data I/O - Receiving
    func bytesReceived(_ aStream: Stream) {
        var buffer = [UInt8](repeating: 0, count: 4096)
        if self.inputStream == aStream {
            if self.inputStream != nil {
                var hasBytes: Bool = self.inputStream!.hasBytesAvailable
                while hasBytes == true {
                    let length = self.inputStream!.read(&buffer, maxLength: buffer.count)
                    if length > 0 {
                        let receivedData: NSData = NSData(bytes: UnsafePointer<UInt8>(buffer), length: length)
                        self.delegate?.socketReceivedMessage(self,
                                                       request: self.activeMessage!,
                                                       data: receivedData)

                    }

                    if self.inputStream != nil {
                        hasBytes = self.inputStream!.hasBytesAvailable
                    } else {
                        hasBytes = false
                    }
                }
            }
        }
    }

    func errorReceived(_ stream: Stream) {
        if self.activeMessage != nil {
            self.delegate?.socketReceivedError(self,
                                               request: self.activeMessage!,
                                               error: stream.streamError! as NSError)
        }
    }
}
