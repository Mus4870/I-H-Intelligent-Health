//
//  I_H_finalApp.swift
//  I-H final
//
//  Created by mustafa farah on 16/05/2023.
//

import SwiftUI
import Firebase

@main
struct MyApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
