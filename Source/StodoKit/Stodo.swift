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

public class Todo: NSObject, NSCoding, FileType {
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
        self.id = aDecoder.decodeInteger(forKey: "ID")
        self.title = aDecoder.decodeObject(forKey: "TITLE") as! String
        self.isDone = aDecoder.decodeBool(forKey: "ISDONE")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "ID")
        aCoder.encode(title, forKey: "TITLE")
        aCoder.encode(isDone, forKey: "ISDONE")
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
            fileManager.createFile(atPath: fullPath, contents: nil, attributes: nil)
        }

        var todos = savedTodos
        let maxId = todos.map {$0.id}.max() ?? 0
        let todo = Todo(id: maxId + 1, title: title)
        todos.append(todo)
        savedTodos = todos
        return .success()
    }

    public static func done(at target: Int) -> Result<(), StodoError> {
        let todos = savedTodos
        let todo = todos.filter { $0.id == target }.first
        if let todo = todo {
            todo.isDone = true
        } else {
            return .failure(StodoError.doneError(failureReason: "Could not find the task."))
        }
        savedTodos = todos
        return .success()
    }

    public static func undone(at target: Int) -> Result<(), StodoError> {
        let todos = savedTodos
        let todo = todos.filter { $0.id == target }.first
        if let todo = todo {
            todo.isDone = false
        } else {
            return .failure(StodoError.undoneError(failureReason: "Could not find the task."))
        }
        savedTodos = todos
        return .success()
    }

    public static func delete(at target: Int) -> Result<(), StodoError> {
        var todos = savedTodos
        let todo = todos.filter { $0.id == target }.first
        if let todo = todo, let index = todos.index(of: todo) {
            todos.remove(at: index)
        } else {
            return .failure(StodoError.deleteError(failureReason: "Could not find the task."))
        }
        savedTodos = todos
        return .success()
    }
}
