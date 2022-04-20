//
//  AccountTableViewCell.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-07.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lblInitial: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func setData(_ account: Account){
        self.name.text = account.name
        self.accountImage.image = UIImage(named: account.image!)
        self.lblBalance.text = "0.0"
        self.lblInitial.text = "Initial: \(account.initial_amount ?? 0)"
    }
}
