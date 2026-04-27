import XCTest
@testable import Places_Test_App

@MainActor
final class LocationTests: XCTestCase {

    func testLocationDecodesFromValidJSON() throws {
        let json = """
        {
            "name": "Berlin",
            "lat": 52.5200,
            "long": 13.4050
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let location = try decoder.decode(Location.self, from: data)
        
        XCTAssertEqual(location.name, "Berlin")
        XCTAssertEqual(location.lat, 52.5200, accuracy: 0.0001)
        XCTAssertEqual(location.lon, 13.4050, accuracy: 0.0001)
    }

    func testLocationDecodesWithMissingNameUsingDefault() throws {
        let json = """
        {
            "lat": 52.5200,
            "long": 13.4050
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let location = try decoder.decode(Location.self, from: data)
        
        XCTAssertEqual(location.name, Constants.Defaults.unknownLocationName)
        XCTAssertEqual(location.lat, 52.5200, accuracy: 0.0001)
        XCTAssertEqual(location.lon, 13.4050, accuracy: 0.0001)
    }

    func testLocationValidityReturnsFalseForInvalidLatitude() {
        let invalidLocation = Location(name: "Invalid", latitude: 91.0, longitude: 13.4050)
        XCTAssertFalse(invalidLocation.isValid)
    }
}
