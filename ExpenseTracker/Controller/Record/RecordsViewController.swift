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
    
    private var floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        button.layer.masksToBounds = true
        button.backgroundColor = .systemCyan
        let image = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = K.white
        button.setTitleColor(K.white, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        
        button.layer.cornerRadius = 30

        
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chartView: PieChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(floatingButton)
        self.navigationItem.title = "Expense Tracker"
        configNavigationItems()
        
        let months = ["Income", "Expense"]
        let unitsSold = [100, 4.0]
        setChart(dataPoints: months, values: unitsSold)
        
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    @objc func didTapButton(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionViewController") as UIViewController
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        floatingButton.frame = CGRect(x: view.frame.size.width - 60 - 8, y: view.frame.size.height - 60 - 8 - view.safeAreaInsets.bottom, width: 60, height: 60)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            
            let dataEntry = PieChartDataEntry(value: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries,label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        chartView.data = pieChartData
        
        pieChartDataSet.colors = [K.green,K.red]
    }
    
    func configNavigationItems(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil)
    }
}
