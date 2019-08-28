//
//  DevicesViewController.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import os.log

class DevicesViewController: UIViewController {
    
    let devicesView = DevicesView()
    var devices: [BLEDevice] = []
    
    override func loadView() {
        view = devicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Devices"
        definesPresentationContext = true
        createDevices()
        setupTableView()
        addShortcutsButton()
        donateIntent()
    }
    
    func createDevices() {
        let burn = BLEDevice("0x00", "0x00", "0x00", "Burn")
        let core = BLEDevice("0x01", "0x01", "0x01", "Core")
        let flex = BLEDevice("0x02", "0x02", "0x02", "Flex")
        devices.append(burn)
        devices.append(core)
        devices.append(flex)
    }
    
    func addShortcutsButton() {
        let shortcutButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
        shortcutButton.delegate = self
        
        shortcutButton.translatesAutoresizingMaskIntoConstraints = false
        devicesView.addSubview(shortcutButton)
        shortcutButton.centerXAnchor.constraint(equalTo: devicesView.centerXAnchor).isActive = true
        shortcutButton.topAnchor.constraint(equalTo: devicesView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        shortcutButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func handleButtonTapped(sender: UIButton) {
        let trackerIntent = TrackerIntent()
        trackerIntent.suggestedInvocationPhrase = "My tracker"
        guard let shortcut = INShortcut(intent: trackerIntent) else { return }
        let uiintent = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        uiintent.delegate = self
        uiintent.modalPresentationStyle = .formSheet
        present(uiintent, animated: true, completion: nil)
    }
    
    func setupTableView() {
        devicesView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        devicesView.tableView.delegate = self
        devicesView.tableView.dataSource = self
    }
    
    func donateIntent() {
        INPreferences.requestSiriAuthorization { [weak self] (auth) in
            guard let strongSelf = self else { return }
            guard auth == INSiriAuthorizationStatus.authorized else { return }
            let intent = TrackerIntent()
            intent.device = strongSelf.devices[0].name
            intent.suggestedInvocationPhrase = "Track my \(strongSelf.devices[0].name)"
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: { (error) in
                if let error = error {
                     print(error.localizedDescription)
                }
            })
        }
        
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
        return cell
    }
    
}

extension DevicesViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        print(addVoiceShortcutViewController)
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
}

extension DevicesViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension DevicesViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
