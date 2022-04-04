//
//  Array+Extensions.swift
//  Flix
//
//  Created by Anton Romanov on 18.11.2021.
//

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    subscript (safe closedRange: ClosedRange<Int>) -> [Element]? {
        let arrayIncludesRange = indices.contains(closedRange.lowerBound) && indices.contains(closedRange.upperBound)
        return arrayIncludesRange ? Array(self[closedRange]) : nil
    }
    
    subscript (safe partialRangeFrom: PartialRangeFrom<Int>) -> [Element]? {
        let arrayIncludesRange = indices.contains(partialRangeFrom.lowerBound)
        return arrayIncludesRange ? Array(self[partialRangeFrom]) : nil
    }
}
