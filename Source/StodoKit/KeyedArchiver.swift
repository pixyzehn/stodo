//
//  KeyedArchiver.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation

public struct KeyedArchiver {
    static func archive(todos: [Todo]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: todos)
    }

    static func archive(todos: [Todo], path: String) {
        let success = NSKeyedArchiver.archiveRootObject(todos, toFile: path)
        if !success {
            fatalError("Could not archive.")
        }
    }

    static func unarchive(path: String) -> [Todo] {
        if let todos = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Todo] {
            return todos
        } else {
            fatalError("Could not unarchive.")
        }
    }
}
