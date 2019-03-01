//
//  Change+Map.swift
//  DeepDiff
//
//  Created by Javier Osorio Goenaga on 2/26/19.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public extension Change {
    public func map<U>(_ transform: (T) throws -> U) rethrows -> Change<U> {
        switch self {
        case .delete(let value):
            return try .delete(Delete(item: transform(value.item), index: value.index))
            
        case .insert(let value):
            return try .insert(Insert(item: transform(value.item), index: value.index))
            
        case .move(let move):
            let mappedMove = try Move(item: transform(move.item), fromIndex: move.fromIndex, toIndex: move.toIndex)
            return .move(mappedMove)
            
        case .replace(let replace):
            let mappedReplace = try Replace(oldItem: transform(replace.oldItem), newItem: transform(replace.newItem), index: replace.index)
            return .replace(mappedReplace)
        }
    }
}
