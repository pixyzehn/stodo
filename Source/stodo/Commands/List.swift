//
//  ListCommand.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct ListCommand: CommandProtocol {
    public typealias Options = NoOptions<StodoError>
    public typealias ClientError = StodoError

    public let verb = "list"
    public let function = "Show a list of your tasks"

    public func run(_ options: Options) -> Result<(), ClientError> {
        let todos = Todo.list()
        switch todos {
        case .success(let todos):
            for todo in todos {
                let mark = todo.isDone ? "x" : " "
                print("[\(mark)] \(NSString(format: "%03d", todo.id)): \(todo.title)")
            }
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
