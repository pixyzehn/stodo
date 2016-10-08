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

    static func add(_ title: String) -> AddOptions {
        return self.init(title: title)
    }

    public static func evaluate(_ m: CommandMode) -> Result<AddOptions, CommandantError<ClientError>> {
        return add
            <*> m <| Argument(usage: "Task title")
    }
}

public struct AddCommand: CommandProtocol {
    public typealias Options = AddOptions
    public typealias ClientError = StodoError

    public let verb = "add"
    public let function = "Add a new task if it exists"

    public func run(_ options: Options) -> Result<(), ClientError> {
        let title = options.title
        switch Todo.add(title: title) {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
