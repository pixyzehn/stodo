//
//  KeyedArchiverTests.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/8/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Quick
import Nimble
import StodoKit

class KeyedArchiverTests: QuickSpec {
    override func spec() {
        describe("KeyedArchiver") {
            var todos: [Todo] = []

            beforeEach {
                let todo1 = TodoTests(id: 1, title: "todo_test_1")
                let todo2 = TodoTests(id: 2, title: "todo_test_2")
                let todo3 = TodoTests(id: 3, title: "todo_test_3")
                todos = [todo1, todo2, todo3]
            }

            afterEach {
                TodoTests.deleteFileForTests()
            }

            it("archive returns Data") {
                let data = KeyedArchiver.archive(todos: todos)
                expect(data.isEmpty).to(beFalse())
            }

            it("archive data in a file and then unarchive data from a file") {
                TodoTests.addNewFileForTests()
                KeyedArchiver.archive(todos: todos, path: TodoTests.fullPath)
                let todosFromFile = KeyedArchiver.unarchive(path: TodoTests.fullPath)
                expect(todos.count == todosFromFile.count).to(beTrue())
            }
        }
    }
}
