import SwiftUI

struct TestComponentIndexView: View {
    @State private var textInput = ""
    @State private var sliderValue = 0.5

    var body: some View {
        VStack {
            Text("Test Component Index Detection")
                .padding()

            Button("Test Button") {
                print("Button tapped")
            }
            .padding()

            TextField("Enter text", text: $textInput)
                .padding()

            Image(systemName: "star.fill")
                .padding()

            Slider(value: $sliderValue, in: 0...1)
                .padding()

            Text("Slider value: \(sliderValue, specifier: "%.2f")")
        }
        .padding()
    }
}
