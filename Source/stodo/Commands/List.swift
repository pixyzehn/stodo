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

public struct ListOptions: OptionsProtocol {
    public typealias ClientError = StodoError
    var isMarkdown: Bool = false
    var isShowedTime: Bool = false
    var isDone: Bool = false
    var isUndone: Bool = false

    static func show(_ isMarkdown: Bool) -> (Bool) -> (Bool) -> (Bool) -> ListOptions {
        return { isShowedTime in { isDone in { isUndone in
            return self.init(isMarkdown: isMarkdown, isShowedTime: isShowedTime, isDone: isDone, isUndone: isUndone)
        }}}
    }

    public static func evaluate(_ m: CommandMode) -> Result<ListOptions, CommandantError<ClientError>> {
        return show
            <*> m <| Switch(flag: "m", key: "markdown", usage: "Show list by markdown")
            <*> m <| Switch(flag: "t", key: "time", usage: "Show todo list with createdAt or updatedAt")
            <*> m <| Switch(flag: "d", key: "done", usage: "Show only done tasks")
            <*> m <| Switch(flag: "u", key: "undone", usage: "Show only undone tasks.")
    }
}

public struct ListCommand: CommandProtocol {
    public typealias Options = ListOptions
    public typealias ClientError = StodoError

    public let verb = "list"
    public let function = "Show a list of your tasks"

    public func run(_ options: Options) -> Result<(), ClientError> {
        let todos = Todo.list()
        switch todos {
        case .success(let todos):
            let maxTitleLength = todos.map { $0.title.characters.count }.max() ?? 0

            for todo in todos {
                var output: String
                if options.isDone && !todo.isDone || options.isUndone && todo.isDone {
                    continue
                }

                let mark = todo.isDone ? "x" : " "
                output = options.isMarkdown ?
                    "- [\(mark)] \(todo.title)" : "[\(mark)] \(NSString(format: "%03d", todo.id)): \(todo.title)"

                if options.isShowedTime {
                    let space = maxTitleLength - todo.title.characters.count + 1
                    let spaceString = String(repeating: " ", count: space)
                    output += todo.updatedAt == 0 ?
                        "\(spaceString) | \(todo.createdAt.toDate())" : "\(spaceString) | \(todo.updatedAt.toDate())"
                }
                print("\(output)")
            }
            return .success()
        case .failure(let error):
            return .failure(error)
        }
    }
}

fileprivate extension TimeInterval {
    func toDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
