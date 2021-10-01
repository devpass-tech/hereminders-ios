//
//  RadiusTableViewCell.swift
//  Hereminders
//
//  Created by Diego Llopis on 31/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

protocol RadiusTableViewCellDelegate: AnyObject {

    func didChangeSliderValue(to value: Int)
}

class RadiusTableViewCell: UITableViewCell {
    
    weak var delegate: RadiusTableViewCellDelegate?

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var radiusSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = UIColor.heremindersBlue
        slider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        slider.minimumValue = 100
        slider.maximumValue = 500
        return slider
    }()
    
    let radiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderChanged(sender: UISlider) {
        let value = Int(sender.value)
        radiusLabel.text = String(value) + "m"
        self.delegate?.didChangeSliderValue(to: value)
    }
    
    func configure(with viewModel: RadiusTableViewCellModel, andDelegate delegate: RadiusTableViewCellDelegate) {
        radiusSlider.value = Float(viewModel.value)
        radiusLabel.text = String(viewModel.value) + "m"
        self.delegate = delegate
    }
}

extension RadiusTableViewCell: ViewProtocol {
    
    func configureSubviews() {
        self.backgroundColor = .white
        self.selectionStyle = .none

        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(radiusLabel)
        self.stackView.addArrangedSubview(radiusSlider)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
