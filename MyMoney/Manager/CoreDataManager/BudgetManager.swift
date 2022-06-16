//
//  BudgetManager.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-06-16.
//

import Foundation
import CoreData

class BudgetManager: StorageManager {
    
    func create(limit: Double) -> Budget {
        let budget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: viewContext)
        budget.setValue(Date(), forKey: "month")
        budget.setValue(limit, forKey: "limit")
        save()
        return budget as! Budget
    }
    
    func update(category: Category, limit value: Double){
        category.budget?.limit  = value
        save()
    }
    
    func delete(_ budget: Budget) {
        persistentContainer.viewContext.delete(budget)
        save()
    }
}
