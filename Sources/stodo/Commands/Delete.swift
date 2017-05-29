//
//  Delete.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct DeleteOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let target: Int

    static func delete(_ target: Int) -> DeleteOptions {
        return self.init(target: target)
    }

    public static func evaluate(_ m: CommandMode) -> Result<DeleteOptions, CommandantError<ClientError>> {
        return delete
            <*> m <| Argument(usage: "Task id to delete")
    }
}

public struct DeleteCommand: CommandProtocol {
    public typealias Options = DeleteOptions
    public typealias ClientError = StodoError

    public let verb = "delete"
    public let function = "Delete a task if it exists"

    public func run(_ options: Options) -> Result<(), ClientError> {
        switch Todo.delete(at: options.target) {
        case .success:
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
