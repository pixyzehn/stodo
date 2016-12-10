//
//  Reset.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/8/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Commandant
import Result
import StodoKit

public struct ResetCommand: CommandProtocol {
    public typealias Options = NoOptions<StodoError>
    public typealias ClientError = StodoError

    public let verb = "reset"
    public let function = "Reset all your task"

    public func run(_ options: Options) -> Result<(), ClientError> {
        switch Todo.reset() {
        case .success(_):
            _ = ListCommand().run(ListOptions())
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}
