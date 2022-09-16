//
//  carpool_appApp.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/22/22.
//

import SwiftUI
import RealmSwift
import PusherSwift

// TODO: Set app keys
let app = RealmSwift.App(id: "carpool-app-xxxxx")
let pusher = PusherSwift.Pusher(key: "YOUR_APP_KEY")

@main
struct carpool_appApp: SwiftUI.App {
    @StateObject var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(state)
        }
    }
}
