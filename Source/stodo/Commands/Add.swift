//
//  Add.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct AddOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let title: String
    let isDone: Bool

    static func add(_ title: String) -> (Bool) -> AddOptions {
        return { isDone in
            self.init(title: title, isDone: isDone)
        }
    }

    public static func evaluate(_ m: CommandMode) -> Result<AddOptions, CommandantError<ClientError>> {
        return add
            <*> m <| Argument(usage: "Task title to add")
            <*> m <| Switch(flag: "d", key: "done", usage: "Add new task with a status of done")
    }
}

public struct AddCommand: CommandProtocol {
    public typealias Options = AddOptions
    public typealias ClientError = StodoError

    public let verb = "add"
    public let function = "Add a new task if it exists"

    public func run(_ options: Options) -> Result<(), ClientError> {
        let title = options.title
        switch Todo.add(title: title, isDone: options.isDone) {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
