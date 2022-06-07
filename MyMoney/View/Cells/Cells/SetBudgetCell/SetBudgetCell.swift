//
//  SetBudgetTableViewCell.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-20.
//

import UIKit

class SetBudgetCell: UITableViewCell {

    static let identifier = "SetBudgetCell"
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    var onTapAction: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func setBudgetPressed(_ sender: UIButton) {
        onTapAction()
    }
    
    func set(category: Category, onTap: @escaping (() -> Void)){
        categoryName.text   = category.name
        categoryImage.image = UIImage(named: category.image!)
        onTapAction         = onTap
    }
}
