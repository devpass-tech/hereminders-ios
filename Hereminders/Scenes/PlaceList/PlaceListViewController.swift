//
//  PlaceListViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/7/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import RxSwift

protocol PlaceListViewControllerDelegate: AnyObject {

    func placeListViewControllerDidSelectPlace(_ place: Place)
    func placeListViewControllerWantsToSearchPlace()
    func placeListViewControllerDidCancel()
}

class PlaceListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    weak var delegate: PlaceListViewControllerDelegate?

    let viewModel: PlaceListViewModel

    init(viewModel: PlaceListViewModel, delegate: PlaceListViewControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: "PlaceListViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
        self.configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.reloadPlaces()
    }

    func bindViewModel() {

        self.viewModel.placesSubject
            .subscribe(onNext: { [weak self] in

                self?.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }

    func configureView() {

        configureNavigationBar()
        configureTableView()
    }

    func configureNavigationBar() {

        let addPlaceButton = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(didTapAddPlaceButton))
        self.navigationItem.rightBarButtonItem = addPlaceButton

        self.navigationItem.title = L10n.PlaceList.title
    }

    func configureTableView() {

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @objc func didTapOnCloseButton() {

        self.delegate?.placeListViewControllerDidCancel()
    }

    @objc func didTapAddPlaceButton() {

        self.delegate?.placeListViewControllerWantsToSearchPlace()
    }
}

extension PlaceListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.placeCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell")

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PlaceCell")
        }

        let place = self.viewModel.place(at: indexPath.row)

        cell?.textLabel?.text = place.name
        cell?.detailTextLabel?.text = place.address

        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            self.viewModel.removePlace(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension PlaceListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let place = self.viewModel.place(at: indexPath.row)
        self.delegate?.placeListViewControllerDidSelectPlace(place)
    }
}
