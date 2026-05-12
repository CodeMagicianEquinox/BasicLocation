//
//  CheckIn.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import Foundation

struct CheckIn: Identifiable{
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timeStamp: Date
    
    init(id: UUID, latitude: Double, longitude: Double, timeStamp: Date) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = timeStamp
    }
}
