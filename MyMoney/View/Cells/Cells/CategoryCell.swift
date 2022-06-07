//
//  CategoryCell.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-05.
//

import UIKit

class CategoryCell: UITableViewCell {

    static let identifier   = "CategoryCell"
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ category: Category){
        self.categoryTitle.text = category.name
        if let imageData = category.image {
            if let image = UIImage(named: imageData) {
                self.categoryImage.image = image
            }
        }
    }
}
