import SwiftUI

struct TestComponentIndexView: View {
    @State private var username: String = ""
    @State private var sliderValue: Double = 0.5

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Component Index Test")
                .font(.title)

            Button("Click Me") {
                print("Button tapped")
            }

            TextField("Enter username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()

            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.largeTitle)

            Slider(value: $sliderValue, in: 0...1)
                .padding()

            Text("Slider value: \(sliderValue, specifier: "%.2f")")
        }
        .padding()
    }
}
# Retrigger workflow


