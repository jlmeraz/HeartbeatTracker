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
    
    override func loadView() {
        view = devicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Devices"
        definesPresentationContext = true
        centralManager = CBCentralManager()
        centralManager.delegate = self
        createDevices()
        setupTableView()
    }
    
    func createDevices() {
        
    }
    
    func setupTableView() {
        devicesView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        devicesView.tableView.delegate = self
        devicesView.tableView.dataSource = self
    }
    
}

extension DevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackerViewController = TrackerViewController(nil)
        navigationController?.pushViewController(trackerViewController, animated: true)
    }
    
}

extension DevicesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = devices[indexPath.row].name
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
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        case .unauthorized:
            print("Unauthorized")
        case .unsupported:
            print("Unsupported")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newDevice = BLEDevice(peripheral, adData: advertisementData, rssiNumber: RSSI)
        for i in devices {
            if i.name != newDevice.name {
                self.devices.append(newDevice)
            }
        }
        DispatchQueue.main.async {
            self.devicesView.tableView.reloadData()
        }
    }
    
}

extension DevicesViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    
}
