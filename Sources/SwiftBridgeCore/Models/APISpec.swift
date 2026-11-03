import Foundation

/// Root Intermediate Representation (IR) model representing a parsed OpenAPI specification.
public struct APISpec: Sendable, Equatable, Codable {
    /// The title of the API.
    public var title: String
    /// The version of the API specification document.
    public var version: String
    /// An optional short description of the API.
    public var description: String?
    /// The primary server URL where the API is hosted, if specified.
    public var serverURL: URL?
    /// The list of API endpoints defined in the specification.
    public var endpoints: [Endpoint]
    /// The schemas defined in `components.schemas`, keyed by schema name.
    public var schemas: [String: Schema]

    /// Initializes a new `APISpec` instance.
    /// - Parameters:
    ///   - title: The title of the API.
    ///   - version: The version of the API specification.
    ///   - description: An optional description of the API.
    ///   - serverURL: The primary base server URL.
    ///   - endpoints: The list of endpoints defined in the spec.
    ///   - schemas: The schema dictionary keyed by schema name.
    public init(
        title: String,
        version: String,
        description: String? = nil,
        serverURL: URL? = nil,
        endpoints: [Endpoint] = [],
        schemas: [String: Schema] = [:]
    ) {
        self.title = title
        self.version = version
        self.description = description
        self.serverURL = serverURL
        self.endpoints = endpoints
        self.schemas = schemas
    }
}
