//
//  TMPlayerSubtitleFormat.swift
//  Napi
//
//  Created by Mateusz Karwat on 06/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents TMPlayer Subtitle Format.
/// TMPlayer Subtitle Format looks like this:
///
///     01:12:33:First line of a text.|Seconds line of a text.
struct TMPlayerSubtitleFormat: SubtitleFormat {
    var startTimestamp: Timestamp?
    var stopTimestamp: Timestamp?
    
    var text: String
    
    static let regexPattern = "(\\d{1,2}):(\\d{1,2}):(\\d{1,2}):(.+)"

    static func decode(_ aString: String) -> TMPlayerSubtitleFormat? {
        guard
            let substrings = TMPlayerSubtitleFormat.capturedSubstrings(from: aString),
            let hours = Int(substrings[0]),
            let minutes = Int(substrings[1]),
            let seconds = Int(substrings[2]),
            substrings.count == 4 else {
                return nil
        }

        let timestamp = TS(hours: hours) + TS(minutes: minutes) + TS(seconds: seconds)

        return TMPlayerSubtitleFormat(startTimestamp: timestamp,
                                      stopTimestamp: nil,
                                      text: substrings[3])
    }
    
    func stringValue() -> String? {
        if let startTimestamp = startTimestamp {
            return "\(stringFormatForSubtitleTime(startTimestamp)):\(text)"
        }
        return nil
    }
}

extension TMPlayerSubtitleFormat {

    /// Returns `Timestamp` as a `String` that is compatible with TMPlayer format.
    private func stringFormatForSubtitleTime(_ timestamp: Timestamp)  -> String {
        let minutes = timestamp - TS(hours: timestamp.numberOfFullHours)
        let seconds = minutes - TS(minutes: minutes.numberOfFullMinutes)

        return
            "\(timestamp.numberOfFullHours.toString(leadingZeros: 2)):" +
            "\(minutes.numberOfFullMinutes.toString(leadingZeros: 2)):" +
            "\(seconds.numberOfFullSeconds.toString(leadingZeros: 2))"
    }
}
