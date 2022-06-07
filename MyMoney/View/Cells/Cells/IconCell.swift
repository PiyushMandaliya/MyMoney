//
//  IconCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-13.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    static let identifier = "IconCell"
    
    @IBOutlet weak var icon: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Color.lightGray : Color.clear
        }
    }
}
