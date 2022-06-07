//
//  TableviewSection.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-05.
//

import UIKit

class TableviewSection: UIView {

    @IBOutlet weak var sectionTitle: UILabel!

    func setTitle(title: String) {
        sectionTitle.text   = title
    }
}
