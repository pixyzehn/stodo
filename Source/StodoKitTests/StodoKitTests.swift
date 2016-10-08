//
//  StodoKitTests.swift
//  StodoKitTests
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Quick
import Nimble
@testable import StodoKit

class StodoKitTests: QuickSpec {
    override func spec() {
        beforeSuite {
            TodoTests.addNewFileForTests()
            TodoTests.addFixturesForTests()
        }

        afterSuite {
            TodoTests.deleteFileForTests()
        }

        describe("the ActionType") {
            it("show a list of tasks") {
                switch TodoTests.list() {
                case .success(let results):
                    expect(results.count).to(equal(TodoTests.savedTodos.count))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("add a new task") {
                let sum = TodoTests.savedTodos.count
                switch TodoTests.add(title: "test4") {
                case .success():
                    expect(TodoTests.savedTodos.count).to(equal(sum + 1))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("done a task") {
                let target = 1
                guard let todo = TodoTests.get(id: target) else { fatalError("Could not find the task.") }
                expect(todo.isDone).to(beFalse())

                switch TodoTests.done(at: todo.id) {
                case .success():
                    if let todo = TodoTests.get(id: target) {
                        expect(todo.isDone).to(beTrue())
                    } else {
                        fatalError("Could not find the task.")
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("undone a task") {
                let target = 1
                _ = TodoTests.done(at: target)
                if let todo = TodoTests.get(id: target) {
                    expect(todo.isDone).to(beTrue())
                } else {
                    fatalError("Could not find the task.")
                }

                switch TodoTests.undone(at: target) {
                case .success():
                    if let todo = TodoTests.get(id: target) {
                        expect(todo.isDone).to(beFalse())
                    } else {
                        fatalError("Could not find the task.")
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("delete a task") {
                let target = 1
                guard let todo = TodoTests.get(id: target) else { fatalError("Could not find the task.") }
                expect(todo).toNot(beNil())

                switch TodoTests.delete(at: target) {
                case .success():
                    expect(TodoTests.get(id: target)).to(beNil())
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}

// MARK: Helper

public class TodoTests: Todo {}

extension TodoTests {
    public override class var rootURL: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName), isDirectory: true)
    }
}

extension TodoTests {
    fileprivate static func get(id: Int) -> Todo? {
        return savedTodos.filter { $0.id == id }.first
    }

    fileprivate static func addNewFileForTests() {
        if !fileManager.fileExists(atPath: fullPath) {
            fileManager.createFile(atPath: fullPath, contents: nil, attributes: nil)
        }
    }

    fileprivate static func deleteFileForTests() {
        if fileManager.fileExists(atPath: fullPath) {
            do {
                try fileManager.removeItem(atPath: fullPath)
            } catch(let error) {
                print("\(error)")
            }
        }
    }

    fileprivate static func addFixturesForTests() {
        let todo1 = Todo(id: 1, title: "todo_test_1")
        let todo2 = Todo(id: 2, title: "todo_test_2")
        let todo3 = Todo(id: 3, title: "todo_test_3")
        savedTodos = [todo1, todo2, todo3]
    }
}
