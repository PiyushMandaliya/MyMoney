//
//  AccountViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-04.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {

    var accounts: [Account]? = [Account]()
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
    }
    
    override func viewDidLayoutSubviews() {
        loadAccounts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configNavigationItems(){
        title = "Accounts"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccountPressed))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
}


//MARK: -  Data Manipulation
extension AccountViewController{
    func loadAccounts(request : NSFetchRequest<Account> = Account.fetchRequest()){
        do{
            accounts?.removeAll()
            accounts = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func updateModel(at indexPath: IndexPath){
        let addAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountViewController") as! AddAccountViewController
        addAccountVC.delegate = self
        addAccountVC.isUpdate = true
        addAccountVC.selectedAccount =
        accounts?[indexPath.row]
        present(addAccountVC, animated: true, completion: nil)
    }
    
    func deleteModel(at indexPath: IndexPath){
        tableView.beginUpdates()
        self.context.delete((self.accounts![indexPath.row]))
        CoreDataManager.shared.saveContext()
        self.accounts?.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    func deleteConfirmation(at indexPath: IndexPath){
        let alert = UIAlertController(
            title: "Delete Account?",
            message: "This account will be permanently deleted from this app.",
            preferredStyle: .alert
        )
       
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
                self.deleteModel(at: indexPath)
        }))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
            // cancel action
        }))
        self.present(alert,
                animated: true,
                completion: nil
        )
    }
    
    @objc func addAccountPressed(){
        let addAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountViewController") as! AddAccountViewController
        addAccountVC.delegate = self
        present(addAccountVC, animated: true, completion: nil)
    }
}



extension AccountViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
        if let account = accounts?[indexPath.row] {
            cell.setData(account)
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
        let deleteAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { (_, _, completionHandler) in
                self.deleteConfirmation(at: indexPath)
                completionHandler(true)
            }
        )
        
        let editAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { (_, _, completionHandler) in
                self.updateModel(at: indexPath)
                completionHandler(true)
            }
        )
        
        deleteAction.image = UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular))
        deleteAction.backgroundColor = K.red
        
        editAction.image = UIImage(systemName: "square.and.pencil",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .regular))
        editAction.backgroundColor = K.colorSurface
        
        let actions: [UIContextualAction] = [deleteAction, editAction]
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


extension AccountViewController: AccountDataDelegateProtocol {
    func sendDataToCategoryViewController(account: Account, isUpdate: Bool) {
        if isUpdate == true{
            loadAccounts()
        }else {
            accounts?.append(account)
        }
        tableView.reloadData()
    }
}
