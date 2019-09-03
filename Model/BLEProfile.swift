//
//  BLEServices.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/3/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BLEProfile {
    
    let services: [CBService]
    let characteristics: [CBCharacteristic]
    var rssi: NSNumber
    
    init(services: [CBService], characteristics: [CBCharacteristic], rssi: NSNumber) {
        self.services = services
        self.characteristics = characteristics
        self.rssi = rssi
    }
    
}


