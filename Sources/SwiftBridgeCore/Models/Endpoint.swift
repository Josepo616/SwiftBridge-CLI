import Foundation

/// Supported HTTP request methods.
public enum HTTPMethod: String, Sendable, Equatable, Codable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
}

/// Intermediate Representation of an API route/operation.
public struct Endpoint: Sendable, Equatable, Codable {
    /// The URL path template (e.g., "/users/{id}").
    public var path: String
    /// The HTTP method for this endpoint.
    public var method: HTTPMethod
    /// The unique operation identifier, if specified.
    public var operationId: String?
    /// A short summary of the endpoint's operation.
    public var summary: String?
    /// A detailed description of the endpoint.
    public var description: String?
    /// The list of parameters accepted by this endpoint.
    public var parameters: [Parameter]
    /// The request body definition, if applicable.
    public var requestBody: RequestBody?
    /// The possible responses returned by this endpoint.
    public var responses: [Response]

    /// Initializes a new `Endpoint` instance.
    /// - Parameters:
    ///   - path: The URL path template.
    ///   - method: The HTTP method.
    ///   - operationId: An optional unique operation identifier.
    ///   - summary: An optional summary.
    ///   - description: An optional detailed description.
    ///   - parameters: The list of parameters accepted.
    ///   - requestBody: The request body definition.
    ///   - responses: The list of responses returned.
    public init(
        path: String,
        method: HTTPMethod,
        operationId: String? = nil,
        summary: String? = nil,
        description: String? = nil,
        parameters: [Parameter] = [],
        requestBody: RequestBody? = nil,
        responses: [Response] = []
    ) {
        self.path = path
        self.method = method
        self.operationId = operationId
        self.summary = summary
        self.description = description
        self.parameters = parameters
        self.requestBody = requestBody
        self.responses = responses
    }
}
