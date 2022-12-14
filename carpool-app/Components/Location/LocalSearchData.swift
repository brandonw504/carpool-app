//
//  LocalSearchData.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/29/22.
//

import Foundation
import MapKit
import Combine

struct LocalSearchData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var placemark: MKPlacemark
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
        self.placemark = mapItem.placemark
    }
}

final class LocalSearchViewData: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var locationText = "" {
        didSet {
            search(text: locationText)
        }
    }
    
    var currentLocation: CLLocationCoordinate2D?
    
    @Published var viewData = [LocalSearchData]()

    var service: LocalSearchService
    
    init() {
        service = LocalSearchService()
        cancellable = service.localSearchPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocalSearchData(mapItem: $0) })
        }
    }
    
    private func search(text: String) {
        service.search(searchText: text, center: currentLocation ?? CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242))
    }
}
