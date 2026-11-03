import Foundation

/// Intermediate Representation of an endpoint's HTTP response.
public struct Response: Sendable, Equatable, Codable {
    /// The HTTP status code string (e.g., "200", "201", "404", "default").
    public var statusCode: String
    /// An optional description of the response.
    public var description: String?
    /// The schema type describing the response body, if any.
    public var schema: PropertyType?

    /// Initializes a new `Response` instance.
    /// - Parameters:
    ///   - statusCode: The HTTP status code string.
    ///   - description: An optional description.
    ///   - schema: The schema type for the response body.
    public init(
        statusCode: String,
        description: String? = nil,
        schema: PropertyType? = nil
    ) {
        self.statusCode = statusCode
        self.description = description
        self.schema = schema
    }
}
