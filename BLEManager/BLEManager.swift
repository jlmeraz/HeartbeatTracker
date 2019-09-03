//
//  BLEManager.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/3/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject {
    
    private var centralManager: CBCentralManager!
    var bleData = BLEDatasource()

    required override init() {
       super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    }
    
}

extension BLEManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Off")
        case .poweredOn:
            print("On")
            central.scanForPeripherals(withServices: nil, options: [:])
        case .resetting:
            print("Resetting")
        case .unauthorized:
            print("Unauthorized")
        case .unsupported:
            print("Unsupported")
        case .unknown:
            print("Unknown")
        @unknown default:
            print("Unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newDevice = BLEDevice(peripheral, adData: advertisementData, rssiNumber: RSSI)
        if !bleData.devices.contains(where: { (device) -> Bool in
            device.peripheral == newDevice.peripheral
        }) {
            bleData.devices.append(newDevice)
        }
    }
    
}

extension BLEManager: CBPeripheralDelegate {
    
}
