//
//  AlertView.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-22.
//

import UIKit

struct AlertView {

    public static func showAlertBox(title: String, message: String, firstAction: UIAlertAction, secondAction: UIAlertAction? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(firstAction)
        return alert
    }
    
    public static func showAlertBoxWithTextBox(title: String, message: String, buttonTitle: String , value: String? = nil, addHandler: ((_ text: String?) -> Void)? = nil, cancelHandler: ((UIAlertAction)->Void)?) -> UIAlertController {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let addAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                addHandler?(nil)
                return
            }
            addHandler?(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        })
        
        addAction.setValue(Color.surface, forKey: "titleTextColor")
        addAction.isEnabled = false
        
        let cancelAction =  UIAlertAction(title: "Cancel", style: .destructive, handler: cancelHandler)
        
        alert.addTextField { (field) in
            textField = field
            textField.keyboardType = UIKeyboardType.decimalPad
            textField.reloadInputViews()
            if value != nil {
                textField.text = value
            }else{
                textField.placeholder = "0"
            }
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0], queue: OperationQueue.main) { (notification) -> Void in
            
            if let limitTF = alert.textFields?[0] {
                
                let enable = limitTF.text!.count > 0 ? true : false
                addAction.isEnabled = enable
                if enable {
                    addAction.setValue(Color.textPrimary, forKey: "titleTextColor")
                }else{
                    addAction.setValue(Color.surface, forKey: "titleTextColor")
                }
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
