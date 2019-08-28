//
//  NSUserActivity+IntentData.swift
//  TrackerKit
//
//  Created by Jose Meraz on 8/27/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Foundation
import Intents

extension NSUserActivity {
    
    public static let viewHeartActivityType = "com.zaremesoj.HeartBeatTrackerDemo.viewMyHeartRate"
    
    public static var viewHeartActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: NSUserActivity.viewHeartActivityType)
        
        // User activites should be as rich as possible, with icons and localized strings for appropiate content attributes.
        userActivity.title = "View My Heart Rate"
        userActivity.isEligibleForPrediction = true
        userActivity.persistentIdentifier = NSUserActivityPersistentIdentifier(NSUserActivity.viewHeartActivityType)
        userActivity.suggestedInvocationPhrase = "View My Heart Rate"
        
        return userActivity
    }

}
