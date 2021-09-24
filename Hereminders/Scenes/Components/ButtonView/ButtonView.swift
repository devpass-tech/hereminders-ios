//
//  ButtonView.swift
//  Hereminders
//
//  Created by sara.batista.d.felix on 19/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

final class ButtonView: UIView {
    
    // MARK: - Propriedades
    
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.heremindersBlue
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero)
		
		  configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
		
		  configureView()
    }
    
    // MARK: - ViewCode
    
    func configure(with viewModel: ButtonViewModel) {
        self.button.setTitle(viewModel.titleButton, for: UIControl.State.normal)
    }
    
    func addAction(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.button.addTarget(target, action: action, for: controlEvents)
    }
}

// MARK: - Extension ViewProtocol

extension ButtonView: ViewProtocol {
	
	func configureSubviews() {
		self.backgroundColor = .white
		self.addSubview(self.button)
	}
	
	func configureConstraints() {
		NSLayoutConstraint.activate([
			self.button.topAnchor.constraint(equalTo: topAnchor),
			self.button.bottomAnchor.constraint(equalTo: bottomAnchor),
			self.button.leadingAnchor.constraint(equalTo: leadingAnchor),
			self.button.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
