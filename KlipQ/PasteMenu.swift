//
//  PasteMenu.swift
//  KlipQ
//
//  Created by Kenny Mason on 7/18/22.
//

import Foundation
import AppKit

class PasteMenu : NSMenu {
    var appD: AppDelegate!
    
    override init(title: String) {
        super.init(title: title)
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        appD = appDelegate;
        
        // initialize items
        initMenu();
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private var cursor : Int = 0
    
    func buildFromHistory() {
        
    }
    
    func initMenu ()
    {
        // add mode toggle
        self.addItem(NSMenuItem(
            title: "Stack",
            action: #selector(appD.toggleStack),
            keyEquivalent: "p"
        ))
        
        self.addItem(NSMenuItem.separator())
        
        // create menu items - allows for 9 entries
        for i in 1...9 {
            let menuItem = NSMenuItem(title: "", action: #selector(appD.trigger(_:)), keyEquivalent: "\(i)")
            menuItem.tag = i;
            self.addItem(menuItem);
        }
        
        self.addItem(NSMenuItem.separator())
        
        self.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
    }
    
    
    // menu changes
    func update (_ history: History) {
        for i in 0..<min(history.count, 9) {
            self.items[i + 2].title = trimString(history.getItem(at: i)!);
            self.items[i + 2].isEnabled = true;
        }
    }
    
    // helper funcs
    func trimString(_ string: String) -> String {
        // trims string down to 20 characters
        let maxLength = 20
        if string.count > maxLength {
            let index = string.index(string.startIndex, offsetBy: maxLength)
            return String(string[..<index])
        } else {
            return string
        }
    }
}
