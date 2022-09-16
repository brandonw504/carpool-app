//
//  AppState.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/23/22.
//

import RealmSwift
import SwiftUI
import Combine
import CoreLocation
import MapKit

class AppState: ObservableObject {
    let realm = try! Realm()
    
    @Published var error: String?
    @Published var busyCount = 0
    @Published var foundRider: ActiveRider?
    
    @StateObject var locationManager = LocationManager()

    var shouldIndicateActivity: Bool {
        get {
            return busyCount > 0
        }
        set (newState) {
            if newState {
                busyCount += 1
            } else {
                if busyCount > 0 {
                    busyCount -= 1
                } else {
                    print("Attempted to decrement busyCount below 1")
                }
            }
        }
    }

    var loggedIn: Bool {
        app.currentUser != nil && app.currentUser?.state == .loggedIn
    }
    
    init() {
        app.currentUser?.logOut { _ in
        }
    }
    
    func searchForRiders(activeDriver: ActiveDriver, destination: MKPlacemark) async {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.locationManager.requestLocation()
            if let location = self.locationManager.location {
                let activeRiders = self.realm.objects(ActiveRider.self)
                for rider in activeRiders {
                    let directTime = self.calculateTravelTime(source: MKMapItem(placemark: MKPlacemark(coordinate: location)), destination: MKMapItem(placemark: destination))
                    
                    var detourTime = 0.0
                    detourTime += self.calculateTravelTime(source: MKMapItem(placemark: MKPlacemark(coordinate: location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: rider.source!.coordinate)))
                    detourTime += self.calculateTravelTime(source: MKMapItem(placemark: MKPlacemark(coordinate: rider.source!.coordinate)), destination: MKMapItem(placemark: MKPlacemark(coordinate: rider.destination!.coordinate)))
                    detourTime += self.calculateTravelTime(source: MKMapItem(placemark: MKPlacemark(coordinate: rider.destination!.coordinate)), destination: MKMapItem(placemark: destination))
                    
                    let detour = detourTime - directTime
                    if detour < 0 {
                        print("Error: detour time is less than 0.")
                    } else if detour > 600 {
                        print("Detour is too long.")
                    } else {
                        print("Found rider!")
                        self.foundRider = rider
                        timer.invalidate()
                        break
                    }
                }
            }
        }
    }
    
    func calculateTravelTime (source: MKMapItem, destination: MKMapItem) -> Double {
        var travelTime = 0.0
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculateETA { (response, error) in
            if let response = response {
                travelTime = response.expectedTravelTime
            } else {
                if let error = error {
                    print("Error requesting ETA: \(error.localizedDescription)")
                }
            }
        }
        
        return travelTime
    }
}
