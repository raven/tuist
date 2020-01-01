import Foundation

public struct RunAction: Equatable, Codable {
    public let configurationName: String
    public let executable: TargetReference?
    public let arguments: Arguments?

    public init(configurationName: String,
                executable: TargetReference? = nil,
                arguments: Arguments? = nil) {
        self.configurationName = configurationName
        self.executable = executable
        self.arguments = arguments
    }

    public init(config: PresetBuildConfiguration = .debug,
                executable: TargetReference? = nil,
                arguments: Arguments? = nil) {
        self.init(configurationName: config.name,
                  executable: executable,
                  arguments: arguments)
    }
}
