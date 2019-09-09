//
//  BLEManagerProtocols.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/8/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation

//Update found devices by BLEManager
protocol UpdateManagerFoundDevicesDelegate: AnyObject {
    
    func updateFoundDevices() -> [DeviceAdvertise]
    
}

//Trigger DeviceTableView update
protocol DevicesTableViewUpdateDelegate: AnyObject {
    
    func updateDeviceTableView(_ deviceAd: DeviceAdvertise)
    
}

//Update bluetooth data tracking label

protocol CharacteristicValueChangedDelegate: AnyObject {
    
    func updateTrackingLabel(_ value: String)
    
}
