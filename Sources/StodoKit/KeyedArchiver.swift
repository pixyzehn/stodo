//
//  KeyedArchiver.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation

public struct KeyedArchiver {
    public static func archive(todos: [Todo]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: todos)
    }

    public static func archive(todos: [Todo], path: String) {
        NSKeyedArchiver.archiveRootObject(todos, toFile: path)
    }

    public static func unarchive(path: String) -> [Todo] {
        if let todos = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Todo] {
            return todos
        }
        return []
    }
}
