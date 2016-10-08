//
//  Errors.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

public enum StodoError: Error {
    case addError(failureReason: String)
    case deleteError(failureReason: String)
    case doneError(failureReason: String)
    case listError(failureReason: String)
    case moveError(failureReason: String)
    case renameError(failureReason: String)
    case resetError(failureReason: String)
    case undoneError(failureReason: String)
    case versionError(failureReason: String)
}

public extension StodoError {
    public var description: String {
        switch self {
        case .addError(let failureReason):
            return "\(failureReason)"
        case .deleteError(let failureReason):
            return "\(failureReason)"
        case .doneError(let failureReason):
            return "\(failureReason)"
        case .listError(let failureReason):
            return "\(failureReason)"
        case .moveError(let failureReason):
            return "\(failureReason)"
        case .renameError(let failureReason):
            return "\(failureReason)"
        case .resetError(let failureReason):
            return "\(failureReason)"
        case .undoneError(let failureReason):
            return "\(failureReason)"
        case .versionError(let failureReason):
            return "\(failureReason)"
        }
    }
}
