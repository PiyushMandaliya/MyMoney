//
//  BudgetTableViewCell.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-20.
//

import UIKit

class BudgetCell: UITableViewCell {

    static let identifier = "BudgetCell"

    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var lblRemaining: UILabel!
    @IBOutlet weak var lblSpent: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var lblSpentCus: UILabel!
    @IBOutlet weak var spentView: CustomBudgetSpentView!
    @IBOutlet weak var spentProgressView: GradientProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(category: Category){
        categoryImage.image = UIImage(named: category.image!)
        categoryName.text   = category.name
        
        if let budget = category.budget {
            lblLimit.text       = "Limit: $" + "\(budget.limit )"
            lblSpent.text       = "Spent: $\(200)"
            lblRemaining.text   = "Remaining: $\(200)"
            lblSpentCus.text    = "$\(budget.limit)"
            spentView.bgColor   = getColor(value: budget.limit)
        }
        spentProgressView.setProgress(Float.random(in: 0.0...1.0), animated: false)
    }
   

    private func getColor(value: Double) -> UIColor {
        return value > 0 ? Color.green : Color.red
    }
}
