//
//  AppSession.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/16.
//

import SwiftUI
import Combine

@MainActor
final class AppSession: ObservableObject {
    @Published var apiToken: String?
    @Published var activeGroupId: Int?

    var isLoggedIn: Bool {
        apiToken != nil && activeGroupId != nil
    }

    func clear() {
        apiToken = nil
        activeGroupId = nil
        UserDefaults.standard.removeObject(forKey: "api_token")
        UserDefaults.standard.removeObject(forKey: "group_id")
    }
    
    func createToEat(name: String, expDate: Date?) async {
        guard
            let token = apiToken,
            let groupId = activeGroupId,
            let url = URL(string: "http://localhost/api/v1/groups/\(groupId)/to-eats")
        else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "name": name,
            "exp_date": expDate?.formatted(.iso8601) as Any
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            _ = try await URLSession.shared.data(for: request)
        } catch {
            print("createToEat error:", error)
        }
    }
}
