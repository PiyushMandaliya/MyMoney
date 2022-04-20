//
//  IconCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-13.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
}
