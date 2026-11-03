import Foundation

/// The data type category for an OpenAPI schema.
public enum SchemaType: String, Sendable, Equatable, Codable {
    case object
    case string
    case integer
    case number
    case boolean
    case array
    case composition
}

/// Intermediate Representation of an OpenAPI schema or model definition.
public struct Schema: Sendable, Equatable, Codable {
    /// The schema name (e.g., "User", "Pet").
    public var name: String
    /// An optional description of the schema.
    public var description: String?
    /// The high-level data type of the schema.
    public var type: SchemaType
    /// The ordered list of properties belonging to this schema.
    public var properties: [Property]
    /// The set of required property names for this schema.
    public var requiredProperties: Set<String>

    /// Initializes a new `Schema` instance.
    /// - Parameters:
    ///   - name: The schema name.
    ///   - description: An optional description.
    ///   - type: The schema type category.
    ///   - properties: The ordered list of schema properties.
    ///   - requiredProperties: The set of property names marked required.
    public init(
        name: String,
        description: String? = nil,
        type: SchemaType = .object,
        properties: [Property] = [],
        requiredProperties: Set<String> = []
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.properties = properties
        self.requiredProperties = requiredProperties
    }
}
