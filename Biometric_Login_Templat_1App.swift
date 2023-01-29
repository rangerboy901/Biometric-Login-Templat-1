//
//  Biometric_Login_Templat_1App.swift
//  Biometric Login Templat 1
//
//  Created by Joseph  DeWeese on 1/29/23.
//

import SwiftUI

@main
struct MySecureApp_App: App {
    @StateObject var authentication = Authentication()
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                ContentView()
                    .environmentObject(authentication)
            } else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
    }
}
