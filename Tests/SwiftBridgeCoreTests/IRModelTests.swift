import Foundation
import Testing
@testable import SwiftBridgeCore

@Suite("IR Model Tests")
struct IRModelTests {
    @Test("PropertyType enum cases and Equatable")
    func testPropertyTypeCases() {
        let stringType = PropertyType.string
        let int32Type = PropertyType.integer(format: .int32)
        let int64Type = PropertyType.integer(format: .int64)
        let defaultIntType = PropertyType.integer()
        let floatType = PropertyType.number(format: .float)
        let doubleType = PropertyType.number(format: .double)
        let boolType = PropertyType.boolean
        let dateType = PropertyType.date
        let urlType = PropertyType.url
        let arrayType = PropertyType.array(elementType: .string)
        let refType = PropertyType.reference("User")
        let enumType = PropertyType.enumeration(["active", "inactive"])
        let objectType = PropertyType.object(name: "Address")
        let untypedType = PropertyType.untyped

        #expect(stringType == .string)
        #expect(int32Type == .integer(format: .int32))
        #expect(int64Type == .integer(format: .int64))
        #expect(defaultIntType == .integer(format: nil))
        #expect(floatType == .number(format: .float))
        #expect(doubleType == .number(format: .double))
        #expect(boolType == .boolean)
        #expect(dateType == .date)
        #expect(urlType == .url)
        #expect(arrayType == .array(elementType: .string))
        #expect(refType == .reference("User"))
        #expect(enumType == .enumeration(["active", "inactive"]))
        #expect(objectType == .object(name: "Address"))
        #expect(untypedType == .untyped)
        #expect(stringType != boolType)
    }

    @Test("Property initialization and equality")
    func testPropertyInitialization() {
        let prop1 = Property(
            name: "id",
            type: .integer(format: .int64),
            description: "Unique identifier",
            isRequired: true,
            isNullable: false
        )
        let prop2 = Property(
            name: "id",
            type: .integer(format: .int64),
            description: "Unique identifier",
            isRequired: true,
            isNullable: false
        )
        let prop3 = Property(
            name: "email",
            type: .string,
            isRequired: false,
            isNullable: true
        )

        #expect(prop1 == prop2)
        #expect(prop1 != prop3)
        #expect(prop3.description == nil)
        #expect(prop3.isRequired == false)
        #expect(prop3.isNullable == true)
    }

    @Test("Schema initialization and equality")
    func testSchemaInitialization() {
        let propId = Property(name: "id", type: .integer(format: .int64), isRequired: true)
        let propName = Property(name: "name", type: .string, isRequired: true)

        let schema1 = Schema(
            name: "User",
            description: "User profile",
            type: .object,
            properties: [propId, propName],
            requiredProperties: ["id", "name"]
        )
        let schema2 = Schema(
            name: "User",
            description: "User profile",
            type: .object,
            properties: [propId, propName],
            requiredProperties: ["id", "name"]
        )

        #expect(schema1 == schema2)
        #expect(schema1.name == "User")
        #expect(schema1.type == .object)
        #expect(schema1.properties.count == 2)
        #expect(schema1.requiredProperties.contains("id"))
    }

