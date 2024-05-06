//
//  File.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation

// Syntax sugar to have shorter paths to check if we should stub out some network calls and data.
extension ProcessInfo {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    static var isTest: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    static var isRecordingSession: Bool {
        return ProcessInfo.processInfo.environment["RECORD_URL_SESSION"] == "1"
    }
    
    static var isReplayingSession: Bool {
        return ProcessInfo.processInfo.environment["REPLAY_URL_SESSION"] == "1"
    }
}
