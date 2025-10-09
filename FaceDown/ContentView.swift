//
//  ContentView.swift
//  FaceDown
//
//  Created by William Huang on 03/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "iphone.radiowaves.left.and.right")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 60)
                
                Text("FaceDown")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                
                Text("Stay focused. Phone down.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Quick start buttons
                VStack(spacing: 16) {
                    NavigationLink(destination: FocusView(sessionMinutes: 25)) {
                        SessionButton(title: "25 min Focus", icon: "timer")
                    }
                    
                    NavigationLink(destination: FocusView(sessionMinutes: 50)) {
                        SessionButton(title: "50 min Deep Work", icon: "brain.head.profile")
                    }
                    
                    NavigationLink(destination: FocusView(sessionMinutes: 5)) {
                        SessionButton(title: "5 min Quick Test", icon: "bolt.fill")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct SessionButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseService())
}
