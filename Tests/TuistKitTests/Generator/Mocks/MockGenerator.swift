import Basic
import Foundation
import TuistCore
import TuistGenerator

class MockGenerator: Generating {
    var generateProjectAtStub: ((AbsolutePath) throws -> (AbsolutePath, Graphing))?
    func generateProject(at path: AbsolutePath) throws -> (AbsolutePath, Graphing) {
        try generateProjectAtStub?(path) ?? (AbsolutePath("/test.xcodeproj"), Graph.test())
    }

    var generateProjectStub: ((Project) throws -> AbsolutePath)?
    func generateProject(_ project: Project, graph _: Graphing) throws -> AbsolutePath {
        try generateProjectStub?(project) ?? AbsolutePath("/test.xcodeproj")
    }

    var generateProjectWorkspaceStub: ((AbsolutePath, [AbsolutePath]) throws -> (AbsolutePath, Graphing))?
    func generateProjectWorkspace(at path: AbsolutePath, workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing) {
        try generateProjectWorkspaceStub?(path, workspaceFiles) ?? (AbsolutePath("/test.xcworkspace"), Graph.test())
    }

    var generateWorkspaceStub: ((AbsolutePath, [AbsolutePath]) throws -> (AbsolutePath, Graphing))?
    func generateWorkspace(at path: AbsolutePath, workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing) {
        try generateWorkspaceStub?(path, workspaceFiles) ?? (AbsolutePath("/test.xcworkspace"), Graph.test())
    }
}
