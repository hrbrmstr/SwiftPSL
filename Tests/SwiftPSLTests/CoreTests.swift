import XCTest

@testable import SwiftPSL

let psl = SwiftPSL()

class CoreTests : XCTestCase {
  
  func test_isPublicSuffix() {
    XCTAssertFalse(psl.isPublicSuffix("www.example.com"))
    XCTAssertTrue(psl.isPublicSuffix("com.ar"))
    XCTAssertFalse(psl.isPublicSuffix("www.com.ar"))
    XCTAssertTrue(psl.isPublicSuffix("cc.ar.us"))
    XCTAssertTrue(psl.isPublicSuffix(".cc.ar.us"))
    XCTAssertFalse(psl.isPublicSuffix("www.cc.ar.us"))
    XCTAssertFalse(psl.isPublicSuffix("www.ck"))
    XCTAssertFalse(psl.isPublicSuffix("abc.www.ck"))
    XCTAssertTrue(psl.isPublicSuffix("xxx.ck"))
    XCTAssertFalse(psl.isPublicSuffix("www.xxx.ck"))
    XCTAssertTrue(psl.isPublicSuffix("name"))
    XCTAssertTrue(psl.isPublicSuffix(".name"))
    XCTAssertFalse(psl.isPublicSuffix("hpsl.is.name"))
    XCTAssertFalse(psl.isPublicSuffix(".hpsl.is.name"))
    XCTAssertFalse(psl.isPublicSuffix("forgot.hpsl.is.name"))
    XCTAssertFalse(psl.isPublicSuffix(".forgot.hpsl.is.name"))
    XCTAssertFalse(psl.isPublicSuffix("whoever.hpsl.is.name"))
    XCTAssertFalse(psl.isPublicSuffix("whoever.forgot.hpsl.is.name"))
    XCTAssertTrue(psl.isPublicSuffix("."))
    XCTAssertTrue(psl.isPublicSuffix(""))
    XCTAssertTrue(psl.isPublicSuffix("adfhoweirh"))
    XCTAssertTrue(psl.isPublicSuffix("compute.amazonaws.com"))
    XCTAssertTrue(psl.isPublicSuffix("y.compute.amazonaws.com"))
    XCTAssertFalse(psl.isPublicSuffix("x.y.compute.amazonaws.com"))
  }
  
}
