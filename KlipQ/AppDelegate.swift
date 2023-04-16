//
//  AppDelegate.swift
//  KlipQ
//
//  Created by Kenny Mason on 7/12/22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
    
//    enum Cursor {
//        case
//    }
    
    enum Mode
    {
        case base
        case stack
    }
    
    enum Icon
    {
        case basic(String, String)
        case number(Int)
        case none
    }
    
    var mode : Mode = .base
    private var cursor : Int = 0
    
    private var statusItem: NSStatusItem!
    private var menubarIcon: NSImage!
    private var iconConfig: NSImage.SymbolConfiguration!
    
    private var poller: PasteboardPoller!

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewItem), name: .NewPasteboardItem, object: nil)
        
        poller = PasteboardPoller(pasteboard: NSPasteboard .general, changeCount: -1)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        //TODO: clean up initial icon configuration
        // macOS 13+ only - "list.bullet.clipboard" beta SF Symbol
        menubarIcon = NSImage(
            systemSymbolName: "paperclip",
            accessibilityDescription: "clipboard"
        )
        iconConfig = NSImage.SymbolConfiguration(scale: .large) //pointSize: 15, weight: .regular,
        if let button = statusItem.button {
            button.image = menubarIcon.withSymbolConfiguration(iconConfig)
        }
//            let config = NSImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
//            config = config.applying(.init(paletteColors: [.controlTextColor, .controlAccentColor]))
//            var color : NSColor! = .
        
        setupMenus()
    }
    
    func applicationWillTerminate(_ notification: Notification)
    {
        // TODO - tear down app, invalidate timers (!!!)
        poller.invalidate()
    }
    
    @objc func onNewItem (_ notification: Notification)
    {
        guard let items = (notification.object as? NSPasteboard)?.pasteboardItems else {
            return
        }
        
        if (items.count == 1) {
            createKlipItem(item: items[0])
        }
        if (items.count > 1) {
            createMultiKlipItem(items: items)
        }
    }
    
    func createKlipItem(item: NSPasteboardItem)
    {

    }

    func createMultiKlipItem(items: [NSPasteboardItem])
    {
        for item in items {

        }
    }
    
    func paste()
    {
        
    }
    
    func setIcon(icon: Icon, config: NSImage.SymbolConfiguration?)
    {
        if let button = statusItem.button
        {
            switch icon {
            case let .basic(name, desc):
                    button.image = NSImage(
                        systemSymbolName: name,
                        accessibilityDescription: desc
                    )
            case let .number(num):
                    button.image = NSImage(
                        systemSymbolName: "\(num).circle",
                        accessibilityDescription: num.description
                    )
            default:
                if let button = statusItem.button {
                    button.image = menubarIcon?.withSymbolConfiguration(iconConfig)
                }
            }
            
            if (config != nil) {
                button.image?.withSymbolConfiguration(config!)
            }
        }
    }
    
    func pop ()
    {
        // Pop (paste) from current cursor. Popped items are not removed. Cursor++
        paste()
        setCursor(num: cursor + 1)
    }
    
    func push ()
    {
        // Cursor doesn't change. All existing copy history / stack items get pushed down
            // IF the current cursor is not at 0, items above the cursor do not get moved
            // EXAMPLE: itemLst = [0:"a", 1:"b", 2:"c"]; cursor = 1; push("d"); itemLst == [0:"a", 1:"d", 2:"b", 3:"c"]
    }
    
    func clear ()
    {
        
    }
    
    @objc func setCursor (num: Int)
    {
        cursor = num
        
        switch mode {
        case Mode.stack:
            setIcon(icon: Icon.number(cursor), config: nil)
        default:
            setIcon(icon: Icon.none, config: nil)
        }
    }
    
    @objc func toggleStack ()
    {
        switch mode {
        case Mode.base:
            mode = Mode.stack
            setCursor(num: cursor)
        case Mode.stack:
            mode = Mode.base
            setCursor(num: 0)
        }
    }
    
    @objc func triggerZero() {
        changeStatusBarButton(number: 0)
    }
    
    @objc func triggerOne() {
        changeStatusBarButton(number: 1)
    }
    
    @objc func triggerTwo() {
        changeStatusBarButton(number: 2)
    }
    
    @objc func triggerThree() {
        changeStatusBarButton(number: 3)
    }
    
    @objc func triggerFour() {
        changeStatusBarButton(number: 4)
    }
    
    @objc func triggerFive() {
        changeStatusBarButton(number: 5)
    }
    
    @objc func triggerSix() {
        changeStatusBarButton(number: 6)
    }
    
    @objc func triggerSeven() {
        changeStatusBarButton(number: 7)
    }
    
    @objc func triggerEight() {
        changeStatusBarButton(number: 8)
    }
    
    @objc func triggerNine() {
        changeStatusBarButton(number: 9)
    }
    
    private func changeStatusBarButton (number: Int)
    {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }
    
    func setupMenus ()
    {
        let menu = PasteMenu()
        
        menu.addItem(NSMenuItem(
            title: "Stack",
            action: #selector(toggleStack),
            keyEquivalent: "p"
        ))
        
        menu.addItem(NSMenuItem.separator())
        
        let one = NSMenuItem(
            title: "One",
            action: #selector(triggerOne),
            keyEquivalent: "1"
        )
        menu.addItem(one)
        
        let two = NSMenuItem(
            title: "Two",
            action: #selector(triggerTwo),
            keyEquivalent: "2"
        )
        menu.addItem(two)
        
        let three = NSMenuItem(
            title: "Three",
            action: #selector(triggerThree),
            keyEquivalent: "3"
        )
        menu.addItem(three)
        
        let four = NSMenuItem(
            title: "Four",
            action: #selector(triggerFour),
            keyEquivalent: "4"
        )
        menu.addItem(four)
        
        let five = NSMenuItem(
            title: "Five",
            action: #selector(triggerFive),
            keyEquivalent: "5"
        )
        menu.addItem(five)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        
        statusItem.menu = menu
    }
    

}

