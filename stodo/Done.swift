//
//  Done.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct DoneOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    let target: Int
    
    static func done(_ target: Int) -> DoneOptions {
        return self.init(target: target)
    }
    
    public static func evaluate(_ m: CommandMode) -> Result<DoneOptions, CommandantError<ClientError>> {
        return done
            <*> m <| Argument(usage: "Task id to check done")
    }
}

public struct DoneCommand: CommandProtocol {
    public typealias Options = DoneOptions
    public typealias ClientError = StodoError
    
    public let verb = "done"
    public let function = "Check done mark"
    
    public func run(_ options: Options) -> Result<(), ClientError> {
        switch Todo.done(at: options.target) {
        case .success(_):
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
