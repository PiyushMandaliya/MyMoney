//
//  AccountViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-04.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let accountManager = AccountManager()
    var accounts: [Account]?    = [Account]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
    }
    
    
    override func viewDidLayoutSubviews() {
        loadAccounts()
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
}


//MARK: -  Data Manipulation
extension AccountViewController{
    
    func loadAccounts()
    {
        let result = accountManager.fetch()
        if result.count > 0 {
            accounts?.removeAll()
            accounts = result
        }
    }
    
    
    func updateModel(at indexPath: IndexPath) {
        let addAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountViewController") as! AddAccountViewController
        addAccountVC.set(delegate: self, selectedAccount: accounts?[indexPath.row])
        present(addAccountVC, animated: true, completion: nil)
    }
    
    
    func deleteModel(at indexPath: IndexPath){
        accountManager.delete(account: self.accounts![indexPath.row])
        self.accounts?.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    
    func deleteConfirmation(at indexPath: IndexPath) {
        
        let alert = AlertView.showAlertBox(title: "Delete Account?", message: "This account will be permanently deleted from this app.", firstAction: UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
                self.deleteModel(at: indexPath)
            }), secondAction: UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { _ in
                    self.dismiss(animated: true)
                }))
                
        self.present(alert,
                     animated: true,
                     completion: nil
        )
    }
}

extension AccountViewController {
    
    @objc func addAccountPressed(){
        let addAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountViewController") as! AddAccountViewController
        addAccountVC.delegate = self
        self.present(addAccountVC, animated: true, completion: nil)
    }
}

extension AccountViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.identifier, for: indexPath) as! AccountCell
        if let account = accounts?[indexPath.row] {
            cell.set(account)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts?.count != nil ? accounts!.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(
        _ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil,
            handler: { [weak self] (_, _, completionHandler) in
                guard let self = self else {return}
                self.deleteConfirmation(at: indexPath)
                completionHandler(true)
            }
        )
        
        deleteAction.image = SFSymbol.deleteAction
        deleteAction.backgroundColor = Color.red
        
        let editAction = UIContextualAction(style: .normal, title: nil,
            handler: { [weak self] (_, _, completionHandler) in
                guard let self = self else {return}
                self.updateModel(at: indexPath)
                completionHandler(true)
            }
        )
                
        editAction.image = SFSymbol.editAction
        editAction.backgroundColor = Color.surface
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


extension AccountViewController: AccountDataDelegateProtocol {
    func sendDataToCategoryViewController(account: Account, isUpdate: Bool) {
        isUpdate ? loadAccounts() : accounts?.append(account)
        tableView.reloadData()
    }
}


extension AccountViewController {
    func configNavigationItems(){
        title = "Accounts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccountPressed))
    }
}
