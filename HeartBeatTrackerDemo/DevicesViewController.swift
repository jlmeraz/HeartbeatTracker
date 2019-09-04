//
//  DevicesViewController.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit
import CoreBluetooth

class DevicesViewController: UIViewController {
    
    let devicesView = DevicesView()
    var devices: [BLEDevice] = []
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var bleDevice: BLEModel?
    
    override func loadView() {
        view = devicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Devices"
        definesPresentationContext = true
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        
        setupTableView()
    }
    
    deinit {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral)
    }
    
    func setupTableView() {
        devicesView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        devicesView.tableView.delegate = self
        devicesView.tableView.dataSource = self
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.devicesView.tableView.reloadData()
        }
    }
    
}

extension DevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectedPeripheral = devices[indexPath.row].peripheral
        connectedPeripheral?.delegate = self
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.connect(connectedPeripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true,CBConnectPeripheralOptionNotifyOnDisconnectionKey: true
            ,CBConnectPeripheralOptionNotifyOnNotificationKey: true])
        let trackerViewController = TrackerViewController(nibName: nil, bundle: nil)
        present(trackerViewController, animated: true, completion: nil)
//        navigationController?.pushViewController(trackerViewController, animated: true)
    }
    
}

extension DevicesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as UITableViewCell
        if devices[indexPath.row].peripheral.name != nil {
            cell.textLabel?.text = devices[indexPath.row].peripheral.name
        }
        
        cell.textLabel?.textColor = .orange
        return cell
    }
    
}

extension DevicesViewController: CBCentralManagerDelegate {
    
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
        if !devices.contains(where: { (device) -> Bool in
            device.peripheral == newDevice.peripheral
        }) && newDevice.peripheral.name != nil {
            devices.append(newDevice)
            reloadTableView()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to \(String(describing: peripheral.name)) Succesful")
        connectedPeripheral?.readRSSI()
        bleDevice?.peripheral = peripheral
        connectedPeripheral?.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            bleDevice?.peripheral = nil
            print("\(String(describing: peripheral.name)) Disconnected")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("failed to connect to \(String(describing: peripheral.name))")
            print(error.localizedDescription)
        }
    }
        
}

extension DevicesViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let services = peripheral.services {
            bleDevice?.services = services
            for i in services {
                //print(i)
                peripheral.discoverCharacteristics(nil, for: i)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let characteristics = service.characteristics {
            bleDevice?.characteristics = characteristics
            for characteristic in characteristics {
                peripheral.setNotifyValue(true, for: characteristic)
                //print(characteristic.value ?? "N/A")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let value = characteristic.value {
            print("Characteristic: \(characteristic) value: \(value)")
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


