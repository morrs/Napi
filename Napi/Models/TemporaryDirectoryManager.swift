//
//  Created by Mateusz Karwat on 12/12/2016.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Provides an easy and clean way to access and manage temporary directory.
final class TemporaryDirectoryManager {
    private let fileManager = FileManager.default

    let temporaryDirectory: URL

    /// Creates a new instance of `TemporaryDirectoryManager`.
    ///
    /// - Parameter folderName: Name of directory to be created.
    init(directoryName: String) {
        temporaryDirectory = fileManager.temporaryDirectory.appendingPathComponent(directoryName, isDirectory: true)
    }

    /// Creates a new instance of `TemporaryDirectoryManager` with default directory name.
    class var `default`: TemporaryDirectoryManager {
        return TemporaryDirectoryManager(directoryName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String)
    }

    /// Checks if temporary directory is empty.
    var temporaryDirectoryIsEmpty: Bool {
        return contentsOfTemporaryDirectory.isEmpty
    }

    /// Checks if temporary directory exists.
    var temporaryDirectoryExists: Bool {
        return fileManager.fileExists(atPath: temporaryDirectory.path)
    }

    /// Tries to create temporary directory.
    func createTemporaryDirectory() {
        try? fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: false, attributes: nil)
    }

    /// Returns paths to all files and directories inside temporary directory.
    var contentsOfTemporaryDirectory: [URL] {
        do {
            return try fileManager.contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil, options: [])
        } catch {
            return []
        }
    }

    /// Removes temporary directory with all its content.
    func removeTemporaryDirectory() {
        try? fileManager.removeItem(at: temporaryDirectory)
    }

    /// Removes all files and directories inside temporary directory.
    func cleanupTemporaryDirectory() {
        contentsOfTemporaryDirectory.forEach {
            try? fileManager.removeItem(at: $0)
        }
    }
}
