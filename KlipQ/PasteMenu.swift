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
//        // add mode toggle
//        self.addItem(NSMenuItem(
//            title: "Stack",
//            action: #selector(appD.toggleStack),
//            keyEquivalent: "p"
//        ))
//
//        self.addItem(NSMenuItem.separator())

        // create menu items - allows for 9 entries
        for i in 1...9 {
            let menuItem = NSMenuItem(title: "", action: #selector(appD.trigger(_:)), keyEquivalent: "\(i)")
            menuItem.tag = i
            
            // A space is required for the title because row height is determined by content, so an empty string would give the row no height. We use an NSAttributedString to set the height via styling. Without either of these, empty menu items would be misaligned
            let attributedTitle = NSMutableAttributedString(string: "\u{200B}")
            attributedTitle.addAttribute(.font, value: NSFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedTitle.length))
            menuItem.attributedTitle = attributedTitle

            self.addItem(menuItem)
        }
        
        self.addItem(NSMenuItem.separator())
        
        // add hidden menu items to use as hotkeys for history items
//        for i in 1...9 {
//            let menuItem = NSMenuItem(title: "\(i)", action: #selector(appD.hotTrigger(_:)), keyEquivalent: "")
////            menuItem.isHidden = true
//            self.addItem(menuItem);
//        }
        
        self.addItem(NSMenuItem(
            title: "Previous Item",
            action: #selector(appD.previousItem),
            keyEquivalent: "p"
        ))
        
        self.addItem(NSMenuItem(
            title: "Next Item",
            action: #selector(appD.nextItem),
            keyEquivalent: "n"
        ))
        
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
            // update menu item with copied text. need to wrap our string in NSAttributedString because we needed to use attributed strings for titles to give them a fixed size when empty
            self.items[i].attributedTitle = NSAttributedString(string: trimString(history.getItem(at: i)!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: " ")));
            self.items[i].isEnabled = true;
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
