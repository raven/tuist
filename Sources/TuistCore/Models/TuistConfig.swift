import Basic
import Foundation
import TuistSupport

/// This model allows to configure Tuist.
public struct TuistConfig: Equatable, Hashable {
    /// Contains options related to the project generation.
    ///
    /// - xcodeProjectName: Name used for the Xcode project
    public enum GenerationOptions: Hashable, Equatable {
        case xcodeProjectName(String)
    }

    /// Generation options.
    public let generationOptions: [GenerationOptions]

    /// List of Xcode versions the project or set of projects is compatible with.
    public let compatibleXcodeVersions: CompatibleXcodeVersions

    /// Returns the default Tuist configuration.
    public static var `default`: TuistConfig {
        TuistConfig(compatibleXcodeVersions: .all,
                    generationOptions: [])
    }

    /// Initializes the tuist cofiguration.
    ///
    /// - Parameters:
    ///   - compatibleXcodeVersions: List of Xcode versions the project or set of projects is compatible with.
    ///   - generationOptions: Generation options.
    public init(compatibleXcodeVersions: CompatibleXcodeVersions,
                generationOptions: [GenerationOptions]) {
        self.compatibleXcodeVersions = compatibleXcodeVersions
        self.generationOptions = generationOptions
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(generationOptions)
    }

    // MARK: - Equatable

    public static func == (lhs: TuistConfig, rhs: TuistConfig) -> Bool {
        lhs.generationOptions == rhs.generationOptions
    }
}

public func == (lhs: TuistConfig.GenerationOptions, rhs: TuistConfig.GenerationOptions) -> Bool {
    switch (lhs, rhs) {
    case let (.xcodeProjectName(lhs), .xcodeProjectName(rhs)):
        return lhs == rhs
    default: return false
    }
}
