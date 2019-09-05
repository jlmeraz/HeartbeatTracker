//
//  IntentHandler.swift
//  TrackerIntent
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        guard intent is TrackerIntent else { return self }
        return TrackerIntentHandler()
    }
        
}

class TrackerIntentHandler: NSObject, TrackerIntentHandling {
    
    func handle(intent: TrackerIntent, completion: @escaping (TrackerIntentResponse) -> Void) {
        
        guard let device = intent.device else { completion(TrackerIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        completion(TrackerIntentResponse(code: .success, userActivity: NSUserActivity(activityType: device)))
        
    }
    
    func resolveDevice(for intent: TrackerIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let device = intent.device else { print("Something went terribly wrong :("); return }
        completion(INStringResolutionResult.success(with: device))
    }
    
    func provideDeviceOptions(for intent: TrackerIntent, with completion: @escaping ([String]?, Error?) -> Void) {
        let deviceName: [String] = ["Project Zero"]
        completion(deviceName, nil)
    }
    
}
