import Foundation
import TuistGenerator

extension Generator {
    /// Initializes a generator instance with all the dependencies that are specific to Tuist.
    convenience init() {
        let manifestLoader = GraphManifestLoader()
        let manifestLinter = ManifestLinter()
        let modelLoader = GeneratorModelLoader(manifestLoader: manifestLoader, manifestLinter: manifestLinter)
        self.init(modelLoader: modelLoader)
    }
}
