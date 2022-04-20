//
//  AddAccountViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-07.
//

import UIKit

protocol AccountDataDelegateProtocol {
    func sendDataToCategoryViewController(account: Account, isUpdate: Bool)
}

class AddAccountViewController: UIViewController {
    
    let cellGap = 10
    let leftGapToScreen = 10
    let rightGapToScreen = 10
    let minLineSpacing = 10
    let minInterItemSpacing = 10
    
    var delegate: AccountDataDelegateProtocol? = nil
    var selectedImage: String?
    var isUpdate: Bool = false
    var selectedAccount: Account? = nil
    
    let context = CoreDataManager.shared.persistentContainer.viewContext

    @IBOutlet weak var iconCV: UICollectionView!
    @IBOutlet weak var tfInitialAmount: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconCV.dataSource = self
        iconCV.delegate = self
        setDefaultValues()
    }
    
    
    
}
//MARK: -  Data Manipulation Methods
extension AddAccountViewController {
    func setDefaultValues(){
        if selectedAccount != nil{
            tfName.text = selectedAccount?.name
            tfInitialAmount.text = (String(describing: selectedAccount?.initial_amount ?? 0))
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        guard let accountName = tfName.text, !accountName.isEmpty, let accountImage = selectedImage, let initialBalance = tfInitialAmount.text, !initialBalance.isEmpty         else {
            let alert = UIAlertController(title: "Not done yet", message: "You haven't filled in the information we need to create this account for you.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        saveOrUpdateAccount(accountName, initialBalance, accountImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveOrUpdateAccount(_ name: String, _ initialBalance: String, _ image: String ){
        var newAccount: Account!
        if isUpdate == true && selectedAccount != nil {
            newAccount = selectedAccount!
        }else{
            newAccount = Account(context: self.context)
        }
        
        newAccount.image = image
        newAccount.name = name
        newAccount.initial_amount = NSDecimalNumber(value: NSString(string: initialBalance).doubleValue)
        self.persistAccount(newAccount)

    }
    
    func persistAccount(_ newAccount: Account){
        CoreDataManager.shared.saveContext()
        if self.delegate != nil {
            self.delegate?.sendDataToCategoryViewController(account: newAccount, isUpdate: isUpdate)
        }
    }
    
}

//MARK: -  CollectionView Delegates

extension AddAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.accountImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCollectionViewCell", for: indexPath as IndexPath) as! IconCollectionViewCell
        cell.icon.image = UIImage(named: "\(K.accountImages[indexPath.row])")
        if selectedAccount != nil, selectedAccount!.image == K.accountImages[indexPath.row] {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedImage = K.accountImages[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = Int(UIScreen.main.bounds.width) - (5 * cellGap) - leftGapToScreen - rightGapToScreen
        let cellWidth = availableWidth / 6
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = K.accountImages[indexPath.row]
    }
}
