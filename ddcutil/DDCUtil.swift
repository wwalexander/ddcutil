import Foundation
import ArgumentParser
import BinaryCodable

enum DDCUtilError: String, LocalizedError {
    var errorDescription: String? { rawValue }

    case noExternalDisplayFound = "No external display found"
    case displayIsMissingEDID = "Display is missing EDID"
}

@main
struct DDCUtil: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility for interacting with an external display via DDC/CI.",
        version: "0.0.1",
        subcommands: [GetEDID.self])
}

extension DDCUtil {
    struct GetEDID: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Get the EDID of the external display.")
        
        @Flag(help: "Emit a property list instead of the normal binary output.")
        var plist = false

        mutating func run() throws {
            guard let monitor = ExternalDisplayDataService() else {
                throw DDCUtilError.noExternalDisplayFound
            }
            
            guard let edidData = monitor.edid() else {
                throw DDCUtilError.displayIsMissingEDID
            }
            
            let outputData: Data
            
            if plist {
                let decoder = BinaryDataDecoder()
                let edid = try decoder.decode(EDID.self, from: edidData)
                let encoder = PropertyListEncoder()
                encoder.outputFormat = .xml
                outputData = try encoder.encode(edid)
            } else {
                outputData = edidData
            }
            
            try FileHandle.standardOutput.write(contentsOf: outputData)
        }
    }
}

