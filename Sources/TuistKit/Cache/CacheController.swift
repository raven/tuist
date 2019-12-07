import Basic
import Foundation
import RxBlocking
import RxSwift
import TuistCore
import TuistGenerator
import TuistSupport

protocol CacheControlling {
    /// Caches the cacheable targets that are part of the workspace or project at the given path.
    /// - Parameter path: Path to the directory that contains a workspace or a project.
    func cache(path: AbsolutePath) throws
}

final class CacheController: CacheControlling {
    /// Xcode project generator.
    private let generator: Generating

    /// Manifest loader.
    private let manifestLoader: GraphManifestLoading

    /// Utility to build the xcframeworks.
    private let xcframeworkBuilder: XCFrameworkBuilding

    /// Cache.
    private let cache: CacheStoraging

    init(generator: Generating = Generator(),
         manifestLoader: GraphManifestLoading = GraphManifestLoader(),
         xcframeworkBuilder: XCFrameworkBuilding = XCFrameworkBuilder(),
         cache: CacheStoraging = Cache()) {
        self.generator = generator
        self.manifestLoader = manifestLoader
        self.xcframeworkBuilder = xcframeworkBuilder
        self.cache = cache
    }

    func cache(path: AbsolutePath) throws {
        // Generate the project.
        let (path, graph) = try generator.generate(at: path, manifestLoader: manifestLoader, projectOnly: false)

        // Getting the hash

        let targets: [TargetNode: String] = [:]
        var completables: [Completable] = []

        try targets.forEach { target, hash in
            // Build targets sequentially
            let xcframeworkPath: AbsolutePath!
            if path.extension == "xcworkspace" {
                xcframeworkPath = try self.xcframeworkBuilder.build(workspacePath: path, target: target.target)
            } else {
                xcframeworkPath = try self.xcframeworkBuilder.build(projectPath: path, target: target.target)
            }

            // Create tasks to cache and delete the xcframeworks asynchronously
            let deleteXCFrameworkCompletable = Completable.create(subscribe: { completed in
                try? FileHandler.shared.delete(xcframeworkPath)
                completed(.completed)
                return Disposables.create()
            })
            completables.append(cache.store(hash: hash, xcframeworkPath: xcframeworkPath).concat(deleteXCFrameworkCompletable))
        }

        _ = try Completable.zip(completables).toBlocking().last()

        Printer.shared.print(success: "All cacheable frameworks have been cached successfully")
    }
}
