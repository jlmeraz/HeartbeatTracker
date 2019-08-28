//
//  TrackerViewController.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit
import IntentsUI

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
    }

}
