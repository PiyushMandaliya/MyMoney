//
//  BudgetsViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-04.
//

import UIKit
import CoreData

class BudgetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var budgetCategories = [Category]()
    var nonBudgetCategories = [Category]()
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Budgets"
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCategories()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                tableView.reloadData()
            }
        }
    }
}

//MARK: -  Data Manipulation
extension BudgetsViewController{
    
    func loadCategories(request : NSFetchRequest<Category> = Category.fetchRequest()) {
        if let Categories = CoreDataManager.shared.getCategories() {
            budgetCategories.removeAll()
            nonBudgetCategories.removeAll()
            
            budgetCategories = Categories.filter({$0.type == defaulData.categoryType[1] && $0.budget != nil})
            nonBudgetCategories = Categories.filter({$0.type == defaulData.categoryType[1] && $0.budget == nil})
            
            tableView.reloadData()
        }
    }
    
    func setCategoryBudget(at indexPath: IndexPath){
        let alertTitle   = "Set budget for \(String(describing: self.nonBudgetCategories[indexPath.row].name!))."
        let alert       = AlertView.showAlertBoxWithTextBox(title: alertTitle, message: "", buttonTitle: "Add", addHandler: { (input:String?) in
            if let inputLimit = input {
                let limit = Double(inputLimit)
                if limit != nil {
                    self.saveBudget(limit: limit!,at: indexPath)
                }
            }
        }
                                                      , cancelHandler: {_ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func saveBudget(limit value: Double, at indexPath: IndexPath){
        let updatedCategory = CoreDataManager.shared.setBudget(for: nonBudgetCategories[indexPath.row], limit: value)
        nonBudgetCategories.remove(at: indexPath.row)
        budgetCategories.append(updatedCategory)
        CoreDataManager.shared.saveContext()
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        let category = self.budgetCategories[indexPath.row]
        
        let alert = AlertView.showAlertBoxWithTextBox(title: "Update budget for \(String(describing: category.name)).", message: "", buttonTitle: "Update", value: category.budget?.limit.toString(), addHandler: { (input:String?) in
            if let inputLimit = input {
                let limit = Double(inputLimit)
                if limit != nil {
                    self.updateBudget(limit: limit!,at: indexPath)
                }
            }
        }, cancelHandler: { _ in self.dismiss(animated: true) })
        present(alert, animated: true, completion: nil)

    }
    
    func updateBudget(limit value: Double, at indexPath: IndexPath){
        let category            = budgetCategories[indexPath.row]
        category.budget?.limit  = value
        CoreDataManager.shared.saveContext()
        tableView.reloadData()
    }
    
    
    func deleteModel(at indexPath: IndexPath) {
        let nonBudgetCategory   = budgetCategories[indexPath.row]
        let budget              = nonBudgetCategory.budget
        self.context.delete(budget!)
        nonBudgetCategory.budget = nil
        CoreDataManager.shared.saveContext()        
        budgetCategories.remove(at: indexPath.row)
        nonBudgetCategories.append(nonBudgetCategory)
        loadCategories()
    }
    
    
    func deleteConfirmation(at indexPath: IndexPath) {
        let alert = AlertView.showAlertBox(title: "Delete Budget?", message: "This budget will be permanently deleted from this app.", firstAction: UIAlertAction(
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





//MARK: -  Data Manipulation Methods


//MARK: -  Outlets Action

//MARK: -  TableviewDelegate, TableViewDataSource
extension BudgetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? budgetCategories.count : nonBudgetCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 90 : 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("TableviewSection", owner: self, options: nil)?.first as! TableviewSection
        if section == 0 {
            view.setTitle(title: "Budget categories: Apr, 2022")
        }else {
            view.setTitle(title: "Not budget this month")
        }
        return view
    }
    
    func tableView(
        _ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 {
            let deleteAction = UIContextualAction(style: .normal, title: nil,
                handler: {  [weak self]  (_, _, completionHandler) in
                    guard let self = self else {return}
                    self.deleteConfirmation(at: indexPath)
                    completionHandler(true)
                }
            )
            deleteAction.image              = SFSymbol.deleteAction
            deleteAction.backgroundColor    = Color.red
            
            
            let editAction = UIContextualAction( style: .normal, title: nil,
                handler: { [weak self] (_, _, completionHandler) in
                    guard let self = self else {return}
                    self.updateModel(at: indexPath)
                    completionHandler(true)
                }
            )
            
            editAction.image                = SFSymbol.editAction
            editAction.backgroundColor      = Color.surface
            
            let configuration               = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: BudgetCell! = tableView.dequeueReusableCell(withIdentifier:  BudgetCell.identifier) as? BudgetCell
            cell.set(category: budgetCategories[indexPath.row])
            return cell
        }else {
            let cell: SetBudgetCell! = tableView.dequeueReusableCell(withIdentifier: SetBudgetCell.identifier) as? SetBudgetCell
            
            cell.set(category: nonBudgetCategories[indexPath.row], onTap: { self.setCategoryBudget(at: indexPath) })
            return cell
        }
    }
}


//MARK: -  LayoutUI

extension BudgetsViewController {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SetBudgetCell.identifier, bundle: nil), forCellReuseIdentifier: SetBudgetCell.identifier)
        tableView.register(UINib(nibName: BudgetCell.identifier, bundle: nil), forCellReuseIdentifier: BudgetCell.identifier)
    }
}
