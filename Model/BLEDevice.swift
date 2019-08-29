//
//  Device.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEDevice {
    
//    var service: [UUID]?
//    var characteristic: [UUID]?
    var advertisementData: [String:Any]
    var rssiNumber: NSNumber
    let peripheral: CBPeripheral
    var name: String?
//    print("peripheral: \(peripheral), AdKeys: \(advertisementData.keys), AdValues: \(advertisementData.values)")
    init(_ peripheral: CBPeripheral, adData: [String:Any], rssiNumber: NSNumber) {
        self.peripheral = peripheral
        self.advertisementData = adData
        self.rssiNumber = rssiNumber
    }
    
}
