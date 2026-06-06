import Foundation

// See OmnipodKit/Eros/ErosMessageTransport.swift and OmnipodKit/Bluetooth/BleMessageTransport.swift
// for specific implementations of MessageTransportState and MessageTransport

protocol MessageTransportState: Equatable, RawRepresentable {
    var messageNumber: Int { get }

    init()

    init?(rawValue: RawValue)

    // Each MessageTransportState implementation also has an init() taking transport specific arguments
}

protocol MessageTransportDelegate: AnyObject {
    func messageTransport(_ messageTransport: MessageTransport, didUpdate state: any MessageTransportState)
}

protocol MessageTransport {
    var delegate: MessageTransportDelegate? { get set }

    var messageNumber: Int { get }

    func sendMessage(_ message: Message) throws -> Message

    // Asserts that the caller is currently on the session's queue
    func assertOnSessionQueue()
}
