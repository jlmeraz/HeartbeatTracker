//
//  RootView.swift
//  TrackerKit
//
//  Created by Jose Meraz on 8/27/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit

public final class RootView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        constraintMonitor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy public var monitorButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Monitor Heart Rate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func constraintMonitor() {
        addSubview(monitorButton)
        monitorButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        monitorButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        monitorButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        monitorButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
}
