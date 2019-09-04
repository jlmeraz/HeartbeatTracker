//
//  BLEModel.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/4/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BLEModel {
    
    var rssiNumber: NSNumber?
    var peripheral: CBPeripheral?
    var services: [CBService]?
    var characteristics: [CBCharacteristic]?
    
}
