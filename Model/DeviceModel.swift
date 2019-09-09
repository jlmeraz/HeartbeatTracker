//
//  DeviceModel.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/8/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation

class DeviceAdvertise {
    
    var name: String?
    var rssi: Int?
    
    init(name: String, rssi: Int) {
        self.name = name
        self.rssi = rssi
    }
    
}

struct Device {
    
    let peripheralName: String
    let peripheralUUID: UUID
    let peripheralServices: [Services]
    
}

struct Services {
    
    let serviceName: String
    let serviceDescriptor: String?
    let services: [Characteristics]
    
}

struct Characteristics {
    
    let characteristicName: [String]
    let characteristicDescriptor: [String]?
    let characteristics: [String]
    
}
