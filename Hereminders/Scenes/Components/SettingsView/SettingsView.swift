//
//  SettingsView.swift
//  Hereminders
//
//  Created by joao camargo on 21/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()
      
    private weak var delegate: SettingsViewControllerDelegate?
    let tbViewCellIdentifier = "SettingsCell"
    
    // MARK: - Initialize
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureDelegate(delegate: SettingsViewControllerDelegate) {
        self.delegate = delegate
    }
}

extension SettingsView: ViewProtocol {
    func configureConstraints() {
        tableView.addConstraintsToFillView(self)
    }
        
    func configureSubviews() {
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tbViewCellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
}

extension SettingsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionName.allCases.count
    }
        
    func newHeaderViewLabel(section: Int) -> UILabel {
        let text = SectionName(rawValue: section)?.getSectionName().uppercased() ?? ""
        let sectionText = UILabel()
        sectionText.textAlignment = .left
        sectionText.textColor = UIColor.gray
        sectionText.font = UIFont.systemFont(ofSize: 13)
        sectionText.numberOfLines = 1
        sectionText.text = text
        return sectionText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionName.credits.rawValue {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: tbViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: tbViewCellIdentifier)
        }
        
        guard let sectionIndex: SectionName = SectionName(rawValue: indexPath.section)
        else { return UITableViewCell() }
        
        switch sectionIndex {
        case .places:
            cell?.textLabel?.text = L10n.Settings.managePlaces
            cell?.accessoryType = .disclosureIndicator
            
        case .about:
            cell?.textLabel?.text = L10n.Settings.version(Bundle.versionNumber, Bundle.buildNumber)
            cell?.isUserInteractionEnabled = false
            
        case .credits:
            if indexPath.row == 0 {
                cell?.textLabel?.text = L10n.Settings.logoCredit
                cell?.isUserInteractionEnabled = false
            } else {
                cell?.textLabel?.text = L10n.Settings.contributors
                cell?.accessoryType = .disclosureIndicator
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionIndex: SectionName = SectionName(rawValue: section)
        else { return nil }
        return sectionIndex.getSectionName()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width,height: 0))
        headerView.backgroundColor = .systemGroupedBackground
        let sectionTitle = newHeaderViewLabel(section: section)
        headerView.addSubview(sectionTitle)
        sectionTitle.addConstraintsToFillView(headerView,paddingTop: 14.9,paddingLeft: 20,paddingBottom: 7.4)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
        headerView.backgroundColor = .systemGroupedBackground
        return headerView
    }
}

extension SettingsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == SectionName.places.rawValue {
            self.delegate?.settingsViewControllerWantsToManagePlaces()
        } else if indexPath.section == SectionName.credits.rawValue {
            if indexPath.row == 1 {
                self.delegate?.settingsViewControllerWantsToContributors()
            }
        }
    }
}
