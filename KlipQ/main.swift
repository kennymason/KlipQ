//
//  main.swift
//  KlipQ
//
//  Created by Kenneth Mason on 7/12/22.
//

import Foundation
import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
