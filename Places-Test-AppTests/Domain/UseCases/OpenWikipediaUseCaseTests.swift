import XCTest
@testable import Places_Test_App

@MainActor
final class OpenWikipediaUseCaseTests: XCTestCase {
    func testExecuteWithInvalidCoordinatesReturnsFalse() async {
        let sut = OpenWikipediaUseCase()
        let result = sut.execute(latitude: 91.0, longitude: 28.9784, locationName: nil)
        XCTAssertFalse(result)
    }

    func testWikipediaArticleURLFormatting() {
        let locationName = "New York City"
        let articleURL = Constants.DeepLink.wikipediaArticleURL(for: locationName)
        XCTAssertEqual(articleURL, "https://en.wikipedia.org/wiki/New_York_City")
    }

    func testLinkTypeURLStringForCoordinates() {
        let linkType = Constants.DeepLink.LinkType.placesWithCoordinates(
            lat: 52.3676,
            lon: 4.9041
        )
        let urlString = linkType.urlString
        XCTAssertEqual(urlString, "wikipedia://places?lat=52.3676&lon=4.9041")
    }
}
