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
        VStack { // VIOLATION: should use Alloy.VStack
            Image(systemName: "globe") // VIOLATION: should use Alloy.Image
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!") // VIOLATION: should use Alloy.Text
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
