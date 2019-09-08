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
    var bleDevice: BLEModel?
    var trackerViewController: TrackerViewController!
    
    override func loadView() {
        view = devicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Devices"
        definesPresentationContext = true
        BLEManager.sharedBLEManager.startScanningForPeripherals()
    }
    
    deinit {
        BLEManager.sharedBLEManager.stopScanningForPeripherals()
        print("DevicesViewController deinitialized !")
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
////        connectedPeripheral = devices[indexPath.row].peripheral
////        connectedPeripheral?.delegate = self
//        guard let connectedPeripheral = connectedPeripheral else { return }
//        centralManager.connect(connectedPeripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true,CBConnectPeripheralOptionNotifyOnDisconnectionKey: true
//            ,CBConnectPeripheralOptionNotifyOnNotificationKey: true])
//        trackerViewController = TrackerViewController(nibName: nil, bundle: nil)
//        present(trackerViewController, animated: true) {
//            self.updateLabelDelegate = self.trackerViewController
//        }
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
