//
//  GlobalHotkeyHandler.swift
//  KlipQ
//
//  Created by Kenneth Mason on 3/3/25.
//
import Carbon
import Cocoa
import Foundation

// MARK: - Helper to convert String to FourCharCode
extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        if let data = self.data(using: .utf8), data.count == 4 {
            data.withUnsafeBytes { (rawBufferPointer) in
                result = rawBufferPointer.load(as: FourCharCode.self)
            }
        }
        return result
    }
}

// MARK: - Hotkey Identifiers
struct HotKeyIdentifiers {
    static let previousID: UInt32 = 1
    static let nextID: UInt32 = 2
    static let numberBaseID: UInt32 = 100
}

// MARK: - Global HotKey Handler
class GlobalHotKeyHandler {

    private var hotKeyRefs: [EventHotKeyRef?] = []
    private let hotKeySignature = OSType("klpq".fourCharCodeValue)

    init() {
        setupEventHandler()
        registerHotKeys()
    }

    deinit {
        unregisterHotKeys()
    }

    private func setupEventHandler() {
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, event, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

            switch hotKeyID.id {
            case HotKeyIdentifiers.previousID:
                NotificationCenter.default.post(name: .HotKeyPrevious, object: nil)
            case HotKeyIdentifiers.nextID:
                NotificationCenter.default.post(name: .HotKeyNext, object: nil)
            case HotKeyIdentifiers.numberBaseID...(HotKeyIdentifiers.numberBaseID + 9):
                let numberPressed = Int(hotKeyID.id - HotKeyIdentifiers.numberBaseID)
                NotificationCenter.default.post(name: .HotKeyNumber, object: numberPressed)
            default:
                break
            }

            return noErr
        }, 1, &eventType, nil, nil)
    }

    private func registerHotKeys() {
        // Previous: Command + Shift + [
        registerHotKey(keyCode: 33, modifiers: UInt32(cmdKey | shiftKey), hotKeyID: HotKeyIdentifiers.previousID)

        // Next: Command + Shift + ]
        registerHotKey(keyCode: 30, modifiers: UInt32(cmdKey | shiftKey), hotKeyID: HotKeyIdentifiers.nextID)

        // Numbers 1-9: Command + Shift + [1-9]
        for i in 0..<9 {
            let keyCode = UInt32(18 + i) // 18 is keycode for '1'
            let hotKeyID = HotKeyIdentifiers.numberBaseID + UInt32(i)
            registerHotKey(keyCode: keyCode, modifiers: UInt32(cmdKey | shiftKey), hotKeyID: hotKeyID)
        }
    }

    private func registerHotKey(keyCode: UInt32, modifiers: UInt32, hotKeyID: UInt32) {
        var gMyHotKeyRef: EventHotKeyRef?
        var gMyHotKeyID = EventHotKeyID(signature: hotKeySignature, id: hotKeyID)

        let status = RegisterEventHotKey(UInt32(keyCode), modifiers, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef)

        if status == noErr {
            hotKeyRefs.append(gMyHotKeyRef)
        } else {
            print("Failed to register hotkey with keycode: \(keyCode), status: \(status)")
        }
    }

    private func unregisterHotKeys() {
        for hotKeyRef in hotKeyRefs {
            if let ref = hotKeyRef {
                UnregisterEventHotKey(ref)
            }
        }
        hotKeyRefs.removeAll()
    }
}

// Extending Notification.Name to define custom notifications for hotkeys
extension Notification.Name {
    static let HotKeyNumber = Notification.Name("HotKeyNumber")
    static let HotKeyPrevious = Notification.Name("HotKeyPrevious")
    static let HotKeyNext = Notification.Name("HotKeyNext")
}
