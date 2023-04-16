//
//  PasteboardManager.swift
//  KlipQ
//
//  Created by Kenny Mason on 7/18/22.
//

import Cocoa

class PasteboardPoller
{
    var pasteboard: NSPasteboard!
    
    var timer: Timer!
    let checkInterval: TimeInterval = 0.05
    
    // Keeps track of the last known count of pasteboard changes
    private var changeCount: Int!
    
    // current active/focused/frontmost app
    private var focusedApp: String? = nil
    
    init (pasteboard: NSPasteboard, changeCount: Int = -1)
    {
        self.pasteboard = pasteboard
        self.changeCount = changeCount
        
        // Initiate a polling solution for checking pasteboard changes
        timer = Timer.scheduledTimer(timeInterval: checkInterval, target: self, selector: #selector(checkForChanges), userInfo: nil, repeats: true)
        
        //TODO: listen for notification when new window activates, and set it to frontApp
        //TODO: check for changes. if found, log active app and time with pasteboard items
        
        //TODO: start timer
    }
    
    @objc func checkForChanges ()
    {
        if (self.changeCount != self.pasteboard.changeCount) {
            self.changeCount = self.pasteboard.changeCount
            
            NotificationCenter.default.post(name: .NewPasteboardItem, object: self.pasteboard)
            
            
            //TODO: look into pasteboardItems. is it an array of multiple items iff you copied with multiple cursors? is it a history of copied items?
            
            //TODO: get the last (pasteboard.changeCount - changeCount) items from pasteboard.pasteboardItems
            //TODO: write code to read any data type from the pasteboard
        }
    }
    
    func invalidate ()
    {
        //TODO: any final resource / state saving, clean up, memory freeing, etc.
        timer.invalidate()
    }
    
}
    
//    let intervalInSeconds: TimeInterval = 0.05
//
//        private var timer: Timer!
//        private var lastChangeCount: Int!
//
//        var pasteboard: NSPasteboard!
//        var delegate: PasteboardMonitorDelegate!
//
//        private var frontmostApp: String? = nil
//
//        init(pasteboard: NSPasteboard, changeCount: Int = -1, delegate: PasteboardMonitorDelegate) {
//            self.pasteboard = pasteboard
//            self.delegate = delegate
//            self.lastChangeCount = changeCount
//
//            // Registers if any application becomes active (or comes frontmost) and calls a method if it's the case.
//            // https://stackoverflow.com/a/49402868
//            NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(activeApp(sender:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
//
//            // TODO: Is it best to do a check straight away?
//            self.checkIfPasteboardChanged()
//            self.timer = Timer.scheduledTimer(withTimeInterval: intervalInSeconds, repeats: true) { (t) in
//                self.checkIfPasteboardChanged()
//            }
//        }
//
//        // Called by NSWorkspace when any application becomes active or comes frontmost.
//        @objc private func activeApp(sender: NSNotification) {
//            if let info = sender.userInfo,
//                let content = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
//                let bundle = content.bundleIdentifier
//            {
//                frontmostApp = bundle
//            }
//        }
//
//        private func checkIfPasteboardChanged() {
//            if lastChangeCount != pasteboard.changeCount  {
//                lastChangeCount = self.pasteboard.changeCount
//                delegate.pasteboardDidChange(pasteboard, originBundleId: frontmostApp)
//            }
//        }

