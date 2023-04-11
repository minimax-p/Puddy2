//
//  Puddy2App.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import SwiftUI

@main
struct Puddy2App: App {
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
