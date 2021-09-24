//
//  NotificationPermissonView.swift
//  Hereminders
//
//  Created by Felipe Forcinetti on 15/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationsPermissionDelegate: AnyObject {
    
    func didSelectNotificationPermission()
}

class NotificationsPermissionView: UIView, ViewProtocol {

    // MARK: - UIElements
    
    private let stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.backgroundColor = .white
        
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.imgLogo.image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        title.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        title.textAlignment = .center
        
        return title
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitle = UILabel(frame: .zero)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitle.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.556, alpha: 1)
        subtitle.textAlignment = .center
        
        return subtitle
    }()
    
    private let giveNotificationPermission: ButtonView = {
        let buttonView = ButtonView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    // MARK: - Private Properties
    
    private unowned let delegate: NotificationsPermissionDelegate?
    
    // MARK: - Inits
    
    init(_ delegate: NotificationsPermissionDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func tappedNotificationPermission() {
        delegate?.didSelectNotificationPermission()
    }
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(giveNotificationPermission)
        
        self.backgroundColor = .white
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            giveNotificationPermission.widthAnchor.constraint(equalToConstant: 343),
            giveNotificationPermission.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with viewModel: NotificationsPermissonViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        giveNotificationPermission.configure(with: viewModel.button)
        
        giveNotificationPermission.addAction(self,
                                    action: #selector(tappedNotificationPermission), for: .touchUpInside)
    }
}
