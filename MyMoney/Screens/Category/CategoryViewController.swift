//
//  CategoryViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-16.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoriesDict  = [String: [Category]]()
    var categoryManager: CategoryManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
    }
    
    override func viewDidLayoutSubviews() {
        categoryManager = CategoryManager()
        loadCategories()
        categoryTableView.delegate      = self
        categoryTableView.dataSource    = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        categoryTableView.reloadData()
    }
}

//MARK: -  Data Manipulation
extension CategoryViewController{
    
    func loadCategories() {
        let result = categoryManager.fetch()
        categoriesDict.removeAll()
        categoriesDict[defaulData.categoryType[0]] = result.filter({$0.type == defaulData.categoryType[0]})
        categoriesDict[defaulData.categoryType[1]] = result.filter({$0.type == defaulData.categoryType[1]})
    }
    
    func deleteModel(at indexPath: IndexPath){
        let index = indexPath.row
        let type = defaulData.categoryType[indexPath.section]
        categoryManager.delete(category: self.categoriesDict[type]![index])
        self.categoriesDict[type]?.remove(at: index)
        self.categoryTableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func updateModel(at indexPath: IndexPath){
        let type = defaulData.categoryType[indexPath.section]
        let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVC.set(delegate: self, selectaedCategory: (self.categoriesDict[type]?[indexPath.row])!)
        present(addCategoryVC, animated: true, completion: nil)
    }
    
    func deleteConfirmation(at indexPath: IndexPath){
        let alert = AlertView.showAlertBox(title: "Delete Category?", message: "This category will be permanently deleted from this app.", firstAction: UIAlertAction(
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
    
    @objc func addCategoryPressed() {
        let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVC.delegate = self
        self.present(addCategoryVC, animated: true, completion: nil)
    }
}

//MARK: -  TableView Delegate, DataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return defaulData.categoryType.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("TableviewSection", owner: self, options: nil)?.first as! TableviewSection
        view.setTitle(title: "\(defaulData.categoryType[section].capitalized)  Category")
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDict[defaulData.categoryType[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(
        _ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: nil,
                                              handler: { (_, _, completionHandler) in
            self.deleteConfirmation(at: indexPath)
            completionHandler(true)
        }
        )
        deleteAction.image = SFSymbol.deleteAction
        deleteAction.backgroundColor = Color.red
        
        let editAction = UIContextualAction(style: .normal, title: nil,
                                            handler: { (_, _, completionHandler) in
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        if let category = (categoriesDict[defaulData.categoryType[indexPath.section]]?[indexPath.row]) {
            cell.setData(category)
        }
        return cell
    }
}


extension CategoryViewController: CategoryDataDelegateProtocol {
    
    func sendDataToCategoryViewController(category: Category, isUpdate: Bool) {
        if isUpdate == true{
            loadCategories()
        }else {
            categoriesDict[category.type!]?.append(category)
        }
        categoryTableView.reloadData()
    }
}

//MARK: -  LayoutUI

extension CategoryViewController {
    
    func configNavigationItems(){
        title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategoryPressed))
    }
}
