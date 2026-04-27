import XCTest

@testable import Places_Test_App

@MainActor
final class LocationsViewModelTests: XCTestCase {
    func testFetchLocationsSuccessUpdatesState() async {
        let fetchUseCase = MockFetchLocationsUseCase()
        let openUseCase = MockOpenWikipediaUseCase()
        fetchUseCase.result = .success([
            Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        ])

        let sut = LocationsViewModel(
            fetchLocationsUseCase: fetchUseCase,
            openWikipediaUseCase: openUseCase
        )
        await sut.fetchLocations()
        XCTAssertEqual(sut.locations.count, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testFetchLocationsFailureSetsErrorAndClearsLocations() async {
        // Given
        let fetchUseCase = MockFetchLocationsUseCase()
        let openUseCase = MockOpenWikipediaUseCase()
        fetchUseCase.result = .failure(NetworkError.noInternetConnection)

        let sut = LocationsViewModel(
            fetchLocationsUseCase: fetchUseCase,
            openWikipediaUseCase: openUseCase
        )
        await sut.fetchLocations()
        XCTAssertTrue(sut.locations.isEmpty)
        XCTAssertEqual(
            sut.errorMessage,
            NetworkError.noInternetConnection.userMessage
        )
    }

    func testOpenLocationFailureShowsNotInstalledError() {
        let fetchUseCase = MockFetchLocationsUseCase()
        let openUseCase = MockOpenWikipediaUseCase()
        openUseCase.coordinatesOnlyResult = false
        let sut = LocationsViewModel(
            fetchLocationsUseCase: fetchUseCase,
            openWikipediaUseCase: openUseCase
        )

        let location = Location(
            name: "Istanbul",
            latitude: 41.0082,
            longitude: 28.9784
        )
        sut.openLocation(location)
        XCTAssertEqual(
            sut.errorMessage,
            DeepLinkError.wikipediaNotInstalled.userMessage
        )
    }
}

// MARK: - Mock Objects

private final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    var result: Result<[Location], Error> = .success([])

    func execute() async throws -> [Location] {
        switch result {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
}

private final class MockOpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {
    // Results for different methods
    var coordinatesOnlyResult = true
    var coordinatesWithNameResult = true
    var nameOnlyResult = true
    var linkTypeResult = true

    // Tracked calls for coordinates only method
    var lastLatitudeOnly: Double?
    var lastLongitudeOnly: Double?

    // Tracked calls for coordinates with name method
    var lastLatitudeWithName: Double?
    var lastLongitudeWithName: Double?
    var lastLocationName: String?

    // Tracked calls for name only method
    var lastNameOnly: String?

    // Tracked calls for link type method
    var lastLinkType: Constants.DeepLink.LinkType?

    func execute(latitude: Double, longitude: Double) -> Bool {
        lastLatitudeOnly = latitude
        lastLongitudeOnly = longitude
        return coordinatesOnlyResult
    }

    func execute(latitude: Double, longitude: Double, locationName: String?)
        -> Bool
    {
        lastLatitudeWithName = latitude
        lastLongitudeWithName = longitude
        lastLocationName = locationName
        return coordinatesWithNameResult
    }

    func execute(locationName: String) -> Bool {
        lastNameOnly = locationName
        return nameOnlyResult
    }

    func execute(linkType: Constants.DeepLink.LinkType) -> Bool {
        lastLinkType = linkType
        return linkTypeResult
    }
}
