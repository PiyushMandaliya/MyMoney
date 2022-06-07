//
//  GradientProgressView.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-20.
//

import UIKit


class GradientProgressView: UIProgressView {
    
    @IBInspectable var firstColor: UIColor = Color.systemWhite {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = Color.systemBlack {
        didSet {
            updateView()
        }
    }
    
    override var progress: Float {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if self.progress >= 0.65 {
            if let gradientImage = UIImage(bounds: self.bounds, colors: [firstColor, secondColor], value: CGFloat(self.progress)) {
                self.progressImage = gradientImage
            }
        }else{
            self.progressTintColor = Color.green
        }
    }
}
