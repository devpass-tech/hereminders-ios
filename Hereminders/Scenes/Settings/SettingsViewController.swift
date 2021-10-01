//
//  SettingsViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/7/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit

enum SectionName: Int, CaseIterable {
    case places
    case about
    case credits
    
    func getSectionName() -> String {
        switch self {
        case .places:
            return L10n.Settings.places
        case .about:
            return L10n.Settings.about
        case .credits:
            return L10n.Settings.credits
        }
    }
}

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerWantsToBecomePremium()
    func settingsViewControllerWantsToManagePlaces()
    func settingsViewControllerWantsToClose()
    func settingsViewControllerWantsToContributors()
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    lazy var settingsView: SettingsView = {
        let screen = SettingsView()
        screen.configureDelegate(delegate: self)
        return screen
    }()
        
    init(delegate: SettingsViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func loadView() {
        self.view = settingsView
    }
    
    func configureView() {
        self.configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let barButtonItem = UIBarButtonItem.customBarButtonItem(with: Asset.iconCross.image,
                                                                for: self,
                                                                and: #selector(didTapOnCloseButton))
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.title = L10n.Settings.title
    }
    
    @objc private func didTapOnCloseButton() {
        self.delegate?.settingsViewControllerWantsToClose()
    }
}

// MARK: - Extension SettingsViewViewDelegate

extension SettingsViewController: SettingsViewControllerDelegate {
    func settingsViewControllerWantsToBecomePremium() {
        
    }
    
    func settingsViewControllerWantsToManagePlaces() {
        self.delegate?.settingsViewControllerWantsToManagePlaces()
    }
    
    func settingsViewControllerWantsToClose() {
        
    }
    
    func settingsViewControllerWantsToContributors() {
        self.delegate?.settingsViewControllerWantsToContributors()
    }
}
