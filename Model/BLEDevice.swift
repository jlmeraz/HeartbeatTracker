//
//  Device.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation

struct BLEDevice {
    
    let service: String
    let characteristic: String
    let peripheral: String
    let name: String
    
    init(_ service: String,_ characteristic: String,_ peripheral: String,_ name: String ) {
        self.service = service
        self.characteristic = characteristic
        self.peripheral = peripheral
        self.name = name
    }
    
}
