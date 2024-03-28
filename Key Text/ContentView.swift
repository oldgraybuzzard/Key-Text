//
//  ContentView.swift
//  Key Text
//
//  Created by Kendall Felder on 3/28/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("shortcuts") private var savedShortcuts: Data?
    @State private var shortcuts: [String: String] = [:]
    @State private var shortcutInput = ""
    @State private var expansionInput = ""
    @State private var expandedText = ""
    
    var body: some View {
        VStack {
            Text("Text Expander")
                .font(.title)
                .padding()
            
            HStack {
                TextField("Enter shortcut", text: $shortcutInput)
                    .padding()
                TextField("Enter expansion", text: $expansionInput)
                    .padding()
                Button("Add") {
                    shortcuts[shortcutInput] = expansionInput
                    saveShortcuts()
                    shortcutInput = ""
                    expansionInput = ""
                }
                .padding()
            }
            
            Text("Shortcuts:")
                .font(.headline)
                .padding(.top)
            
            List {
                ForEach(Array(shortcuts.keys.sorted()), id: \.self) { key in
                    HStack {
                        Text(key)
                        Spacer()
                        Text(shortcuts[key] ?? "")
                    }
                }
            }
            .frame(height: 200)
            
            TextField("Type your shortcut", text: $expandedText)
                .padding()
            
            Button("Paste") {
                if let expansion = shortcuts[expandedText] {
                    TextExpanderHelper.expandText(expansion)
                }
            }
            .padding()
        }
        .padding()
        .onAppear {
            loadShortcuts()
        }
    }
    
    private func loadShortcuts() {
        if let data = savedShortcuts,
           let loadedShortcuts = try? JSONDecoder().decode([String: String].self, from: data) {
            shortcuts = loadedShortcuts
        }
    }
    
    private func saveShortcuts() {
        if let encoded = try? JSONEncoder().encode(shortcuts) {
            savedShortcuts = encoded
        }
    }
    
    func expandText(_ text: String) {
        DispatchQueue.global(qos: .background).async {
            let script = """
            tell application "System Events"
                keystroke "\(text)"
            end tell
            """
            if let scriptObject = NSAppleScript(source: script) {
                var errorInfo: NSDictionary?
                let output = scriptObject.executeAndReturnError(&errorInfo)
                if output != nil {
                    print("AppleScript executed successfully")
                } else if let error = errorInfo {
                    print("Error executing AppleScript: \(error)")
                } else {
                    print("Unknown error occurred while executing AppleScript.")
                }
            } else {
                print("Failed to create AppleScript object.")
            }
        }
    }

}
