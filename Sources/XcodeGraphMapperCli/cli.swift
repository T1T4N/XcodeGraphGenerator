import ArgumentParser
import Foundation
import Path
import XcodeGraph
import XcodeGraphMapper

extension Foundation.FileHandle: Swift.TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

extension XcodeGraph.Graph {
    func export(to filePath: URL) throws {
        let encoder = JSONEncoder()
        //#if DEBUG
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted, .withoutEscapingSlashes]
        //#endif

        let jsonData = try encoder.encode(self)
        try jsonData.write(to: filePath)
    }
}

@main
struct XcodeGraphMapperCli: AsyncParsableCommand {
    @Argument(help: "Path to Xcode project/workspace")
    var input: String

    @Argument(help: "Path to output graph.json")
    var output: String

    mutating func run() async throws {
        var stderr = FileHandle.standardError

        print("Input file: \(input)", to: &stderr)
        print("Output file: \(output)", to: &stderr)
        let outputFile = URL(filePath: output, directoryHint: .notDirectory)

        let mapper: XcodeGraphMapping = XcodeGraphMapper()
        let path = try AbsolutePath(validating: input)
        let graph = try await mapper.map(at: path)


        // You now have a Graph containing projects, targets, packages, and dependencies.*
        // Example: print all target names across all projects*
        for project in graph.projects.values {
            print("Found project: \(project.name)", to: &stderr)
            for (targetName, _) in project.targets {
                print("Found target: \(targetName)", to: &stderr)
            }
            print(to: &stderr)
        }

        try graph.export(to: outputFile)
    }
}
