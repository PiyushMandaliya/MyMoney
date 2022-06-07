//
//  AddCategoryViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-06.
//

import UIKit


#warning("Define 2 diff methods")
protocol CategoryDataDelegateProtocol {
    func sendDataToCategoryViewController(category: Category, isUpdate: Bool)
}


class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTypeSegment: UISegmentedControl!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var iconCV: UICollectionView!
    
    var categoryType: String?
    var selectedImage: String?
    var categoryImages              = [String]()
    var isUpdate: Bool              = false
    var selectedCategory: Category? = nil
    
    let context     = CoreDataManager.shared.persistentContainer.viewContext
    var delegate: CategoryDataDelegateProtocol? = nil
//    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    init(delegate: CategoryDataDelegateProtocol) {
//        super.init(nibName: nil, bundle: nil)
//        self.delegate   = delegate
//    }
//
    
    func set(delegate: CategoryDataDelegateProtocol, selectaedCategory: Category?) {
        self.selectedCategory       = selectaedCategory
        self.isUpdate               = true
        self.delegate               = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...86{
            categoryImages.append("\(i).png")
        }
        iconCV.dataSource = self
        iconCV.delegate = self
        setDefaultValues()
    }
}


//MARK: -  Data Manipulation Methods
extension AddCategoryViewController {
    func setDefaultValues(){
        if selectedCategory != nil{
            categoryName.text = selectedCategory?.name
            categoryTypeSegment.selectedSegmentIndex = selectedCategory?.type == "income" ? 0 : 1
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        let type = categoryTypeSegment.titleForSegment(at: categoryTypeSegment.selectedSegmentIndex)!
        guard let categoryName = categoryName.text, !categoryName.isEmpty, let categoryImage = selectedImage        else {
            let alert = AlertView.showAlertBox(title: "Not done yet", message: "You haven't filled in the information we need to create this category for you.", firstAction: UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        saveOrUpdateCategory(categoryName,type.lowercased(),categoryImage )
        dismiss(animated: true, completion: nil)
    }
    
    func saveOrUpdateCategory(_ name: String, _ type: String, _ image: String ){
        var newCategory: Category!
        if isUpdate == true && selectedCategory != nil {
            newCategory = selectedCategory!
        }else{
            newCategory = Category(context: self.context)
        }
        newCategory.image = image
        newCategory.type = type.lowercased()
        newCategory.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.persistCategory(newCategory)
    }
    
    func persistCategory(_ newCategory: Category){
        CoreDataManager.shared.saveContext()
        if self.delegate != nil {
            self.delegate?.sendDataToCategoryViewController(category: newCategory, isUpdate: isUpdate)
        }
    }
}

//MARK: -  CollectionView Delegates

extension AddCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath as IndexPath) as! IconCell
        cell.icon.image = UIImage(named: "\(categoryImages[indexPath.row])")
        if selectedCategory != nil, selectedCategory!.image == categoryImages[indexPath.row] {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedImage = categoryImages[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 10
        
        let availableWidth = Int(UIScreen.main.bounds.width) - (6 * padding) - (2 * padding)
        let cellWidthAndHeight = availableWidth / 7
        print(cellWidthAndHeight)
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = categoryImages[indexPath.row]
    }
}
