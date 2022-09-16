//
//  MKCoordinateRegion.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/25/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    func getBinding() -> Binding<CLLocationCoordinate2D>? {
        return Binding<CLLocationCoordinate2D>(.constant(self))
    }
}

extension MKCoordinateRegion {
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}
