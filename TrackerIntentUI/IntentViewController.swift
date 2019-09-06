//
//  IntentViewController.swift
//  TrackerIntentUI
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import IntentsUI
import CoreBluetooth
// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    lazy public var heartbeatLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.textColor = .orange
        label.text = "00"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.layer.borderWidth = 10.0
        label.layer.borderColor = CGColor(srgbRed: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        label.minimumScaleFactor = 10.0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        constraintLabel()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        //centralManager.scanForPeripherals(withServices: nil, options: nil)
//        guard let connectedPeripheral = connectedPeripheral else { return }
//        centralManager.connect(connectedPeripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true,CBConnectPeripheralOptionNotifyOnDisconnectionKey: true
//            ,CBConnectPeripheralOptionNotifyOnNotificationKey: true])
    }
        
    deinit {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral)
    }
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
    func constraintLabel() {
        view.addSubview(heartbeatLabel)
        heartbeatLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        heartbeatLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        heartbeatLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        heartbeatLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        heartbeatLabel.layer.cornerRadius = heartbeatLabel.frame.width
    }
    
}

extension IntentViewController: CBCentralManagerDelegate {
    
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
//        print(peripheral.name ?? "n/a")
//        DispatchQueue.main.async {
//            self.heartbeatLabel.text = RSSI.stringValue
//        }
        let peripheralName = peripheral.name
        guard peripheralName == "ID115Plus HR" else { return }
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager.connect(connectedPeripheral!, options: [:])
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to \(String(describing: peripheral.name)) Succesful")
        connectedPeripheral?.readRSSI()
        print("Connected to Project Zero")
//        centralManager.stopScan()
        connectedPeripheral?.discoverServices(nil)
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
        
}

extension IntentViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let services = peripheral.services {
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
            let heartRate = String(someNumber)
            DispatchQueue.main.async {
                self.heartbeatLabel.text = heartRate
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
