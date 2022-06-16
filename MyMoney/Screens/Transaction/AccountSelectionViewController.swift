//
//  AccountSelectionViewController.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-29.
//

import UIKit

protocol SelectionDelegate: AnyObject {
    func didSelectAccount(selectedAccount: Account)
    func didSelectCategory(selectedCategory: Any)
}

class AccountSelectionViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [Any] = [Any]()
    var isAccountSelection  = false
    var isToSelection     = false
    weak var delegate: SelectionDelegate!
    
    override var sheetPresentationController: UISheetPresentationController{
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTitle = "Manage \(isAccountSelection ? "Account" : "Category")"
        btnAdd.setTitle(buttonTitle, for: .normal)
        configureColletionView()
    }
}

//MARK: -  Outlet Actions
extension AccountSelectionViewController {
    
    @IBAction func addActionPressed(_ sender: UIButton) {
        let accountSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        present(accountSelectionVC, animated: true, completion: nil)
    }
}


//MARK: -  CollectionView Delegate
extension AccountSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCell.identifier, for: indexPath as IndexPath) as! SelectionCell
     
        isAccountSelection ? cell.set(data[indexPath.row] as! Account)  : cell.set(data[indexPath.row] as! Category)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding             = 10
        let numberOfCell        = 4
        let availableWidth      = Int(UIScreen.main.bounds.width) - ((numberOfCell - 1) * padding) - padding - padding
        let cellWidthAndHeigh   = availableWidth / numberOfCell
        
        return CGSize(width: cellWidthAndHeigh, height: cellWidthAndHeigh)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        if isAccountSelection {
            if isToSelection {
                delegate.didSelectCategory(selectedCategory: data[indexPath.row] as! Account)
            } else {
                delegate.didSelectAccount(selectedAccount: data[indexPath.row] as! Account)
            }
        }else {
            delegate.didSelectCategory(selectedCategory: data[indexPath.row] as! Category)
        }
    }
}


//MARK: -  LayoutUI
extension AccountSelectionViewController {
    
    func configureColletionView(){
        collectionView.register(UINib(nibName: SelectionCell.identifier, bundle: .main), forCellWithReuseIdentifier: SelectionCell.identifier)
        if !data.isEmpty {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    
    func configureSheetPresentation() {
        sheetPresentationController.delegate = self
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium(), .large()
        ]
    }
}
