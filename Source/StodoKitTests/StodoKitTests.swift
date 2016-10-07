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
        beforeEach {
            Todo.addNewFileForTests()
            Todo.addFixturesForTests()
        }

        describe("the ActionType") {
            it("show a list of tasks") {
                switch Todo.list() {
                case .success(let results):
                    expect(results.count).to(equal(Todo.savedTodos.count))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("add a new task") {
                let sum = Todo.savedTodos.count
                switch Todo.add(title: "test4") {
                case .success():
                    expect(Todo.savedTodos.count).to(equal(sum + 1))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("done a task") {
                let target = 1
                guard let todo = Todo.get(id: target) else { fatalError("Could not find the task.") }
                expect(todo.isDone).to(beFalse())

                switch Todo.done(at: todo.id) {
                case .success():
                    if let todo = Todo.get(id: target) {
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
                _ = Todo.done(at: target)
                if let todo = Todo.get(id: target) {
                    expect(todo.isDone).to(beTrue())
                } else {
                    fatalError("Could not find the task.")
                }

                switch Todo.undone(at: target) {
                case .success():
                    if let todo = Todo.get(id: target) {
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
                guard let todo = Todo.get(id: target) else { fatalError("Could not find the task.") }
                expect(todo).toNot(beNil())

                switch Todo.delete(at: target) {
                case .success():
                    expect(Todo.get(id: target)).to(beNil())
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}

// MARK: Helper

extension FileType {
    fileprivate static var rootURL: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName), isDirectory: true)
    }
}

extension Todo {
    fileprivate static func get(id: Int) -> Todo? {
        return savedTodos.filter { $0.id == id }.first
    }

    fileprivate static func addNewFileForTests() {
        if !fileManager.fileExists(atPath: fullPath) {
            fileManager.createFile(atPath: fullPath, contents: nil, attributes: nil)
        }
    }

    fileprivate static func addFixturesForTests() {
        let todo1 = Todo(id: 1, title: "todo1")
        let todo2 = Todo(id: 2, title: "todo2")
        let todo3 = Todo(id: 3, title: "todo3")
        savedTodos = [todo1, todo2, todo3]
    }
}
