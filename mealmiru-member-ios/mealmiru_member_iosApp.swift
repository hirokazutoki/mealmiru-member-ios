//
//  mealmiru_member_iosApp.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/05.
//

import GoogleSignIn 
import SwiftUI

@main
struct mealmiru_member_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            
                .onOpenURL { url in
                  GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
