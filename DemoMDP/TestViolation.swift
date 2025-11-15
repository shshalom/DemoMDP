import Foundation

struct User {
    let name: String
}

func greetUser() {
    let user: User? = nil
    // This has a force unwrap - should be caught!
    print("Hello, \(user!.name)")
}