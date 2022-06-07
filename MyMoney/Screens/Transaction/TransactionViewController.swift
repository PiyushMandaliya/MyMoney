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
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblToTitle: UILabel!
    @IBOutlet weak var imgTo: UIImageView!
    
    @IBOutlet weak var toView: BorderView!
    @IBOutlet weak var fromView: BorderView!

    let datePicker = DatePickerDialog()
    private var calculator = CalculatorLogic()
    private var isFinishedTypingNumber: Bool = true

    var transactrionType = TransactionType.Expense
    var accounts: [Account]? = [Account]()
    var expenseCategory: [Category]? = [Category]()
    var incomeCategory: [Category]? = [Category]()
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else { return 0.0 }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
        
        dateTextField.delegate  = self
        dateTextField.text      = Date().convertDateInDisplayFormat()
        
        let gesture             = UITapGestureRecognizer(target: self, action:  #selector (selectionPressed))
        self.fromView.addGestureRecognizer(gesture)
    }
    
    
    override func viewDidLayoutSubviews() {
        loadAccounts()
        loadCategories()
    }
}


//MARK: -  Data Manipulation Methods
extension TransactionViewController {
    
    func loadCategories() {
        if let Categories = CoreDataManager.shared.getCategories() {
            incomeCategory = Categories.filter({$0.type == TransactionType.Income})
            expenseCategory = Categories.filter({$0.type == TransactionType.Expense})
        }
    }
    
    
    func loadAccounts(){
        if let allAccounts = CoreDataManager.shared.getAccounts() {
            accounts?.removeAll()
            accounts = allAccounts
        }
    }
}


//MARK: -  Outlets Action
extension TransactionViewController {
    
    @objc func selectionPressed() {
        let accountSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountSelectionViewController") as! AccountSelectionViewController

        accountSelectionVC.isAccountSelection = false

        if transactrionType == TransactionType.Income {
            accountSelectionVC.data = incomeCategory!
        } else if transactrionType == TransactionType.Expense {
            accountSelectionVC.data = expenseCategory!
        } else {
            accountSelectionVC.data = accounts!
            accountSelectionVC.isAccountSelection = true
        }
        
        accountSelectionVC.sheetPresentationController.selectedDetentIdentifier = .medium
        present(accountSelectionVC, animated: true, completion: nil)
    }
    
    
    @IBAction func transactionTypeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transactrionType = TransactionType.Income
            break
        case 1:
            transactrionType = TransactionType.Expense
            break
        case 2:
            transactrionType = TransactionType.Transfer
            break
        default:
            break
        }
        setTransactionLabel()
    }
    
    
    @IBAction func selectedDateChanged(_ sender: UIDatePicker) {
        let formatter       = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        print( formatter.string(from: sender.date))
    }
    
    
    @IBAction func editingDidEnd(_ sender: UIDatePicker) { }
        
    
    @objc private func saveTransaction(){
        navigationController?.popViewController(animated: true)
    }
        
    
    @objc private func goToRootViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    
    func datePickerTapped() {
            let currentDate         = Date()
            var dateComponents      = DateComponents()
            dateComponents.month    = -3
            let threeMonthAgo       = Calendar.current.date(byAdding: dateComponents, to: currentDate)

            datePicker.show("Select Date and Time",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            minimumDate: threeMonthAgo,
                            maximumDate: currentDate,
                            datePickerMode: .dateAndTime) { (date) in
                if let dt = date {
                    self.dateTextField.text = dt.convertDateInDisplayFormat()
                }
            }
    }
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        calculator.setNumber(displayValue)
        if let calcMethod = sender.currentTitle {
            if let result = calculator.calculate(symbol: calcMethod) {
                if result.decimalPlaces > 3 {
                    displayValue = (result*1000).rounded()/1000
                } else {
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
                    if !isInt { return }
                }
                displayLabel.text = displayLabel.text! + numValue
            }
        }
    }
}


//MARK: -  TextFieldDelegate

extension TransactionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.dateTextField == textField {
            datePickerTapped()
            return false
        }
        return true
    }
}


//MARK: -  LayoutUI

extension TransactionViewController {
    
    func setTransactionLabel() {
        if transactrionType == TransactionType.Transfer {
            lblTo.text      = "To"
            lblToTitle.text = "Account"
            imgTo.image     = UIImage(systemName: "creditcard.fill")
        } else {
            lblTo.text      = "Category"
            lblToTitle.text = "Category"
            imgTo.image     = UIImage(systemName: "tag.fill")
        }
    }
    
    func configNavigationItems() {
        title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTransaction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goToRootViewController))
    }
}
