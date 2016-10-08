//
//  ActionTypeTests.swift
//  ActionTypeTests
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Quick
import Nimble
@testable import StodoKit

class ActionTypeTests: QuickSpec {
    override func spec() {
        var target: Int!
        beforeEach {
            target = 1
            TodoTests.addNewFileForTests()
            TodoTests.addFixturesForTests()
        }

        afterEach {
            TodoTests.deleteFileForTests()
        }

        describe("the ActionType") {
            it("add a new task") {
                let sum = TodoTests.savedTodos.count
                switch TodoTests.add(title: "test4") {
                case .success():
                    expect(TodoTests.savedTodos.count).to(equal(sum + 1))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("delete a task") {
                switch TodoTests.delete(at: target) {
                case .success():
                    expect(TodoTests.get(id: target)).to(beNil())
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("done a task") {
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

            it("show a list of tasks") {
                switch TodoTests.list() {
                case .success(let results):
                    expect(results.count).to(equal(TodoTests.savedTodos.count))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("move tasks") {
                let fromTarget = 1
                let toTarget = 2
                expect(TodoTests.savedTodos[0].id).to(equal(fromTarget))
                expect(TodoTests.savedTodos[1].id).to(equal(toTarget))
                switch TodoTests.move(from: fromTarget, to: toTarget) {
                case .success(_):
                    expect(TodoTests.savedTodos[0].id).to(equal(toTarget))
                    expect(TodoTests.savedTodos[1].id).to(equal(fromTarget))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("reneme task") {
                expect(TodoTests.savedTodos[0].title).to(equal("todo_test_1"))
                switch TodoTests.rename(at: target, name: "updated_todo_test_1") {
                case .success(_):
                    expect(TodoTests.savedTodos[0].title).to(equal("updated_todo_test_1"))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("reset all tasks") {
                expect(TodoTests.savedTodos.count).to(equal(3))
                switch TodoTests.reset() {
                case .success(_):
                    expect(TodoTests.savedTodos.count).to(equal(0))
                case .failure(let error):
                    print("\(error)")
                }
            }

            it("undone a task") {
                switch TodoTests.done(at: target) {
                case .success(_):
                    if let todo = TodoTests.get(id: target) {
                        expect(todo.isDone).to(beTrue())
                    } else {
                        fatalError("Could not done the task.")
                    }

                    switch TodoTests.undone(at: target) {
                    case .success():
                        if let todo = TodoTests.get(id: target) {
                            expect(todo.isDone).to(beFalse())
                        } else {
                            fatalError("Could not undone the task.")
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}
