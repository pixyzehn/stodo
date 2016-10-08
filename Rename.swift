//
//  Rename.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/8/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct RenameOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let target: Int
    let name: String
    
    static func rename(_ target: Int) -> (String) -> RenameOptions {
        return { name in
            return self.init(target: target, name: name)
        }
    }
    
    public static func evaluate(_ m: CommandMode) -> Result<RenameOptions, CommandantError<ClientError>> {
        return rename
            <*> m <| Argument(usage: "Task id to move from")
            <*> m <| Argument(usage: "Task id to move to")
    }
}

public struct RenameCommand: CommandProtocol {
    public typealias Options = RenameOptions
    public typealias ClientError = StodoError
    
    public let verb = "rename"
    public let function = "Rename your task"
    
    public func run(_ options: RenameOptions) -> Result<(), ClientError> {
        switch Todo.rename(at: options.target, name: options.name) {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
