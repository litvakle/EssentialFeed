//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Lev Litvak on 16.08.2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let id = cellIdentifier(for: T.self)
        return dequeueReusableCell(withIdentifier: id) as! T
    }
    
    func registerCellForReuse<T: UITableViewCell>(for type: T.Type) {
        let id = cellIdentifier(for: T.self)
        self.register(type, forCellReuseIdentifier: id)
    }
    
    private func cellIdentifier<T: UITableViewCell>(for type: T.Type) -> String {
        return String(describing: T.self)
    }
}
