//
//  Undone.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Commandant
import Result
import StodoKit

public struct UndoneOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let target: Int

    static func undone(_ target: Int) -> UndoneOptions {
        return self.init(target: target)
    }

    public static func evaluate(_ m: CommandMode) -> Result<UndoneOptions, CommandantError<ClientError>> {
        return undone
            <*> m <| Argument(usage: "Task id to check undone")
    }
}

public struct UndoneCommand: CommandProtocol {
    public typealias Options = UndoneOptions
    public typealias ClientError = StodoError

    public let verb = "undone"
    public let function = "Remove done mark in a task"

    public func run(_ options: Options) -> Result<(), ClientError> {
        switch Todo.undone(at: options.target) {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
