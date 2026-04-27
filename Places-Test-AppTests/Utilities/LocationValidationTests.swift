import XCTest
@testable import Places_Test_App

final class LocationValidationTests: XCTestCase {
    func testIsValidLatitudeOutOfRangeReturnsFalse() {
        XCTAssertFalse(LocationValidation.isValidLatitude(-90.1))
        XCTAssertFalse(LocationValidation.isValidLatitude(90.1))
    }

    func testParseCoordinateSupportsDotAndComma() {
        XCTAssertEqual(LocationValidation.parseCoordinate("41.0082") ?? 0.0, 41.0082, accuracy: 0.0001)
        XCTAssertEqual(LocationValidation.parseCoordinate("41,0082") ?? 0.0, 41.0082, accuracy: 0.0001)
    }

    func testParseCoordinateReturnsNilForInvalidInput() {
        XCTAssertNil(LocationValidation.parseCoordinate("hello"))
        XCTAssertNil(LocationValidation.parseCoordinate("--12"))
    }
}
