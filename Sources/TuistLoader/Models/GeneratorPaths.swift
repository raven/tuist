import Basic
import Foundation
import ProjectDescription
import TuistSupport

enum GeneratorPathsError: FatalError, Equatable {
    /// Thrown when the root directory can't be located.
    case rootDirectoryNotFound(AbsolutePath)

    var type: ErrorType {
        switch self {
        case .rootDirectoryNotFound: return .abort
        }
    }

    var description: String {
        switch self {
        case let .rootDirectoryNotFound(path):
            return "Couldn't locate the root directory from path \(path.pathString). The root directory is the closest directory that contains a Tuist or a .git directory."
        }
    }
}

/// This model includes paths the manifest path can be relative to.
struct GeneratorPaths {
    /// Path to the directory that contains the manifest being loaded.
    let manifestDirectory: AbsolutePath

    /// Creates an instance with its attributes.
    /// - Parameter manifestDirectory: Path to the directory that contains the manifest being loaded.
    init(manifestDirectory: AbsolutePath) {
        self.manifestDirectory = manifestDirectory
    }

    /// Given a project description path, it returns the absolute path of the given path.
    /// - Parameter path: Absolute path.
    func resolve(path: Path) throws -> AbsolutePath {
        switch path.type {
        case .relativeToCurrentFile:
            let callerAbsolutePath = AbsolutePath(path.callerPath!).removingLastComponent()
            return AbsolutePath(path.pathString, relativeTo: callerAbsolutePath)
        case .relativeToManifest:
            return AbsolutePath(path.pathString, relativeTo: manifestDirectory)
        case .relativeToRoot:
            guard let rootPath = RootDirectoryLocator.shared.locate(from: AbsolutePath(manifestDirectory.pathString)) else {
                throw GeneratorPathsError.rootDirectoryNotFound(AbsolutePath(manifestDirectory.pathString))
            }
            return AbsolutePath(path.pathString, relativeTo: rootPath)
        }
    }
}
