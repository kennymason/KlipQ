//
//  GlobalShortcutHandler.swift
//  KlipQ

//  Created by Kenneth Mason on 4/22/23.
//

import Cocoa

class HotKeyHandler: NSObject {
    
    private var eventMonitor: Any?
    private let keyCombo = (keyCode: UInt16(18), modifiers: NSEvent.ModifierFlags.option)
    
    var appD: AppDelegate!
    
    override init() {
        super.init()
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handleGlobalKeyDownEvent)
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        appD = appDelegate;
    }
    
    func handleGlobalKeyDownEvent(event: NSEvent) {
        // Check if the hotkey combination was pressed
        if (event.keyCode == keyCombo.keyCode) && (event.modifierFlags == keyCombo.modifiers) {
            // Run some code here
            appD.setCursor(num: 1)
            appD.copyToPasteboard()
        }
    }
    
    deinit {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
    }
}
