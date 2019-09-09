//
//  TrackerViewController.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class TrackerViewController: UIViewController {
    
    let trackerView = TrackerView()
    
    override func loadView() {
        view = trackerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Heart Rate"
        addShortcutsButton()
        donateIntent()
        BLEManager.shared.deviceCharacteristicValueDelegate = self
    }
    
    func addShortcutsButton() {
        let shortcutButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
        shortcutButton.delegate = self
        
        shortcutButton.translatesAutoresizingMaskIntoConstraints = false
        trackerView.addSubview(shortcutButton)
        shortcutButton.centerXAnchor.constraint(equalTo: trackerView.centerXAnchor).isActive = true
        shortcutButton.topAnchor.constraint(equalTo: trackerView.heartbeatLabel.bottomAnchor, constant: 20).isActive = true
        shortcutButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func handleButtonTapped(sender: UIButton) {
        let trackerIntent = TrackerIntent()
        trackerIntent.suggestedInvocationPhrase = "Monitor my heart rate"
        guard let shortcut = INShortcut(intent: trackerIntent) else { return }
        let uiintent = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        uiintent.delegate = self
        uiintent.modalPresentationStyle = .formSheet
        present(uiintent, animated: true, completion: nil)
    }
    
    func donateIntent() {
        INPreferences.requestSiriAuthorization { (auth) in
            guard auth == INSiriAuthorizationStatus.authorized else { return }
            let intent = TrackerIntent()
            intent.device = "Project Zero"
            intent.suggestedInvocationPhrase = "Monitor my heart rate"
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
    }

}

extension TrackerViewController: INUIAddVoiceShortcutButtonDelegate {
    
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

extension TrackerViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            print(error.localizedDescription)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension TrackerViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            print(error.localizedDescription)
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

extension TrackerViewController: CharacteristicValueChangedDelegate {
    
    func updateTrackingLabel(_ value: String) {
        trackerView.heartbeatLabel.text = value
    }
    
}
