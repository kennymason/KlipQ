//
//  PasteMenu.swift
//  KlipQ
//
//  Created by Kenny Mason on 7/18/22.
//

import Foundation
import AppKit

class PasteMenu : NSMenu {
    
    override init(title: String) {
        super.init(title: title)
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private var cursor : Int = 0
    
    func buildFromHistory() {
        
    }
    
    
    
    
    
//    func setupMenus() {
//        let menu = NSMenu()
//
//        menu.addItem(NSMenuItem(
//            title: "Stack",
//            action: #selector(toggleStack),
//            keyEquivalent: "p"
//        ))
//
//        menu.addItem(NSMenuItem.separator())
//
//        let one = NSMenuItem(
//            title: "One",
//            action: #selector(triggerOne),
//            keyEquivalent: "1"
//        )
//        menu.addItem(one)
//
//        let two = NSMenuItem(
//            title: "Two",
//            action: #selector(triggerTwo),
//            keyEquivalent: "2"
//        )
//        menu.addItem(two)
//
//        let three = NSMenuItem(
//            title: "Three",
//            action: #selector(triggerThree),
//            keyEquivalent: "3"
//        )
//        menu.addItem(three)
//
//        let four = NSMenuItem(
//            title: "Four",
//            action: #selector(triggerFour),
//            keyEquivalent: "4"
//        )
//        menu.addItem(four)
//
//        let five = NSMenuItem(
//            title: "Five",
//            action: #selector(triggerFive),
//            keyEquivalent: "5"
//        )
//        menu.addItem(five)
//
//        menu.addItem(NSMenuItem.separator())
//
//        menu.addItem(NSMenuItem(
//            title: "Quit",
//            action: #selector(NSApplication.terminate(_:)),
//            keyEquivalent: "q"
//        ))
//
//        statusItem.menu = menu
//    }
}
