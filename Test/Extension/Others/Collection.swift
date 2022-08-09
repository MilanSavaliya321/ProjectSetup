//
//  Collection.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation

extension Collection {
    /// Get at index object
    func get(at index: Index?) -> Iterator.Element? {
        guard let index = index else { return nil }
        return self.indices.contains(index) ? self[index] : nil
    }
}
