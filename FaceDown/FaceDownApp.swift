//
//  FaceDownApp.swift
//  FaceDown
//
//  Created by William Huang on 03/10/2025.
//

import SwiftUI
import FirebaseCore

@main
struct FaceDownApp: App {
    @StateObject private var firebaseService = FirebaseService()
    
    init() {
        // Configure Firebase on app launch
        FirebaseService.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseService)
                .task {
                    // Sign in anonymously on app start
                    do {
                        try await firebaseService.signInAnonymously()
                    } catch {
                        print("❌ Failed to sign in: \(error.localizedDescription)")
                    }
                }
        }
    }
}
