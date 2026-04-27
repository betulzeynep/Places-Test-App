import XCTest
@testable import Places_Test_App

@MainActor
final class NetworkServiceTests: XCTestCase {

    func testFetchSuccessfullyDecodesValidJSON() async throws {
        let json = """
        {
            "locations": [
                {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041}
            ]
        }
        """
        let session = makeSession(
            data: try XCTUnwrap(json.data(using: .utf8)),
            response: validHTTPResponse()
        )
        let sut = NetworkService(session: session)

        let result: LocationResponse = try await sut.fetch(from: validURL())

        XCTAssertEqual(result.locations.count, 1)
        XCTAssertEqual(result.locations.first?.name, "Amsterdam")
    }

    func testFetchThrowsInvalidResponseForNon200StatusCode() async {
        let session = makeSession(
            data: Data(),
            response: HTTPURLResponse(
                url: validURL(),
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        let sut = NetworkService(session: session)

        do {
            let _: LocationResponse = try await sut.fetch(from: validURL())
            XCTFail("Expected serverError to be thrown")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testFetchThrowsInvalidResponseForNonHTTPResponse() async {
        let session = makeSession(
            data: Data(),
            response: URLResponse(
                url: validURL(),
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
        )
        let sut = NetworkService(session: session)

        do {
            let _: LocationResponse = try await sut.fetch(from: validURL())
            XCTFail("Expected invalidResponse to be thrown")
        } catch let error as NetworkError {
            if case .invalidResponse = error {
                // Success
            } else {
                XCTFail("Expected invalidResponse, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    private func validURL() -> URL {
        URL(string: "https://example.com/locations.json")!
    }

    private func validHTTPResponse() -> HTTPURLResponse {
        HTTPURLResponse(
            url: validURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func makeSession(
        data: Data,
        response: URLResponse,
        error: Error? = nil
    ) -> URLSession {
        MockURLProtocol.stub = (data, response, error)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

private final class MockURLProtocol: URLProtocol {
    static var stub: (data: Data, response: URLResponse, error: Error?)?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let stub = Self.stub else {
            client?.urlProtocol(
                self,
                didFailWithError: URLError(.badServerResponse)
            )
            return
        }

        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        client?.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: stub.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
