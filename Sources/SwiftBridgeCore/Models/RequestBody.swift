import Foundation

/// Intermediate Representation of an endpoint's request payload.
public struct RequestBody: Sendable, Equatable, Codable {
    /// An optional description of the request body.
    public var description: String?
    /// The primary content media type (e.g., "application/json").
    public var contentMediaType: String
    /// The schema type describing the payload structure.
    public var schema: PropertyType?
    /// Indicates whether the request body is required.
    public var isRequired: Bool

    /// Initializes a new `RequestBody` instance.
    /// - Parameters:
    ///   - description: An optional description.
    ///   - contentMediaType: The media type string, default is "application/json".
    ///   - schema: The schema type for the body payload.
    ///   - isRequired: Whether the request body is required.
    public init(
        description: String? = nil,
        contentMediaType: String = "application/json",
        schema: PropertyType? = nil,
        isRequired: Bool = false
    ) {
        self.description = description
        self.contentMediaType = contentMediaType
        self.schema = schema
        self.isRequired = isRequired
    }
}
