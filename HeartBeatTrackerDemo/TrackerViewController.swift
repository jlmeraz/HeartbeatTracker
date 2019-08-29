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
import os.log

class TrackerViewController: UIViewController {
    
    private let activity: NSUserActivity?
    let trackerView = TrackerView()
    
    init(_ activity: NSUserActivity?) {
        self.activity = activity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = trackerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Heart Rate"
        addShortcutsButton()
        donateIntent()
    }
    
    func addShortcutsButton() {
        let shortcutButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
        shortcutButton.delegate = self
        
        shortcutButton.translatesAutoresizingMaskIntoConstraints = false
        trackerView.addSubview(shortcutButton)
        shortcutButton.centerXAnchor.constraint(equalTo: trackerView.centerXAnchor).isActive = true
        shortcutButton.topAnchor.constraint(equalTo: trackerView.heartbeatLabel.bottomAnchor).isActive = true
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
    
    func donateIntent() {
        INPreferences.requestSiriAuthorization { [weak self] (auth) in
            guard let strongSelf = self else { return }
            guard auth == INSiriAuthorizationStatus.authorized else { return }
            let intent = TrackerIntent()
            intent.device = "My device"
            intent.suggestedInvocationPhrase = "Track my heart rate"
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
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
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

