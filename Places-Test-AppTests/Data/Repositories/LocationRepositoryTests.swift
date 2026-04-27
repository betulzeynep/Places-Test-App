import XCTest
@testable import Places_Test_App

@MainActor
final class LocationRepositoryTests: XCTestCase {

    func testFetchLocationsReturnsValidLocations() async throws {
        let json = """
        {
            "locations": [
                {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041},
                {"name": "Berlin", "lat": 52.5200, "long": 13.4050}
            ]
        }
        """
        let mockService = MockNetworkService()
        mockService.result = .success(json.data(using: .utf8)!)
        let sut = LocationRepository(
            networkService: mockService,
            locationsURL: "https://example.com/locations.json"
        )

        let locations = try await sut.fetchLocations()

        XCTAssertEqual(locations.count, 2)
    }

    func testFetchLocationsFiltersOutInvalidCoordinates() async throws {
        let json = """
        {
            "locations": [
                {"name": "Valid", "lat": 52.3676, "long": 4.9041},
                {"name": "InvalidLat", "lat": 91.0, "long": 4.9041},
                {"name": "InvalidLon", "lat": 52.3676, "long": 181.0}
            ]
        }
        """
        let mockService = MockNetworkService()
        mockService.result = .success(json.data(using: .utf8)!)
        let sut = LocationRepository(
            networkService: mockService,
            locationsURL: "https://example.com/locations.json"
        )

        let locations = try await sut.fetchLocations()

        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "Valid")
    }

    func testFetchLocationsPropagatesNetworkError() async {
        let mockService = MockNetworkService()
        mockService.result = .failure(NetworkError.noInternetConnection)
        let sut = LocationRepository(
            networkService: mockService,
            locationsURL: "https://example.com/locations.json"
        )

        do {
            _ = try await sut.fetchLocations()
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error.userMessage, NetworkError.noInternetConnection.userMessage)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// MARK: - Mock Network Service

private final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Data, Error> = .success(Data())
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}
