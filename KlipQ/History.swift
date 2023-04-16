//
//  History.swift
//  KlipQ
//
//  Created by Kenneth Mason on 4/16/23.
//

import Foundation

class History {
    private var items: [String] = []
    private let maxCount = 20
    
    init() {
        // Create an array with 20 empty strings
        self.items = Array(repeating: "", count: 20)
    }
    
    func addItem(_ item: String) {
        items.insert(item, at: 0)
        if items.count > maxCount {
            items.removeLast()
        }
    }
    
    func getItem(at index: Int) -> String? {
        guard index < items.count else {
            return nil
        }
        return items[index]
    }
    
    func getItems() -> [String] {
        return items
    }
    
    func clear() {
        items.removeAll()
    }
    
    var count: Int {
        return items.count
    }
}
