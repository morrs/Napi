//
//  MPL2SubtitleFormatTests.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class MPL2SubtitleFormatTests: XCTestCase {
    
    func testStringValue() {
        let mplFormat = MPL2SubtitleFormat(startTimestamp: TS(milliseconds: 99_100),
                                           stopTimestamp: TS(milliseconds: 100_000),
                                           text: "Test.")

        XCTAssertEqual(mplFormat.stringValue(), "[991][1000]Test.")
    }

    func testStringValueNil() {
        let timestamp = TS(milliseconds: 1000)

        XCTAssertNil(MPL2SubtitleFormat(startTimestamp: nil, stopTimestamp: timestamp, text: "Test").stringValue())
        XCTAssertNil(MPL2SubtitleFormat(startTimestamp: timestamp, stopTimestamp: nil, text: "Test").stringValue())
    }

    func testDecodeCorrectInput() {
        let input = "[1][9999]Test."

        let mplFormat = MPL2SubtitleFormat.decode(input)

        XCTAssertEqual(mplFormat?.startTimestamp?.milliseconds, 100)
        XCTAssertEqual(mplFormat?.stopTimestamp?.milliseconds, 999_900)
        XCTAssertEqual(mplFormat?.text, "Test.")
    }

    func testDecodeIncorrectInput() {
        let incorrectInputs = ["[][1]Test.",
                               "[1][]Test.",
                               "[1]  Test.",
                               "  [1]Test.",
                               "[1]Test.",
                               "[1][1]",
                               "Test."]

        for incorrectInput in incorrectInputs {
            XCTAssertNil(MPL2SubtitleFormat.decode(incorrectInput))
        }
    }

}
