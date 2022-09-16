//
//  HomeView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/24/22.
//

import SwiftUI
import RealmSwift
import MapKit
import CoreLocation

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var state: AppState
    @ObservedResults(User.self) var users
    @StateObject var locationManager = LocationManager()
    
    @Binding var userID: String?
    
    @State private var showMenu = false
    
    var region: Binding<MKCoordinateRegion>? {
        if let error = locationManager.errorMessage {
            DispatchQueue.main.async {
                state.error = error
            }
        }
        
        guard let location = locationManager.location else {
            return nil
        }
        
        return MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000).getBinding()
    }
    
    @State private var showingSearch = false

    var source: Binding<CLLocationCoordinate2D>? {
        if let error = locationManager.errorMessage {
            DispatchQueue.main.async {
                state.error = error
            }
        }
        
        return locationManager.location?.getBinding()
    }
    
    @State var destination: MKPlacemark?
    
    var body: some View {
        let drag = DragGesture().onEnded {
            if $0.translation.width < -100 {
                withAnimation {
                    showMenu = false
                }
            }
        }
        
        if let user = users.first {
            if destination == nil {
                if locationManager.errorMessage == nil {
                    GeometryReader { geometry in
                        ZStack (alignment: .leading) {
                            ZStack {
                                if let region = region {
                                    MapKit.Map(coordinateRegion: region, interactionModes: .all, showsUserLocation: true)
                                    .edgesIgnoringSafeArea(.all)
                                } else {
                                    OpaqueProgressView("Loading Map")
                                }
                                VStack {
                                    HStack {
                                        Image(systemName: showMenu ? "chevron.left" : "line.3.horizontal")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .background(Circle().fill(.gray).frame(width: 40, height: 40).opacity(0.5))
                                            .padding()
                                            .onTapGesture {
                                                withAnimation {
                                                    showMenu.toggle()
                                                }
                                            }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 20))
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                            .background(Circle().fill(.gray).frame(width: 40, height: 40).opacity(0.5))
                                            .padding()
                                            .onTapGesture {
                                                showingSearch = true
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: showMenu ? geometry.size.width/2 : 0)
                            if showMenu {
                                MenuView()
                                    .frame(width: geometry.size.width/2)
                                    .transition(.move(edge: .leading))
                            }
                        }
                        .gesture(drag)
                        .edgesIgnoringSafeArea(.bottom)
                        .sheet(isPresented: $showingSearch) {
                            DestinationSearchView(user: user, destination: $destination)
                        }
                    }
                }
            } else {
                ZStack {
                    if let source = source {
                        if let foundRider = state.foundRider {
                            DirectionsView(source: source, destination: Binding($destination)!, stop1: MKPlacemark(coordinate: foundRider.source!.coordinate), stop2: MKPlacemark(coordinate: foundRider.destination!.coordinate))
                        } else {
                            DirectionsView(source: source, destination: Binding($destination)!)
                        }
                    } else {
                        OpaqueProgressView("Loading Directions")
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: HomeView(userID: $userID)) {
                            Text("End Navigation")
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userID: .constant("1234554321")).environmentObject(AppState())
    }
}
