//
//  FileType.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation

public protocol FileType {
    static var rootURL: URL { get }
    static var fileManager: FileManager { get }
    static var fileName: String { get }
    static var fullPath: String { get }
}

public extension FileType {
    public static var fileManager: FileManager {
        return .default
    }

    public static var fileName: String {
        return ".stodo"
    }

    public static var fullPath: String {
        return rootURL.path
    }
}
