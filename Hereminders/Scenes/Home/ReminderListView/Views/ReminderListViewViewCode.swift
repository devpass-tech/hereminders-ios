//
//  ReminderListViewViewCode.swift
//  Hereminders
//
//  Created by Dairan on 25/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

// MARK: - Layout

import UIKit

// MARK: - ReminderListViewViewCode

class ReminderListViewViewCode: UIView {
  // MARK: Lifecycle

  init() {
    super.init(frame: .zero)

    backgroundColor = .white
    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // TODO: Criar viewModel da classe englobando os VMs abaixo

  // MARK: Private

  private let stackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    return stackView
  }()

  private var titleSubtitleView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var titleSubtitle: TitleSubtitleView = {
    let label = TitleSubtitleView()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private var dividerView: DividerView = {
    let divider = DividerView()
    return divider
  }()

  private lazy var reminderTableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.classIdentifier())
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    tableView.separatorInsetReference = .fromAutomaticInsets
    tableView.separatorInset = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
    return tableView
  }()

    private lazy var buttonViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

  private lazy var buttonView: ButtonView = {
    let button = ButtonView()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var viewModel: ReminderListViewViewCodeViewModel?

  private func configureSubviews() {
    translatesAutoresizingMaskIntoConstraints = false
    titleSubtitleView.addSubview(titleSubtitle)

    buttonViewContainer.addSubview(buttonView)

    addSubview(stackView)
    stackView.addArrangedSubview(titleSubtitleView)
    stackView.addArrangedSubview(dividerView)
    stackView.addArrangedSubview(reminderTableView)
    stackView.addArrangedSubview(buttonViewContainer)
  }

  private func configureConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

      titleSubtitle.topAnchor.constraint(equalTo: titleSubtitleView.topAnchor, constant: 16),
      titleSubtitle.leadingAnchor.constraint(equalTo: titleSubtitleView.leadingAnchor, constant: 16),
      titleSubtitle.trailingAnchor.constraint(equalTo: titleSubtitleView.trailingAnchor, constant: -16),
      titleSubtitle.bottomAnchor.constraint(equalTo: titleSubtitleView.bottomAnchor, constant: -16),

        buttonView.topAnchor.constraint(equalTo: buttonViewContainer.topAnchor, constant: 16),
        buttonView.leadingAnchor.constraint(equalTo: buttonViewContainer.leadingAnchor, constant: 16),
        buttonView.trailingAnchor.constraint(equalTo: buttonViewContainer.trailingAnchor, constant: -16),
        buttonView.bottomAnchor.constraint(equalTo: buttonViewContainer.bottomAnchor, constant: -16),

      reminderTableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      reminderTableView.heightAnchor.constraint(equalToConstant: 200),

        dividerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
        dividerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
    ])
  }

    func configure(with viewModel: ReminderListViewViewCodeViewModel) {

        self.viewModel = viewModel

        titleSubtitle.configure(with: viewModel.titleSubtitleViewModel)
        buttonView.configure(with: viewModel.buttonViewModel)

        reminderTableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension ReminderListViewViewCode: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel?.remindersViewModel.count ?? 0
  }
}

// MARK: UITableViewDataSource

extension ReminderListViewViewCode: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let viewModel = self.viewModel else {
        return UITableViewCell()
    }

    let reminder = viewModel.remindersViewModel[indexPath.row]
    var cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")

    if cell == nil {
        cell = UITableViewCell(style: .value1, reuseIdentifier: "ReminderCell")
    }

    cell?.textLabel?.text = reminder.description
    cell?.detailTextLabel?.text = reminder.event == 0 ? L10n.ReminderList.onEntry : L10n.ReminderList.onExit
    return cell!
  }
}
