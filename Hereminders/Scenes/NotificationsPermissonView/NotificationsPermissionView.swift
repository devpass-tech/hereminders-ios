//
//  NotificationPermissonView.swift
//  Hereminders
//
//  Created by Felipe Forcinetti on 15/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
import UIKit

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
    
    private let addNewPlaceButton: ButtonView = {
        let buttonView = ButtonView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(addNewPlaceButton)
        
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
            
            addNewPlaceButton.widthAnchor.constraint(equalToConstant: 343),
            addNewPlaceButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with viewModel: NotificationsPermissonViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        addNewPlaceButton.configure(with: viewModel.button)
    }
}
