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
    }
    
    // shutdown processes
    func applicationWillTerminate(_ notification: Notification)
    {
        // TODO - tear down app, invalidate timers (!!!)
        poller.invalidate()
    }

    // new pasteboard (copied) item
    @objc func onNewItem (_ notification: Notification)
    {
        guard let items = (notification.object as? NSPasteboard)?.pasteboardItems else {
            return
        }
        
        createKlipItem(item: items[0])
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

    // handling menu item actions
    @objc func trigger(_ sender: NSMenuItem) {
        // Handle menu item action here
        let index = sender.tag
        
        cursor = index;
        setIcon(number: index);
        
        // copy item to pasteboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(history.getItem(at: index - 1) ?? "", forType: .string)
    }
    
    // set menubar icon
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

}

