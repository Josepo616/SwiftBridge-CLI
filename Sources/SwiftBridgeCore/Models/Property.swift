import Foundation

/// Integer format modifiers supported by OpenAPI.
public enum IntegerFormat: String, Sendable, Equatable, Codable {
    case int32
    case int64
}

/// Floating-point number format modifiers supported by OpenAPI.
public enum NumberFormat: String, Sendable, Equatable, Codable {
    case float
    case double
}

/// Represents the type of a schema property, parameter, or response payload.
public indirect enum PropertyType: Sendable, Equatable, Codable {
    /// A UTF-8 string type (`String`).
    case string
    /// An integer type (`Int`, `Int32`, `Int64`).
    case integer(format: IntegerFormat? = nil)
    /// A floating-point number type (`Float`, `Double`).
    case number(format: NumberFormat? = nil)
    /// A boolean flag (`Bool`).
    case boolean
    /// A date or date-time value (`Date`).
    case date
    /// A uniform resource locator (`URL`).
    case url
    /// An array containing elements of the specified type (`[ElementType]`).
    case array(elementType: PropertyType)
    /// A reference to another schema by name (`#/components/schemas/Name`).
    case reference(String)
    /// A string enumeration with predefined acceptable values.
    case enumeration([String])
    /// An inline or nested object schema.
    case object(name: String? = nil)
    /// An unconstrained or untyped schema (`AnyCodable` or unstructured JSON).
    case untyped
}

/// Intermediate Representation of a field or property within an OpenAPI schema.
public struct Property: Sendable, Equatable, Codable {
    /// The name of the property.
    public var name: String
    /// The resolved property type.
    public var type: PropertyType
    /// An optional description of the property.
    public var description: String?
    /// Indicates whether the property is required by the parent schema.
    public var isRequired: Bool
    /// Indicates whether the property value can be null.
    public var isNullable: Bool

    /// Initializes a new `Property` instance.
    /// - Parameters:
    ///   - name: The property name.
    ///   - type: The resolved property type.
    ///   - description: An optional description.
    ///   - isRequired: Whether the property is required.
    ///   - isNullable: Whether the property accepts null values.
    public init(
        name: String,
        type: PropertyType,
        description: String? = nil,
        isRequired: Bool = false,
        isNullable: Bool = false
    ) {
        self.name = name
        self.type = type
        self.description = description
        self.isRequired = isRequired
        self.isNullable = isNullable
    }
}
