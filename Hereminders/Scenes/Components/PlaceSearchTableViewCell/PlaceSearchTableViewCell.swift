//
//  PlaceSearchTableViewCell.swift
//  Hereminders
//
//  Created by joao camargo on 14/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

class PlaceSearchTableViewCell : UITableViewCell {
    
    private lazy var titleSubtitleView: TitleSubtitleView = {
        let view = TitleSubtitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dividerView: DividerView = {
        let dividerView = DividerView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .red
        return dividerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PlaceSearchTableViewCellViewModel) {
        titleSubtitleView.configure(with: viewModel.titleSubtitleViewVM)
    }
}

extension PlaceSearchTableViewCell: ViewProtocol {
    func configureSubviews() {
        self.contentView.addSubview(self.titleSubtitleView)
        self.contentView.addSubview(self.dividerView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.titleSubtitleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleSubtitleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.titleSubtitleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleSubtitleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.dividerView.topAnchor.constraint(equalTo: self.titleSubtitleView.bottomAnchor),
            self.dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
