//
//  SelectionCollectionViewCell.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-29.
//

import UIKit

class SelectionCell: UICollectionViewCell {

    static let identifier = "SelectionCell"
    
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ data: Category) {
        imgAccount.image    = UIImage(named: data.image!)
        lblTitle.text       = data.name
    }

    func set(_ data: Account) {
        imgAccount.image    = UIImage(named: data.image!)
        lblTitle.text       = data.name
    }

}
