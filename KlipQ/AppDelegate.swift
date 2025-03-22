//
//  AppDelegate.swift
//  KlipQ
//
//  Created by Kenny Mason on 7/12/22.
//

import Cocoa
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate
{
    
    // pasting modes - basic, stack, queue
    enum Mode
    {
        case base
        case stack
    }
    
    // menubar icon based on current paste cursor
    enum Icon
    {
        case basic(String, String)
        case number(Int)
        case none
    }
    
    var mode : Mode = .base
    private var cursor : Int = 1
    
    private var statusItem: NSStatusItem!
    private var menubarIcon: NSImage!
    private var iconConfig: NSImage.SymbolConfiguration!
    
    private var poller: PasteboardPoller!
    
    private var menu: PasteMenu!
    private var history: History!
    
//    var hotKeyHandler: HotKeyHandler?
    var nextKey: HotKey!
    var prevKey: HotKey!
    var oneKey: HotKey!
    var twoKey: HotKey!
    var threeKey: HotKey!
    var fourKey: HotKey!
    var fiveKey: HotKey!
    var sixKey: HotKey!
    var sevenKey: HotKey!
    var eightKey: HotKey!
    var nineKey: HotKey!

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // adds listener for new pasteboard items
        NotificationCenter.default.addObserver(self, selector: #selector(onNewItem), name: .NewPasteboardItem, object: nil)
        // initialize pasteboard poller - polls the pasteboard for changes
        poller = PasteboardPoller(pasteboard: NSPasteboard .general, changeCount: -1)
    
        // sets menubar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // sets icon for statusItem
        //TODO: clean up initial icon configuration
        // macOS 13+ only - "list.bullet.clipboard" beta SF Symbol
        setIcon(number: 1);
        
        // creates menu
        menu = PasteMenu();
        statusItem.menu = menu;
        
        // initialize history array
        history = History();
        
        // initialize hot key listening
        initializeGlobalHotkeys();
    }
    
    // shutdown processes
    func applicationWillTerminate(_ notification: Notification)
    {
//        hotKeyHandler = nil
        poller.invalidate()
    }

    // new pasteboard (copied) item
    @objc func onNewItem (_ notification: Notification)
    {
        guard let items = (notification.object as? NSPasteboard)?.pasteboardItems else {
            return
        }
        
        if !items.isEmpty {
            createKlipItem(item: items[0])
        } else {
            print("No items found in the pasteboard.")
        }
//        if (items.count == 1) {
//            createKlipItem(item: items[0])
//        }
//        if (items.count > 1) {
//            createMultiKlipItem(items: items)
//        }
    }
    
    // add new item to history
    func createKlipItem(item: NSPasteboardItem)
    {
        if let copiedText = item.string(forType: .string) {
            if copiedText != history.getItem(at: cursor - 1) {
                history.addItem(copiedText);
                menu.update(history);
                
                cursor = 1;
                setIcon(number: cursor);
            }
        }
    }

    // add new multi-item
//    func createMultiKlipItem(items: [NSPasteboardItem])
//    {
//        for item in items {
//
//        }
//    }
    
    func copyToPasteboard() {
        setIcon(number: cursor);
        
        // copy item to pasteboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(history.getItem(at: cursor - 1) ?? "", forType: .string)
    }

    // handling menu item actions
    @objc func trigger(_ sender: NSMenuItem) {
        let index = sender.tag
        cursor = index;
        
        copyToPasteboard();
    }
    
    // when triggered by hotkey (hidden menu item)
//    @objc func hotTrigger(_ sender: NSMenuItem) {
//        let index = Int(sender.title)
//        cursor = index ?? 1;
//
//        copyToPasteboard();
//    }
    
    // handling next item action
    @objc func previousItem(_ sender: NSMenuItem) {
        if cursor > 1 {
            cursor = cursor - 1;
            
            copyToPasteboard();
        }
    }
    
    // handling next item action
    @objc func nextItem(_ sender: NSMenuItem) {
        cursor = cursor + 1;
        
        copyToPasteboard();
    }
    
    @objc func setCursor (num: Int)
    {
        cursor = num
    }
    
    // set menubar icon
    func setIcon (number: Int) {
        if number == 1 {
            menubarIcon = NSImage(
                systemSymbolName: "paperclip",
                accessibilityDescription: "clipboard"
            )
            iconConfig = NSImage.SymbolConfiguration(scale: .large) //pointSize: 15, weight: .regular,
            if let button = statusItem.button {
                button.image = menubarIcon.withSymbolConfiguration(iconConfig)
            }
        }
        else {
            if let button = statusItem.button {
                button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
            }
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
    
    func initializeGlobalHotkeys () {
        nextKey = HotKey(key: .n, modifiers: [.control, .option])
        prevKey = HotKey(key: .p, modifiers: [.control, .option])
        oneKey = HotKey(key: .one, modifiers: [.control, .option])
        twoKey = HotKey(key: .two, modifiers: [.control, .option])
        threeKey = HotKey(key: .three, modifiers: [.control, .option])
        fourKey = HotKey(key: .four, modifiers: [.control, .option])
        fiveKey = HotKey(key: .five, modifiers: [.control, .option])
        sixKey = HotKey(key: .six, modifiers: [.control, .option])
        sevenKey = HotKey(key: .seven, modifiers: [.control, .option])
        eightKey = HotKey(key: .eight, modifiers: [.control, .option])
        nineKey = HotKey(key: .nine, modifiers: [.control, .option])
        
        nextKey.keyDownHandler = { [weak self] in
            self!.cursor = self!.cursor + 1;

            self!.copyToPasteboard();
        }
        prevKey.keyDownHandler = { [weak self] in
            if self!.cursor > 1 {
                self!.cursor = self!.cursor - 1;

                self!.copyToPasteboard();
            }
        }
        oneKey.keyDownHandler = { [weak self] in
            self!.cursor = 1;

            self!.copyToPasteboard();
        }
        twoKey.keyDownHandler = { [weak self] in
            self!.cursor = 2;

            self!.copyToPasteboard();
        }
        threeKey.keyDownHandler = { [weak self] in
            self!.cursor = 3;

            self!.copyToPasteboard();
        }
        fourKey.keyDownHandler = { [weak self] in
            self!.cursor = 4;

            self!.copyToPasteboard();
        }
        fiveKey.keyDownHandler = { [weak self] in
            self!.cursor = 5;

            self!.copyToPasteboard();
        }
        sixKey.keyDownHandler = { [weak self] in
            self!.cursor = 6;

            self!.copyToPasteboard();
        }
        sevenKey.keyDownHandler = { [weak self] in
            self!.cursor = 7;

            self!.copyToPasteboard();
        }
        eightKey.keyDownHandler = { [weak self] in
            self!.cursor = 8;

            self!.copyToPasteboard();
        }
        nineKey.keyDownHandler = { [weak self] in
            self!.cursor = 9;

            self!.copyToPasteboard();
        }
        
    }
}



