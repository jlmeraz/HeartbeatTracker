//
//  RootViewController.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/27/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit
import TrackerKit

class RootViewController: UIViewController {
    
    let rootView = RootView()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heart Rate Tracker"
        rootView.monitorButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        let devicesViewController = DevicesViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(devicesViewController, animated: true)
    }

}

