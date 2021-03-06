//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-16.
//

import Foundation
import UIKit
import Charts

class RecordsViewController: UIViewController
{
    @IBOutlet weak var chartView: PieChartView!
    
    
    private var floatingButton = FloatingActionButton()
    private let transactionManager = TransactionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
        configureChart()
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        configureFloatingButton()
    }
    
    func getData() {
        let transactions = transactionManager.fetch()
        for transaction in transactions {
            if transaction.type == TransactionType.Transfer, let toAccount = transaction.toAccount {
                print( transaction.fromAccount?.name, toAccount.name, transaction.amount)
            }else {
                print(transaction.fromAccount?.name, transaction.toCategory?.name)
            }
        }

    }
}


//MARK: -  Outlet Actions
extension RecordsViewController {
    
    
    
    @objc func didTapButton() {
        let storyboard              = UIStoryboard(name: "Main", bundle: nil)
        let transactionVC           = storyboard.instantiateViewController(withIdentifier: "TransactionViewController") as UIViewController
        
        self.navigationController?.pushViewController(transactionVC, animated: true)
    }
}

//MARK: - Delegates
extension RecordsViewController {
    
}

//MARK: -  LayoutUI
extension RecordsViewController {
    
    func configureFloatingButton() {
        view.addSubview(floatingButton)

        NSLayoutConstraint.activate([
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -10),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func configNavigationItems(){
        self.navigationItem.title               = "MyMoney"

        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.leftBarButtonItem   = UIBarButtonItem(image: SFSymbol.setting, style: .done, target: self, action: nil)
    }
    
    
    func configureChart() {
        let months = ["Income", "Expense"]
        let unitsSold = [100, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet     = PieChartDataSet(entries: dataEntries,label: "")
        let pieChartData        = PieChartData(dataSet: pieChartDataSet)
        chartView.data          = pieChartData
        pieChartDataSet.colors = [Color.green, Color.red]
    }
}
