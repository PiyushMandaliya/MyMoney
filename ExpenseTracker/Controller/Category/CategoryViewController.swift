//
//  CategoryViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-16.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    var categoriesDict = [String: [Category]]()
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        configNavigationItems()
    }
    
    override func viewDidLayoutSubviews() {
        loadCategories()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    func configNavigationItems(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategoryPressed))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        categoryTableView.reloadData()
    }
}

//MARK: -  Data Manipulation
extension CategoryViewController{
    func loadCategories(request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categoriesDict.removeAll()
            categoriesDict[K.categoryType[0]] = try context.fetch(request).filter({$0.type == K.categoryType[0]})
            categoriesDict[K.categoryType[1]] = try context.fetch(request).filter({$0.type == K.categoryType[1]})
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func deleteModel(at indexPath: IndexPath){
        let type = K.categoryType[indexPath.section]
        categoryTableView.beginUpdates()
        self.context.delete((self.categoriesDict[type]?[indexPath.row])!)
        CoreDataManager.shared.saveContext()
        self.categoriesDict[type]?.remove(at: indexPath.row)
        self.categoryTableView.deleteRows(at: [indexPath], with: .left)
        categoryTableView.endUpdates()
        categoryTableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath){
        let type = K.categoryType[indexPath.section]
        let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVC.delegate = self
        addCategoryVC.isUpdate = true
        addCategoryVC.selectedCategory = (self.categoriesDict[type]?[indexPath.row])!
        present(addCategoryVC, animated: true, completion: nil)
    }
    
    func deleteConfirmation(at indexPath: IndexPath){
        let alert = UIAlertController(
            title: "Delete Category?",
            message: "This category will be permanently deleted from this app.",
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
    
    @objc func addCategoryPressed() {
        let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true, completion: nil)
    }
}

//MARK: -  TableView Delegate, DataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.categoryType.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("TableviewSection", owner: self, options: nil)?.first as! TableviewSection
        view.sectionTitle.text = "\(K.categoryType[section].capitalized)  Category"
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDict[K.categoryType[section]]?.count ?? 0
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        if let category = (categoriesDict[K.categoryType[indexPath.section]]?[indexPath.row]) {
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
