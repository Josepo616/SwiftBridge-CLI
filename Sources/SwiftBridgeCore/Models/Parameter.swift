import Foundation

/// The location where an endpoint parameter is supplied.
public enum ParameterLocation: String, Sendable, Equatable, Codable {
    case query
    case header
    case path
    case cookie
}

/// Intermediate Representation of an endpoint parameter.
public struct Parameter: Sendable, Equatable, Codable {
    /// The parameter name.
    public var name: String
    /// The location where this parameter is passed.
    public var location: ParameterLocation
    /// The type of the parameter value.
    public var type: PropertyType
    /// Indicates whether this parameter is required.
    public var isRequired: Bool
    /// An optional description of the parameter.
    public var description: String?

    /// Initializes a new `Parameter` instance.
    /// - Parameters:
    ///   - name: The parameter name.
    ///   - location: The parameter location.
    ///   - type: The parameter type.
    ///   - isRequired: Whether the parameter is required.
    ///   - description: An optional description.
    public init(
        name: String,
        location: ParameterLocation,
        type: PropertyType,
        isRequired: Bool = false,
        description: String? = nil
    ) {
        self.name = name
        self.location = location
        self.type = type
        self.isRequired = isRequired
        self.description = description
    }
}
