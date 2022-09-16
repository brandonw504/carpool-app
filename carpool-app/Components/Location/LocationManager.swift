//
//  LocationManager.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/24/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            errorMessage = "Location tracking is restricted, likely due to parental controls."
        case .denied:
            errorMessage = "Location tracking was denied, please enable it in settings."
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.manager.requestLocation()
            }
        @unknown default:
            errorMessage = "Unknown location authorization status."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
