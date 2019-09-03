//
//  BLEDatasource.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 9/3/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit

class BLEDatasource: NSObject, UITableViewDataSource {
    
    var devices: [BLEDevice] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as UITableViewCell
        if devices[indexPath.row].peripheral.name != nil {
            cell.textLabel?.text = devices[indexPath.row].peripheral.name
        } else {
            cell.textLabel?.text = "Unknown"
        }
        cell.textLabel?.textColor = .orange
        return cell
    }
    
}
