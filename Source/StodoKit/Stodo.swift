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

public class Todo: NSObject, NSCoding {
    public var id: Int = 0
    public var title: String = ""
    public var isDone: Bool = false

    init(id: Int, title: String, isDone: Bool = false) {
        super.init()
        self.id = id
        self.title = title
        self.isDone = isDone
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.isDone = aDecoder.decodeBool(forKey: "isdone")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(isDone, forKey: "isdone")
    }

    static var savedTodos: [Todo] {
        get {
            let todos = KeyedArchiver.unarchive(path: fullPath)
            return todos ?? []
        }
        set {
            KeyedArchiver.archive(todos: newValue, path: fullPath)
        }
    }
}

extension Todo: FileType {
    open class var rootURL: URL {
        let homeDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
        return homeDirectoryURL.appendingPathComponent(fileName, isDirectory: true)
    }
}

public protocol ActionType {
    static func list() -> Result<[Todo], StodoError>
    static func add(title: String) -> Result<(), StodoError>
    static func done(at target: Int) -> Result<(), StodoError>
    static func undone(at target: Int) -> Result<(), StodoError>
    static func delete(at target: Int) -> Result<(), StodoError>
}

extension Todo: ActionType {
    public static func list() -> Result<[Todo], StodoError> {
        if savedTodos.isEmpty {
            return .failure(StodoError.listError(failureReason: "Todo is empty."))
        }
        return .success(savedTodos)
    }

    public static func add(title: String) -> Result<(), StodoError> {
        if title.isEmpty {
            return .failure(StodoError.addError(failureReason: "Could not fine the title."))
        }

        if !fileManager.fileExists(atPath: fullPath) {
            let todo = Todo(id: 1, title: title)
            let todos: [Todo] = [todo]
            let data = KeyedArchiver.archive(todos: todos)
            fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)
            return .success()
        } else {
            var todos = savedTodos
            let maxId = todos.map {$0.id}.max() ?? 0
            let todo = Todo(id: maxId + 1, title: title)
            todos.append(todo)
            savedTodos = todos
            return .success()
        }
    }

    public static func done(at target: Int) -> Result<(), StodoError> {
        let todos = savedTodos
        let ids = todos.map { $0.id }
        if ids.contains(target) {
            todos.filter { $0.id == target }.first?.isDone = true
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.doneError(failureReason: "Could not find the task."))
        }
    }

    public static func undone(at target: Int) -> Result<(), StodoError> {
        let todos = savedTodos
        let ids = todos.map { $0.id }
        if ids.contains(target) {
            todos.filter { $0.id == target }.first?.isDone = false
            savedTodos = todos
            return .success()
        } else {
            return .failure(StodoError.undoneError(failureReason: "Could not find the task."))
        }
    }

    public static func delete(at target: Int) -> Result<(), StodoError> {
        var todos = savedTodos
        let ids = todos.map { $0.id }
        if ids.contains(target) {
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
}
