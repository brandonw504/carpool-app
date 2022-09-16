//
//  Model.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/23/22.
//

import Foundation
import RealmSwift
import MapKit

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var partition = ""
    @Persisted var name: String?
    @Persisted var picture: Data?
    @Persisted var email: String?
    @Persisted var car: Car?
    @Persisted var trip: Trip?
}

class ActiveDriver: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var partition = "all-users=all-the-users"
    @Persisted var name: String?
    @Persisted var picture: Data?
    @Persisted var car: Car?
}

class ActiveRider: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var partition = "all-users=all-the-users"
    @Persisted var name: String?
    @Persisted var picture: Data?
    @Persisted var source: Location?
    @Persisted var destination: Location?
}

class Trip: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id = UUID().uuidString
    @Persisted var source: Location?
    @Persisted var destination: Location?
//    @Persisted var driver: User?
//    @Persisted var riders = List<User>()
}

class Car: EmbeddedObject {
    @Persisted var color: String?
    @Persisted var modelYear: Int?
    @Persisted var manufacturer: String?
    @Persisted var modelName: String?
    @Persisted var licensePlate: String?
}

class Location: EmbeddedObject {
    @Persisted var latitude = 0.0
    @Persisted var longitude = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
