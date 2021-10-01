//
//  UITableView+Extensions.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/24/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.classIdentifier(),
                                                  for: indexPath) as? T else {
                                                    fatalError()
        }

        return cell
    }
        
    func removeExcessCells(){ tableFooterView = UIView(frame: .zero)  }
}
