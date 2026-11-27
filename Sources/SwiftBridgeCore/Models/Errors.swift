import Foundation

/// Errors that can occur during the fetching, loading, parsing, and resolving of OpenAPI specifications.
public enum SpecParsingError: Error, LocalizedError, Sendable, Equatable {
    /// The provided URL string is malformed or invalid.
    case invalidURL(String)
    /// A network request failed with an HTTP status code and an optional response body or message.
    case networkError(statusCode: Int, message: String? = nil)
    /// The OpenAPI specification version is unsupported (e.g. Swagger 2.0 or an unreleased version).
    case unsupportedVersion(String)
    /// The specification content is malformed or cannot be parsed as valid JSON/YAML.
    case invalidStructure(String)
    /// A required field is missing in the specification at a specific object path.
    case missingRequiredField(field: String, path: String)
    /// A `$ref` pointer could not be resolved in the document components.
    case unresolvedReference(String)
    /// A circular `$ref` reference was detected that cannot be recursively resolved.
    case circularReference(String)

    /// A localized, human-readable description explaining the error and suggested remediation.
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid specification URL: '\(urlString)'. Please provide a valid, well-formed HTTP/HTTPS URL or file path."
        case .networkError(let statusCode, let message):
            if let message, !message.isEmpty {
                return "Failed to fetch remote specification (HTTP \(statusCode)): \(message)"
            } else {
                return "Failed to fetch remote specification with HTTP status code \(statusCode)."
            }
        case .unsupportedVersion(let version):
            return "Unsupported OpenAPI version '\(version)'. SwiftBridge CLI currently supports OpenAPI 3.0.x and 3.1.x specifications."
        case .invalidStructure(let details):
            return "Failed to parse specification structure: \(details)"
        case .missingRequiredField(let field, let path):
            return "Missing required field '\(field)' at path '\(path)'."
        case .unresolvedReference(let reference):
            return "Unresolved reference '\(reference)'. Verify that the component exists in the specification schemas."
        case .circularReference(let reference):
            return "Circular reference detected for '\(reference)'."
        }
    }
}
