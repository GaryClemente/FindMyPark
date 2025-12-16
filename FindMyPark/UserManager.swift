//
//  UserManager.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/5/25.
//

import SwiftUI
import Foundation

struct StoredUser: Codable {
    let name: String
    let email: String
    let password: String
    let profileImageData: Data?
}

class UserManager {
    static let shared = UserManager()
    private let userKey = "storedUser"

    func saveUser(_ user: StoredUser) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    func loadUser() -> StoredUser? {
        if let savedData = UserDefaults.standard.data(forKey: userKey),
           let decoded = try? JSONDecoder().decode(StoredUser.self, from: savedData) {
            return decoded
        }
        return nil
    }

    func isEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
}
