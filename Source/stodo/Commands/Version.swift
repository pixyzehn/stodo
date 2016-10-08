//
//  Version.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import Result
import StodoKit

public struct VersionCommand: CommandProtocol {
    public typealias Options = NoOptions<StodoError>
    public typealias ClientError = StodoError

    public let verb = "version"
    public let function = "Display the current version"

    public func run(_ options: Options) -> Result<(), ClientError> {
        if let version = stodoKitBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            print("\(version)")
            return .success(())
        } else {
            return .failure(StodoError.versionError(failureReason: "Could not find the version."))
        }
    }
}
