//
//  FileType.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

public protocol FileType {
    static var fileName: String { get }
    static var rootURL: URL { get }
    static var fullPath: String { get }
}

public extension FileType {
    static var fileManager: FileManager {
        return FileManager.default
    }
    
    static var fileName: String {
        return ".stodo"
    }
    
    static var rootURL: URL {
        let homeDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
        return homeDirectoryURL.appendingPathComponent(fileName, isDirectory: true)
    }
    
    static var fullPath: String {
        return rootURL.path
    }
}
