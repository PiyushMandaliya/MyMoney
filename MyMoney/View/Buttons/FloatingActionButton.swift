//
//  FloatingActionButton.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-05-31.
//

import UIKit

class FloatingActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor  = .systemCyan
        tintColor = Color.white
        setTitleColor(Color.white, for: .normal)
        
        
        
//        layer.shadowRadius = 10
//        layer.shadowOpacity = 0.2
        layer.cornerRadius = 30

        setImage(SFSymbol.floatingPlus, for: .normal)
    }
}
