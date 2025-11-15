import SwiftUI

struct ProfileSettingsView: View {
    @State private var username: String = "John Doe"
    @State private var email: String = "john@example.com"
    @State private var notificationsEnabled: Bool = true
    @State private var darkModeEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(username)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Email")
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }

                Section {
                    Button("Edit Profile") {
                        // Edit profile action
                    }

                    Button("Change Password") {
                        // Change password action
                    }
                    .foregroundColor(.blue)
                }

                Section {
                    Button("Sign Out") {
                        // Sign out action
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
