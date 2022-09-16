//
//  DirectionsView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/29/22.
//

import SwiftUI
import MapKit

struct DirectionsView: UIViewRepresentable {
    @Binding var source: CLLocationCoordinate2D
    @Binding var destination: MKPlacemark
    var stop1: MKPlacemark?
    var stop2: MKPlacemark?
//    @Binding var directions: [String]

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let region = MKCoordinateRegion(center: source, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        if let stop1 = stop1 {
            let p1 = MKPlacemark(coordinate: source)
            let p2 = stop1
            let p3 = stop2!
            let p4 = destination

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: p1)
            request.destination = MKMapItem(placemark: p2)
            request.transportType = .automobile

            let directions1 = MKDirections(request: request)
            directions1.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([p1, p2])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
    //            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            }
            
            let directions2 = MKDirections(request: request)
            directions2.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([p2, p3])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
    //            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            }
            
            let directions3 = MKDirections(request: request)
            directions3.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([p3, p4])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
    //            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            }
            
            return mapView
        } else {
            let p1 = MKPlacemark(coordinate: source)
            let p2 = destination

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: p1)
            request.destination = MKMapItem(placemark: p2)
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([p1, p2])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
    //            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            }
            return mapView
        }
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
