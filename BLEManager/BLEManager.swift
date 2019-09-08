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
    
    public static let sharedBLEManager = BLEManager()
        
    private var centralManager: CBCentralManager!
    private var connectedDevice: CBPeripheral!
    
    private override init() {
        super.init()

        let bleQueue = DispatchQueue(label: "bleQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global(qos: .userInteractive))
        centralManager = CBCentralManager(delegate: self, queue: bleQueue, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func startScanningForPeripherals() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func stopScanningForPeripherals() {
        centralManager.stopScan()
    }
    
}

extension BLEManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Off")
            //set peripheral connection and object/or singleton to nil
        case .poweredOn:
            print("On")
            //scan for specific services as best practice
            startScanningForPeripherals()
        case .resetting:
            print("Resetting")
            //reconnect to peripheral??
        case .unauthorized:
            print("Unauthorized")
            //display message to user to request bluetooth authorization
        case .unsupported:
            print("Unsupported")
        case .unknown:
            print("Unknown")
        @unknown default:
            print("Unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            print(peripheral.name!)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to \(String(describing: peripheral.name)) Succesful")
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let deviceName = peripheral.name {
            print("\(deviceName) disconnected...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("failed to connect to \(String(describing: peripheral.name))")
            print(error.localizedDescription)
        }
    }
    
}

extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let services = peripheral.services {
            for i in services {
                peripheral.discoverCharacteristics(nil, for: i)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let characteristics = service.characteristics {
            for characteristic in characteristics {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let dataValue = characteristic.value {
            let byteArray = Array(dataValue)
            var someNumber: Int = 0
            for byte in byteArray {
                someNumber += Int(byte)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print(RSSI)
        }
    }
    
}
