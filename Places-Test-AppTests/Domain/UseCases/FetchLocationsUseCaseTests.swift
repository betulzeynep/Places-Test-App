import XCTest
@testable import Places_Test_App

@MainActor
final class FetchLocationsUseCaseTests: XCTestCase {

    func testExecuteSortsLocationsAlphabetically() async throws {
        let repository = MockLocationRepository()
        repository.result = .success([
            Location(name: "Zurich", latitude: 47.3769, longitude: 8.5417),
            Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041),
            Location(name: "Berlin", latitude: 52.5200, longitude: 13.4050)
        ])

        let sut = FetchLocationsUseCase(repository: repository)

        let locations = try await sut.execute()
        let names = locations.map { $0.name }

        XCTAssertEqual(names, ["Amsterdam", "Berlin", "Zurich"])
    }

    func testExecutePropagatesRepositoryError() async {
        let repository = MockLocationRepository()
        repository.result = .failure(NetworkError.noInternetConnection)
        let sut = FetchLocationsUseCase(repository: repository)

        do {
            _ = try await sut.execute()
            XCTFail("Expected execute() to throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error.userMessage, NetworkError.noInternetConnection.userMessage)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

private final class MockLocationRepository: LocationRepositoryProtocol {
    var result: Result<[Location], Error> = .success([])

    func fetchLocations() async throws -> [Location] {
        switch result {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
}
