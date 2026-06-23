import XCTest
import GFBaseTool

class Tests: XCTestCase {

    func testStringValidation() {
        XCTAssertTrue("13800138000".isPhoneNumber)
        XCTAssertFalse("12345".isPhoneNumber)
        XCTAssertTrue("test@example.com".isEmail)
        XCTAssertFalse("invalid-email".isEmail)
        XCTAssertTrue("https://example.com".isURL)
    }

    func testJSONConversion() {
        let dic: [String: Any] = ["name": "GFBaseTool", "version": 1]
        let json = ToolManager.getJSONStringFromDic(dic: dic)
        XCTAssertFalse(json.isEmpty)
        let parsed = ToolManager.getDicFromJSONString(jsonString: json)
        XCTAssertEqual(parsed?["name"] as? String, "GFBaseTool")
    }

    func testCodableUtil() {
        struct Demo: Codable, Equatable {
            var title: String
        }
        let model = Demo(title: "hello")
        let json = CodableUtil.modelToJSONString(model)
        XCTAssertNotNil(json)
        let dic = CodableUtil.modelToDic(model)
        XCTAssertEqual(dic?["title"] as? String, "hello")
    }

    func testDateExtension() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        XCTAssertEqual(date.timeStamp.count, 10)
        XCTAssertEqual(date.milliStamp.count, 13)
        let str = Date.timeToDate(1_700_000_000_000)
        XCTAssertFalse(str.isEmpty)
    }

    func testUIColorHex() {
        let color = UIColor(hex: "#FF5500")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.hexString.uppercased(), "#FF5500")
    }

    func testUserDefaultsUtil() {
        UserDefaultsUtil.set("test_value", forKey: "gf_test_key")
        XCTAssertEqual(UserDefaultsUtil.string(forKey: "gf_test_key"), "test_value")
        UserDefaultsUtil.remove(forKey: "gf_test_key")
    }

    func testArraySafeSubscript() {
        let arr = [1, 2, 3]
        XCTAssertEqual(arr[safe: 1], 2)
        XCTAssertNil(arr[safe: 10])
    }

    func testSensitiveWords() {
        XCTAssertTrue(ToolManager.checkSensitiveWords(wordStr: "正常内容"))
    }

    func testDebouncer() {
        let exp = expectation(description: "debouncer")
        let debouncer = Debouncer(delay: 0.1)
        debouncer.call { exp.fulfill() }
        waitForExpectations(timeout: 1)
    }
}
