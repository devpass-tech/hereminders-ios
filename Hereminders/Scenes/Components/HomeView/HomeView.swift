//
//  HomeContentView.swift
//  Hereminders
//
//  Created by joao camargo on 22/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIView {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect.zero)
        return mapView
    }()
    
    lazy var reminderListView: ReminderListView = {
        let reminderView = ReminderListView(frame: CGRect.zero)
        return reminderView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private weak var delegate: HomeViewControllerDelegate?
    
    // MARK: - Initialize
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureDelegate(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
    }
}

extension HomeView: ViewProtocol {
    func configureConstraints() {
        stackView.addConstraintsToFillView(self)
    }
        
    func configureSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(reminderListView)
    }
}
