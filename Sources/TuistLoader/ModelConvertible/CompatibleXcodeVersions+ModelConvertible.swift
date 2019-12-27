import Basic
import Foundation
import ProjectDescription
import TuistCore

extension TuistCore.CompatibleXcodeVersions: ModelConvertible {
    init(manifest: ProjectDescription.CompatibleXcodeVersions, generatorPaths _: GeneratorPaths) throws {
        switch manifest {
        case .all:
            self = .all
        case let .list(versions):
            self = .list(versions)
        }
    }
}