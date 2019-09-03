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
    var connectedDevice: CBPeripheral?
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    
    override func loadView() {
        view = devicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Devices"
        definesPresentationContext = true
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [:])
        setupTableView()
    }
    
    deinit {
        guard let peripheral = connectedDevice else { return }
        centralManager.cancelPeripheralConnection(peripheral)
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
    
//    func getIndexForPeripheral(peripheral: CBPeripheral) -> Int {
//        for (i,c) in devices.enumerated() {
//            if c.peripheral == peripheral {
//                return i
//            }
//        }
//        return -1
//    }
    
}

extension DevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectedDevice = devices[indexPath.row].peripheral
        guard let hookedDevice = connectedDevice else { return }
        centralManager.connect(hookedDevice, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true,CBConnectPeripheralOptionNotifyOnDisconnectionKey: true
            ,CBConnectPeripheralOptionNotifyOnNotificationKey: true])
        let trackerViewController = TrackerViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(trackerViewController, animated: true)
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
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("\(String(describing: peripheral.name)) Disconnected")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("failed to connect to \(String(describing: peripheral.name))")
            print(error.localizedDescription)
        }
    }
    
//    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
//        switch event {
//        case .peerConnected:
//            print("\(String(describing: peripheral.name)) connected")
//        case .peerDisconnected:
//            print("\(String(describing: peripheral.name)) disconnected")
//        @unknown default:
//            print("Unknown event")
//        }
//    }
        
}

extension DevicesViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            print("peripheral is OFF")
        case .poweredOn:
            print("peripheral is ON")
        case .resetting:
            print("peripheral is Resetting")
        case .unauthorized:
            print("peripheral denied access")
        case .unsupported:
            print("Unsupported")
        default:
            print("Default !")
        }
        print(peripheral.state)
    }
    
    
    
}


