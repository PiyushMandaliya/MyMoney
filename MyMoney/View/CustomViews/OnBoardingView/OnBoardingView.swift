//
//  OnBoardingView.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-11.
//

import UIKit

class OnBoardingView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var onBoardImage: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    func set(for index: Int) {
        self.lblTitle.text            = Array(onBoarding.messages.keys)[index]
        self.onBoardImage.image       = UIImage(named: onBoarding.images[index])!
        self.lblDescription.text      = Array(onBoarding.messages.values)[index]
    }
}
