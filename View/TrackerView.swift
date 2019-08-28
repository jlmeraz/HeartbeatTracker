//
//  TrackerView.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit

public final class TrackerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        constraintLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func constraintLabel() {
        addSubview(heartbeatLabel)
        heartbeatLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        heartbeatLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        heartbeatLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        heartbeatLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        heartbeatLabel.layer.cornerRadius = heartbeatLabel.frame.width
    }
    
}
