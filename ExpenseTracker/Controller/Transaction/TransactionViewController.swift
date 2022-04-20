//
//  TransactionViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-04.
//

import UIKit

class TransactionViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var transactionTypeSegment: UISegmentedControl!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var displayLabel: UILabel!
    private var isFinishedTypingNumber: Bool = true
    @IBOutlet weak var dateTextField: UITextField!
    
    //Properties
    let datePicker = DatePickerDialog()
    private var calculator = CalculatorLogic()

    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    
    
    //Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
        title = ""
        dateTextField.delegate = self
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)

        dateTextField.text = timestamp
    }
    
    func configNavigationItems(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTransaction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goToRootViewController))
    }
}


//MARK: -  Outlets Action

extension TransactionViewController{
    @IBAction func selectedDateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
            formatter.dateStyle = .medium
        formatter.timeStyle = .medium
            print( formatter.string(from: sender.date))
        
    }
    @IBAction func editingDidEnd(_ sender: UIDatePicker) {
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
        
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        calculator.setNumber(displayValue)
        if let calcMethod = sender.currentTitle {
            if let result = calculator.calculate(symbol: calcMethod) {
                if result.decimalPlaces > 3{
                    displayValue = (result*1000).rounded()/1000
                }else{
                    displayValue = result

                }
            }
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = numValue
                isFinishedTypingNumber = false
            } else {
                if numValue == "." {
                    let isInt = floor(displayValue) == displayValue
                    if !isInt {
                        return
                    }
                }
                displayLabel.text = displayLabel.text! + numValue
            }
        }
    }
    
    @objc private func saveTransaction(){
        navigationController?.popViewController(animated: true)
    }
        
    @objc private func goToRootViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    func datePickerTapped() {
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.month = -3
            let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)

            datePicker.show("Select Date and Time",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            minimumDate: threeMonthAgo,
                            maximumDate: currentDate,
                            datePickerMode: .dateAndTime) { (date) in
                if let dt = date {
                    let timestamp = DateFormatter.localizedString(from: dt as Date, dateStyle: .medium, timeStyle: .short)

                    self.dateTextField.text = timestamp
                }
            }
        }
}


//MARK: -  TextField Delegate

extension TransactionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.dateTextField == textField {
            datePickerTapped()
            return false
        }
        
        return true
    }
}
