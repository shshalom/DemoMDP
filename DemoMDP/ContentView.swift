//
//  ContentView.swift
//  DemoMDP
//
//  Created by Shalom Shwaitzer on 11/11/25.
//  Test v2: Testing inline PR suggestions with vanilla UI violations
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {  // Using vanilla VStack - should use Alloy layout
            Image(systemName: "globe")  // Using vanilla Image - should use Alloy.Image
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")  // Using vanilla Text - should use Alloy.TextView
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
// Testing v1.1.20 with exact code suggestions
