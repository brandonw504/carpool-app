//
//  ContentView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/22/22.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var state: AppState
    
    @State private var userID: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn && userID != nil {
                        HomeView(userID: $userID).environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "user=\(userID ?? "Unknown")"))
                    } else {
                        LoginView(userID: $userID)
                    }
                    Spacer()
                    if let error = state.error {
                        Text("Error: \(error)").foregroundColor(Color.red)
                    }
                }
                if state.busyCount > 0 {
                    OpaqueProgressView("Working With Realm")
                }
            }
            .onAppear {
                if state.loggedIn {
                    userID = app.currentUser?.id
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
