//
//  DevicesView.swift
//  HeartBeatTrackerDemo
//
//  Created by Jose Meraz on 8/28/19.
//  Copyright © 2019 Jose Meraz. All rights reserved.
//

import UIKit

public final class DevicesView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        constraintTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy public var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = .orange
        view.tableFooterView = UIView(frame: .zero)
        return view
    }()
    
    func constraintTableView() {
        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
}