    @Test("HTTPMethod enum values")
    func testHTTPMethod() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
        #expect(HTTPMethod.head.rawValue == "HEAD")
        #expect(HTTPMethod.options.rawValue == "OPTIONS")
        #expect(HTTPMethod.trace.rawValue == "TRACE")
        #expect(HTTPMethod.allCases.count == 8)
    }

    @Test("Parameter and ParameterLocation initialization")
    func testParameter() {
        let queryParam = Parameter(
            name: "limit",
            location: .query,
            type: .integer(),
            isRequired: false,
            description: "Max number of items"
        )
        let pathParam = Parameter(
            name: "id",
            location: .path,
            type: .string,
            isRequired: true
        )

        #expect(queryParam.location == .query)
        #expect(queryParam.isRequired == false)
        #expect(pathParam.location == .path)
        #expect(pathParam.isRequired == true)
        #expect(queryParam != pathParam)
    }

    @Test("RequestBody and Response models")
    func testRequestBodyAndResponse() {
        let body = RequestBody(
            description: "New user payload",
            contentMediaType: "application/json",
            schema: .reference("NewUser"),
            isRequired: true
        )
        #expect(body.contentMediaType == "application/json")
        #expect(body.isRequired == true)
        #expect(body.schema == .reference("NewUser"))

        let response200 = Response(
            statusCode: "200",
            description: "Success",
            schema: .reference("User")
        )
        let responseDefault = Response(
            statusCode: "default",
            description: "Unexpected error",
            schema: .reference("Error")
        )
        #expect(response200.statusCode == "200")
        #expect(responseDefault.statusCode == "default")
        #expect(response200 != responseDefault)
    }

    @Test("Endpoint initialization and equality")
    func testEndpoint() {
        let endpoint = Endpoint(
            path: "/users/{id}",
            method: .get,
            operationId: "getUserById",
            summary: "Fetch user by ID",
            description: "Returns a single user model",
            parameters: [
                Parameter(name: "id", location: .path, type: .string, isRequired: true)
            ],
            requestBody: nil,
            responses: [
                Response(statusCode: "200", description: "Found user", schema: .reference("User")),
                Response(statusCode: "404", description: "User not found", schema: nil)
            ]
        )

        #expect(endpoint.path == "/users/{id}")
        #expect(endpoint.method == .get)
        #expect(endpoint.operationId == "getUserById")
        #expect(endpoint.parameters.count == 1)
        #expect(endpoint.responses.count == 2)
    }

    @Test("APISpec complete graph encoding and decoding roundtrip")
    func testAPISpecCodableRoundtrip() throws {
        let userSchema = Schema(
            name: "User",
            description: "A user account",
            type: .object,
            properties: [
                Property(name: "id", type: .integer(format: .int64), isRequired: true),
                Property(name: "username", type: .string, isRequired: true),
                Property(name: "email", type: .string, isRequired: false, isNullable: true),
                Property(name: "tags", type: .array(elementType: .string), isRequired: false),
                Property(name: "status", type: .enumeration(["pending", "active", "suspended"]), isRequired: true)
            ],
            requiredProperties: ["id", "username", "status"]
        )

        let endpoint = Endpoint(
            path: "/users",
            method: .post,
            operationId: "createUser",
            summary: "Create a user",
            parameters: [
                Parameter(name: "dryRun", location: .query, type: .boolean, isRequired: false)
            ],
            requestBody: RequestBody(
                description: "User to create",
                contentMediaType: "application/json",
                schema: .reference("User"),
                isRequired: true
            ),
            responses: [
                Response(statusCode: "201", description: "Created", schema: .reference("User"))
            ]
        )

        let originalSpec = APISpec(
            title: "Sample API",
            version: "1.0.0",
            description: "A test API spec",
            serverURL: URL(string: "https://api.example.com/v1"),
            endpoints: [endpoint],
            schemas: ["User": userSchema]
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let encodedData = try encoder.encode(originalSpec)

        let decoder = JSONDecoder()
        let decodedSpec = try decoder.decode(APISpec.self, from: encodedData)

        #expect(decodedSpec == originalSpec)
        #expect(decodedSpec.title == "Sample API")
        #expect(decodedSpec.version == "1.0.0")
        #expect(decodedSpec.serverURL == URL(string: "https://api.example.com/v1"))
        #expect(decodedSpec.schemas["User"]?.properties.count == 5)
        #expect(decodedSpec.endpoints.first?.operationId == "createUser")
    }

    @Test("Sendable conformance verification across concurrency boundaries")
    func testSendableConcurrency() async {
        let spec = APISpec(
            title: "Async API",
            version: "2.0.0",
            endpoints: [
                Endpoint(path: "/health", method: .get)
            ]
        )

        let task = Task { () -> String in
            return spec.title
        }

        let result = await task.value
        #expect(result == "Async API")
    }
}
