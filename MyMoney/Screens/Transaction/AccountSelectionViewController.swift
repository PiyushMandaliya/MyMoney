//
//  AccountSelectionViewController.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-04-29.
//

import UIKit

class AccountSelectionViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [Any] = [Any]()
    var selectedData: Any? = nil
    var isAccountSelection = false
    
    override var sheetPresentationController: UISheetPresentationController{
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColletionView()
    }
}

//MARK: -  Outlet Actions
extension AccountSelectionViewController {
    
    @IBAction func addActionPressed(_ sender: UIButton) {
    
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
        selectedData = data[indexPath.row]
        self.dismiss(animated: true)
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
