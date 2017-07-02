import XCTest
@testable import SwiftNetworking

final class NetworkClientTests: XCTestCase {
    
    // MARK: - Properties
    
    let baseURL = URL(string: "http://example.com/api/v1/")!
    
    // MARK: - Tests
    
    func testBuildRequest() {
        
        let client = NetworkClient(baseURL: baseURL)
        
        // Request without parameters
        let url1 = URL(string: "http://example.com/api/v1/me")!
        let request1 = client.buildRequest(method: .get, path: "me")
        XCTAssertEqual("GET", request1.httpMethod!)
        XCTAssertEqual(url1, request1.url)
        
        // Request with parameters
        let params = ["username": "archimedes"]
        let request2 = client.buildRequest(method: .post, path: "users", parameters: params)
        XCTAssertEqual("POST", request2.httpMethod)
        XCTAssertEqual(try! JSONSerialization.data(withJSONObject: params, options: []), request2.httpBody)
        
        // Request with query items
        let url3 = URL(string: "http://example.com/api/v1/search?query=science")!
        let queryItems = [URLQueryItem(name: "query", value: "science")]
        let request3 = client.buildRequest(path: "search", queryItems: queryItems)
        XCTAssertEqual(url3, request3.url)
    }
    
    func testRequest() {
        let session = MockSession { (request) -> (NetworkResult) in
            return .failure(NetworkClient.Error.unknown)
        }
        
        let client = NetworkClient(baseURL: baseURL, session: session)
        client.request(path: "me")
        
        let url1 = URL(string: "http://example.com/api/v1/me")!
        
        let request = session.interactions.first!.0
        XCTAssertEqual("GET", request.httpMethod)
        XCTAssertEqual(url1, request.url)
        
    }
}
