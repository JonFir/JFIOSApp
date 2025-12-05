import Foundation
import Testing
import LibTests
import FactoryKit
import Alamofire

private struct User: Codable, Equatable, Sendable {
    let id: Int
    let name: String
}

struct MockUrlProtocolTests {
    @Test
    func returnsMockResponseForMatchingUrl() async throws {
        let user = User(id: 1, name: "John")
        Container.shared.setupMocks([
            MockResponse(
                url: "https://api.example.com/users",
                method: "POST",
                statusCode: 200,
                codable: user
            )
        ])
        let url = try #require(URL(string: "https://api.example.com/users"))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let result = await Container.shared.networkSession()!
            .request("https://api.example.com/users", method: .post, parameters: user)
            .serializingDecodable(User.self)
            .response
        #expect(result.error == nil)
        #expect(result.response?.statusCode == 200)
        #expect(result.value == user)
    }
}
