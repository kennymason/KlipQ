//
//  History.swift
//  KlipQ
//
//  Created by Kenneth Mason on 4/16/23.
//

import Foundation

class History {
    var items: [String] = []
    private let maxCount = 20
    
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
}
