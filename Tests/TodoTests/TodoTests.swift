//
//  TodoTests.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/8/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import StodoKit

public class TodoTests: Todo {}

extension TodoTests {
    public override class var rootURL: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName), isDirectory: true)
    }
}

extension TodoTests {
    static func get(id: Int) -> Todo? {
        return savedTodos.filter { $0.id == id }.first
    }

    static func addNewFileForTests() {
        if !fileManager.fileExists(atPath: fullPath) {
            fileManager.createFile(atPath: fullPath, contents: nil, attributes: nil)
        }
    }

    static func deleteFileForTests() {
        if fileManager.fileExists(atPath: fullPath) {
            do {
                try fileManager.removeItem(atPath: fullPath)
            } catch(let error) {
                print("\(error)")
            }
        }
    }

    static func addFixturesForTests() {
        let todo1 = TodoTests(id: 1, title: "todo_test_1")
        let todo2 = TodoTests(id: 2, title: "todo_test_2")
        let todo3 = TodoTests(id: 3, title: "todo_test_3")
        savedTodos = [todo1, todo2, todo3]
    }
}
