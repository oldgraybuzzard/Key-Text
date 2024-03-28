//
//  Helper.swift
//  Key Text
//
//  Created by Kendall Felder on 3/28/24.
//

import SwiftUI

class TextExpanderHelper {
    static func expandText(_ text: String) {
        // Use AppleScript to expand text in other applications
        let script = """
        tell application "System Events"
            keystroke "\(text)"
        end tell
        """
        if let scriptObject = NSAppleScript(source: script) {
            var error: NSDictionary?
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
