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
    @IBOutlet weak var lblFromTitle: UILabel!
    @IBOutlet weak var imgTo: UIImageView!
    @IBOutlet weak var imgFrom: UIImageView!
    
    @IBOutlet weak var toView: BorderView!
    @IBOutlet weak var fromView: BorderView!

    let datePicker = DatePickerDialog()
    private var calculator = CalculatorLogic()
    private var isFinishedTypingNumber: Bool = true
    private var transactionDate: Date = Date()

    var transactrionType = TransactionType.Expense
    var fromSelected: Any!
    var toSelected: Any!
    var accounts: [Account]? = [Account]()
    var expenseCategory: [Category]? = [Category]()
    var incomeCategory: [Category]? = [Category]()
    
    let categoryManager = CategoryManager()
    let accountManager = AccountManager()
    let transactionManager = TransactionManager()
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else { return 0.0 }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    
    private var transactionNote: String {
        get {
            guard let note = (notesTextField.text) else { return "" }
            return note
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
        dateTextField.text      = transactionDate.convertDateInDisplayFormat()
        
        let toViewGesture             = UITapGestureRecognizer(target: self, action:  #selector (categorySelectionPressed))
        self.toView.addGestureRecognizer(toViewGesture)
        
        let fromViewGesture             = UITapGestureRecognizer(target: self, action:  #selector (accountSelectionPressed))
        self.fromView.addGestureRecognizer(fromViewGesture)
    }
    
    
    override func viewDidLayoutSubviews() {
        loadAccounts()
        loadCategories()
    }
}


//MARK: -  Data Manipulation Methods
extension TransactionViewController {
    
    func loadCategories() {
        let result = categoryManager.fetch()
        incomeCategory  = result.filter({$0.type == TransactionType.Income})
        expenseCategory = result.filter({$0.type == TransactionType.Expense})
        
    }
    
    
    func loadAccounts(){
        let result = accountManager.fetch()
        if result.count > 0 {
            accounts?.removeAll()
            accounts = result
        }
    }
}


//MARK: -  Outlets Action
extension TransactionViewController {
    
    @objc func categorySelectionPressed() {
        let accountSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountSelectionViewController") as! AccountSelectionViewController

        accountSelectionVC.delegate             = self

        if transactrionType == TransactionType.Income {
            accountSelectionVC.isAccountSelection   = false
            accountSelectionVC.isToSelection        = true
            accountSelectionVC.data = incomeCategory!
        } else if transactrionType == TransactionType.Expense {
            accountSelectionVC.data = expenseCategory!
            accountSelectionVC.isAccountSelection   = false
            accountSelectionVC.isToSelection        = true
        } else {
            accountSelectionVC.data                 = accounts!
            accountSelectionVC.isToSelection        = true
            accountSelectionVC.isAccountSelection   = true
        }
        
        accountSelectionVC.sheetPresentationController.selectedDetentIdentifier = .medium
        present(accountSelectionVC, animated: true, completion: nil)
    }
    
    
    @objc func accountSelectionPressed() {
        let accountSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountSelectionViewController") as! AccountSelectionViewController
        accountSelectionVC.data                 = accounts!
        accountSelectionVC.delegate             = self
        accountSelectionVC.isAccountSelection   = true
        accountSelectionVC.isToSelection        = false
        accountSelectionVC.sheetPresentationController.selectedDetentIdentifier = .medium
        present(accountSelectionVC, animated: true, completion: nil)
    }
    
    
    @IBAction func transactionTypeChange(_ sender: UISegmentedControl) {
        toSelected = nil
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

    }
    
    
    @IBAction func editingDidEnd(_ sender: UIDatePicker) { }
        
    
    @objc private func saveTransaction() {
        
        if displayValue > 0, let fromAccount = fromSelected, let toSelected = toSelected {
            let account             = (fromAccount as! Account)
            
            let toCategory = toSelected is Category ? (toSelected as! Category) : nil
            let toAccount = toSelected is Account ? (toSelected as! Account) : nil
            
            transactionManager.create(amount: displayValue, date: transactionDate, type: transactrionType, note: transactionNote, fromAccount: account, toCategory: toCategory, toAccount: toAccount)
            
            
            goToRootViewController()
        }else {
            let alert = AlertView.showAlertBox(title: "Not done yet", message: "You haven't filled in the information we need to save this transaction for you.", firstAction: UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
                    self.transactionDate        = dt
                    self.dateTextField.text     = self.transactionDate.convertDateInDisplayFormat()
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

extension TransactionViewController: SelectionDelegate {
    func didSelectAccount(selectedAccount: Account) {
        fromSelected        = selectedAccount
        lblFromTitle.text   = selectedAccount.name
        imgFrom.image       = UIImage(named: (fromSelected as! Account).image!)
    }
    
    func didSelectCategory(selectedCategory: Any) {
        if selectedCategory is Category {
            toSelected      =   selectedCategory as! Category
            lblToTitle.text = (toSelected as! Category).name
            imgTo.image     = UIImage(named: (toSelected as! Category).image!)
        }else {
            toSelected      =   selectedCategory as! Account
            lblToTitle.text = (toSelected as! Account).name
            imgTo.image     = UIImage(named: (toSelected as! Account).image!)
        }
        
    }
}

//MARK: -  LayoutUI

extension TransactionViewController {
    
    func setTransactionLabel() {
        if transactrionType == TransactionType.Transfer {
            lblTo.text      = "To"
            lblToTitle.text = "Account"
            lblFrom.text    = "From"
            
            imgTo.image     = SFSymbol.fromAccount
        } else {
            lblTo.text      = "Category"
            lblToTitle.text = "Category"
            lblFrom.text    = "Account"
            
            imgTo.image     = SFSymbol.toCategory
        }
    }
    
    func configNavigationItems() {
        title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTransaction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goToRootViewController))
    }
}
