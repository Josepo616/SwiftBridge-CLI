import Foundation
import Testing
@testable import SwiftBridgeCore

@Suite("SpecParsingError Tests")
struct ErrorTests {
    @Test("SpecParsingError enum cases and Equatable conformance")
    func testErrorEquality() {
        let err1 = SpecParsingError.invalidURL("ht!tp://bad-url")
        let err2 = SpecParsingError.invalidURL("ht!tp://bad-url")
        let err3 = SpecParsingError.invalidURL("https://example.com/spec.json")

        #expect(err1 == err2)
        #expect(err1 != err3)

        let netErr1 = SpecParsingError.networkError(statusCode: 404, message: "Not Found")
        let netErr2 = SpecParsingError.networkError(statusCode: 404, message: "Not Found")
        let netErr3 = SpecParsingError.networkError(statusCode: 500, message: "Server Error")
        let netErrNoMsg = SpecParsingError.networkError(statusCode: 404, message: nil)

        #expect(netErr1 == netErr2)
        #expect(netErr1 != netErr3)
        #expect(netErr1 != netErrNoMsg)

        let versionErr = SpecParsingError.unsupportedVersion("2.0")
        let structErr = SpecParsingError.invalidStructure("Unexpected EOF")
        let missingErr = SpecParsingError.missingRequiredField(field: "paths", path: "#/paths")
        let unrefErr = SpecParsingError.unresolvedReference("#/components/schemas/NonExistent")
        let circularErr = SpecParsingError.circularReference("#/components/schemas/Node")

        #expect(versionErr != structErr)
        #expect(missingErr != unrefErr)
        #expect(circularErr == SpecParsingError.circularReference("#/components/schemas/Node"))
    }

    @Test("LocalizedError errorDescription generates human-readable diagnostics")
    func testErrorDescriptions() {
        let invalidURL = SpecParsingError.invalidURL("ht!tp://bad-url")
        #expect(invalidURL.errorDescription?.contains("ht!tp://bad-url") == true)
        #expect(invalidURL.errorDescription?.contains("Invalid specification URL") == true)

        let netErrorWithMsg = SpecParsingError.networkError(statusCode: 404, message: "Resource not found")
        #expect(netErrorWithMsg.errorDescription?.contains("HTTP 404") == true)
        #expect(netErrorWithMsg.errorDescription?.contains("Resource not found") == true)

        let netErrorNoMsg = SpecParsingError.networkError(statusCode: 503)
        #expect(netErrorNoMsg.errorDescription?.contains("HTTP status code 503") == true)

        let unsupportedVersion = SpecParsingError.unsupportedVersion("2.0")
        #expect(unsupportedVersion.errorDescription?.contains("Unsupported OpenAPI version '2.0'") == true)
        #expect(unsupportedVersion.errorDescription?.contains("OpenAPI 3.0.x and 3.1.x") == true)

        let invalidStruct = SpecParsingError.invalidStructure("Missing closing bracket at line 12")
        #expect(invalidStruct.errorDescription?.contains("Missing closing bracket at line 12") == true)

        let missingField = SpecParsingError.missingRequiredField(field: "info", path: "#/")
        #expect(missingField.errorDescription?.contains("Missing required field 'info' at path '#/'") == true)

        let unref = SpecParsingError.unresolvedReference("#/components/schemas/User")
        #expect(unref.errorDescription?.contains("Unresolved reference '#/components/schemas/User'") == true)

        let circular = SpecParsingError.circularReference("#/components/schemas/LinkedList")
        #expect(circular.errorDescription?.contains("Circular reference detected for '#/components/schemas/LinkedList'") == true)
    }

    @Test("SpecParsingError conforms to Sendable across concurrency boundaries")
    func testSendableConformance() async {
        let error = SpecParsingError.missingRequiredField(field: "openapi", path: "#/")

        let task = Task { () -> String? in
            return error.errorDescription
        }

        let description = await task.value
        #expect(description?.contains("openapi") == true)
    }
}
