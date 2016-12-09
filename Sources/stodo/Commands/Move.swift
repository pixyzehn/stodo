//
//  Move.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/8/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct MoveOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let fromId: Int
    let toId: Int

    static func move(_ fromId: Int) -> (Int) -> MoveOptions {
        return { toId in
            return self.init(fromId: fromId, toId: toId)
        }
    }

    public static func evaluate(_ m: CommandMode) -> Result<MoveOptions, CommandantError<ClientError>> {
        return move
            <*> m <| Argument(usage: "Task id to move from")
            <*> m <| Argument(usage: "Task id to move to")
    }
}

public struct MoveCommand: CommandProtocol {
    public typealias Options = MoveOptions
    public typealias ClientError = StodoError

    public let verb = "move"
    public let function = "Move your tasks"

    public func run(_ options: MoveOptions) -> Result<(), ClientError> {
        switch Todo.move(from: options.fromId, to: options.toId) {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
