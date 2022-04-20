//
//  AddCategoryViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-06.
//

import UIKit


protocol CategoryDataDelegateProtocol {
    func sendDataToCategoryViewController(category: Category, isUpdate: Bool)
}


class AddCategoryViewController: UIViewController {
    
    let cellGap = 10
    let leftGapToScreen = 10
    let rightGapToScreen = 10
    let minLineSpacing = 10
    let minInterItemSpacing = 10
    
    var delegate: CategoryDataDelegateProtocol? = nil
    
    var categoryImages = [String]()
    var categoryType: String?
    var selectedImage: String?
    var isUpdate: Bool = false
    var selectedCategory: Category? = nil
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    @IBOutlet weak var categoryTypeSegment: UISegmentedControl!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var iconCV: UICollectionView!
    
    
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
            print("Category Name Empty")
            let alert = UIAlertController(title: "Not done yet", message: "You haven't filled in the information we need to create this category for you.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
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
        newCategory.name = name
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCollectionViewCell", for: indexPath as IndexPath) as! IconCollectionViewCell
        cell.icon.image = UIImage(named: "\(categoryImages[indexPath.row])")
        if selectedCategory != nil, selectedCategory!.image == categoryImages[indexPath.row] {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedImage = categoryImages[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = Int(UIScreen.main.bounds.width) - (6 * cellGap) - leftGapToScreen - rightGapToScreen
        let cellWidth = availableWidth / 7
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = categoryImages[indexPath.row]
    }
}
