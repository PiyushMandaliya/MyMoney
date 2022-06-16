//
//  AddAccountViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-07.
//

import UIKit

protocol AccountDataDelegateProtocol: AnyObject {
    func sendDataToCategoryViewController(account: Account, isUpdate: Bool)
}

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var iconCV: UICollectionView!
    @IBOutlet weak var tfInitialAmount: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    var selectedImage: String?
    var isUpdate: Bool              = false
    var selectedAccount: Account?   = nil
    weak var delegate: AccountDataDelegateProtocol? = nil
    let accountManager = AccountManager()

    func set(delegate: AccountDataDelegateProtocol, selectedAccount: Account?) {
        self.delegate           = delegate
        self.selectedAccount    = selectedAccount
        self.isUpdate           = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconCV.dataSource   = self
        iconCV.delegate     = self
        setDefaultValues()
    }
}

//MARK: -  Data Manipulation Methods
extension AddAccountViewController {
    
    func setDefaultValues(){
        if selectedAccount != nil {
            tfName.text             = selectedAccount?.name
            tfInitialAmount.text    = (String(describing: selectedAccount?.initial_amount ?? 0))
        }
    }
    
    
    func saveOrUpdateAccount(_ name: String, _ initialBalance: String, _ image: String ){
        var newAccount: Account!
        if isUpdate == true && selectedAccount != nil {
            accountManager.update(account: selectedAccount!, name: name, image: image, initialAmount: initialBalance)
            newAccount = selectedAccount
        }else{
            newAccount = accountManager.create(name: name, image: image, initialAmount: initialBalance)
        }
        self.callDelegate(newAccount)
    }
    
    
    func callDelegate(_ newAccount: Account){
        if self.delegate != nil {
            self.delegate?.sendDataToCategoryViewController(account: newAccount, isUpdate: isUpdate)
        }
    }
}

extension AddAccountViewController {
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
        guard let accountName   = tfName.text, !accountName.isEmpty, let accountImage = selectedImage, let initialBalance      = tfInitialAmount.text, !initialBalance.isEmpty         else {
            
            let alert = AlertView.showAlertBox(title: "Not done yet", message: "You haven't filled in the information we need to create this account for you.", firstAction: UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        saveOrUpdateAccount(accountName, initialBalance, accountImage)
        dismiss(animated: true, completion: nil)
    }
}



//MARK: -  CollectionView Delegates

extension AddAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaulData.accountImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath as IndexPath) as! IconCell
        cell.icon.image = UIImage(named: "\(defaulData.accountImages[indexPath.row])")
        if selectedAccount != nil, selectedAccount!.image == defaulData.accountImages[indexPath.row] {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedImage   = defaulData.accountImages[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding             = 10
        let availableWidth      = Int(UIScreen.main.bounds.width) - (5 * padding) - (padding * 2)
        let cellWidthAndHeight  = availableWidth / 6
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage   = defaulData.accountImages[indexPath.row]
    }
}
