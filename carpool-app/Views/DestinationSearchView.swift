//
//  DestinationSearchView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/26/22.
//

import SwiftUI
import RealmSwift
import MapKit
import PusherSwift

struct DestinationSearchView: View {
    let realm = try! Realm()
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var state: AppState
    @ObservedRealmObject var user: User
    
    @StateObject private var localSearchViewData = LocalSearchViewData()
    @StateObject var locationManager = LocationManager()
    
    @Binding var destination: MKPlacemark?
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var showingSearchResults = false
    @State private var destinationChosen = false
    @FocusState private var locationIsFocused: Bool
    @State private var type: Types = .driver
    
    enum Types: String, CaseIterable, Identifiable {
        case driver, rider
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            Picker("Type", selection: $type) {
                Text("I'm Driving").tag(Types.driver)
                Text("I'm Riding").tag(Types.rider)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("Where are you headed?", text: $localSearchViewData.locationText).focused($locationIsFocused).onTapGesture {
                destination = nil
                destinationChosen = false
                showingSearchResults = true
                locationManager.requestLocation()
                if let loc = locationManager.location {
                    localSearchViewData.currentLocation = loc
                }
            }
            .padding()
            
            if (showingSearchResults) {
                List(localSearchViewData.viewData) { place in
                    VStack(alignment: .leading) {
                        Text(place.title)
                        Text(place.subtitle).foregroundColor(.secondary)
                    }.onTapGesture {
                        destination = place.placemark
                        self.title = place.title
                        self.subtitle = place.subtitle
                        destinationChosen = true
                        showingSearchResults = false
                        locationIsFocused = false
                    }
                }
                Spacer()
            } else {
                Spacer()
            }
            
            if (destinationChosen) {
                VStack(alignment: .leading) {
                    Text("Chosen Destination:").font(.headline)
                    Text(title)
                    Text(subtitle).foregroundColor(.secondary)
                }
                Spacer()
                Button(type == .driver ? "Search for riders" : "Search for drivers") {
                    if let source = locationManager.location {
                        if let destination = destination {
                            switch (type) {
                            case .driver:
                                let newActiveDriver = ActiveDriver()
                                newActiveDriver.name = user.name
                                newActiveDriver.picture = user.picture
                                newActiveDriver.car = user.car
                                try! realm.write {
                                    realm.add(newActiveDriver)
                                }
                                Task {
                                    await state.searchForRiders(activeDriver: newActiveDriver, destination: destination)
                                }
                            case .rider:
                                let newActiveRider = ActiveRider()
                                newActiveRider.name = user.name
                                newActiveRider.picture = user.picture
                                newActiveRider.source!.latitude = source.latitude
                                newActiveRider.source!.longitude = source.longitude
                                newActiveRider.destination!.latitude = destination.coordinate.latitude
                                newActiveRider.destination!.longitude = destination.coordinate.longitude
                                try! realm.write {
                                    realm.add(newActiveRider)
                                }
                            }
                        } else {
                            state.error = "Destination location does not exist."
                        }
                    } else {
                        state.error = "Source location does not exist."
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    destination = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
