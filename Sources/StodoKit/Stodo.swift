//
//  Stodo.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Result

public let stodoKitBundle = Bundle(for: Todo.self)

open class Todo: NSObject, NSCoding {
    public var id: Int = 0
    public var title: String = ""
    public var isDone: Bool = false
    public var createdAt: TimeInterval = 0
    public var updatedAt: TimeInterval = 0

    public init(id: Int, title: String, isDone: Bool = false) {
        super.init()
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = Date().timeIntervalSince1970
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.isDone = aDecoder.decodeBool(forKey: "isdone")
        self.createdAt = aDecoder.decodeDouble(forKey: "createdat")
        self.updatedAt = aDecoder.decodeDouble(forKey: "updatedat")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(isDone, forKey: "isdone")
        aCoder.encode(createdAt, forKey: "createdat")
        aCoder.encode(updatedAt, forKey: "updatedat")
    }
}

extension Todo {
    public static var savedTodos: [Todo] {
        get {
            let todos = KeyedArchiver.unarchive(path: fullPath)
            return todos
        }
        set {
            KeyedArchiver.archive(todos: newValue, path: fullPath)
        }
    }

    public static func contains(target: Int) -> Bool {
        let todos = savedTodos
        let ids = todos.map { $0.id }
        return ids.contains(target)
    }
}

extension Todo: FileType {
    open class var rootURL: URL {
        let homeDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
        return homeDirectoryURL.appendingPathComponent(fileName, isDirectory: true)
    }
}

public protocol ActionType {
    associatedtype Response
    static func add(title: String, isDone: Bool) -> Result<(), StodoError>
    static func delete(at target: Int) -> Result<(), StodoError>
    static func done(at target: Int) -> Result<(), StodoError>
    static func list() -> Result<Response, StodoError>
    static func move(from fromTarget: Int, to toTarget: Int) -> Result<(), StodoError>
    static func rename(at target: Int, name: String) -> Result<(), StodoError>
    static func reset() -> Result<(), StodoError>
    static func undone(at target: Int) -> Result<(), StodoError>
}

extension Todo: ActionType {
    public typealias Response = [Todo]

    public static func add(title: String, isDone: Bool = false) -> Result<(), StodoError> {
        if title.isEmpty {
            return .failure(StodoError.addError(failureReason: "Could not fine the title."))
        }

        if !fileManager.fileExists(atPath: fullPath) {
            let todo = Todo(id: 1, title: title)
            todo.isDone = isDone
            let todos: [Todo] = [todo]
            let data = KeyedArchiver.archive(todos: todos)
            fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)
        } else {
            var todos = savedTodos
            let maxId = todos.map {$0.id}.max() ?? 0
            let todo = Todo(id: maxId + 1, title: title)
            todo.isDone = isDone
            todos.append(todo)
            savedTodos = todos
        }
        return .success()
    }

    public static func list() -> Result<Response, StodoError> {
        if savedTodos.isEmpty {
            return .failure(StodoError.listError(failureReason: "Todo list is empty. Add task by `stodo add`."))
        }
        return .success(savedTodos)
    }

    public static func done(at target: Int) -> Result<(), StodoError> {
        if Todo.contains(target: target) {
            let todos = savedTodos
            todos.filter { $0.id == target }.first?.isDone = true
            todos.filter { $0.id == target }.first?.updatedAt = Date().timeIntervalSince1970
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.doneError(failureReason: "Could not find the task."))
        }
    }

    public static func undone(at target: Int) -> Result<(), StodoError> {
        if Todo.contains(target: target) {
            let todos = savedTodos
            todos.filter { $0.id == target }.first?.isDone = false
            todos.filter { $0.id == target }.first?.updatedAt = Date().timeIntervalSince1970
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.undoneError(failureReason: "Could not find the task."))
        }
    }

    public static func delete(at target: Int) -> Result<(), StodoError> {
        if Todo.contains(target: target) {
            var todos = savedTodos
            let todo = todos.filter { $0.id == target }.first
            if let todo = todo, let index = todos.index(of: todo) {
                todos.remove(at: index)
            } else {
                return .failure(StodoError.deleteError(failureReason: "Could not remove the task."))
            }
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.deleteError(failureReason: "Could not find the task."))
        }
    }

    public static func move(from fromTarget: Int, to toTarget: Int) -> Result<(), StodoError> {
        var todos = savedTodos
        let fromTodo = todos.filter { $0.id == fromTarget }.first
        let toTodo = todos.filter { $0.id == toTarget }.first
        if let fromTodo = fromTodo, let toTodo = toTodo,
                let fromIndex = todos.index(of: fromTodo), let toIndex = todos.index(of: toTodo) {
            swap(&todos[fromIndex], &todos[toIndex])
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.moveError(failureReason: "Could not find the task."))
        }
    }

    public static func rename(at target: Int, name: String) -> Result<(), StodoError> {
        if Todo.contains(target: target) {
            let todos = savedTodos
            todos.filter { $0.id == target }.first?.title = name
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.renameError(failureReason: "Could not find the task."))
        }
    }

    public static func reset() -> Result<(), StodoError> {
        savedTodos = []
        if savedTodos.isEmpty {
            return .success()
        } else {
            return .failure(StodoError.renameError(failureReason: "Could not find the task."))
        }
    }
}
