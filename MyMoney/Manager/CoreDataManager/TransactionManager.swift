//
//  TransactionManager.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-06-16.
//

import Foundation
import CoreData

class TransactionManager: StorageManager {
    
 
    func fetch(request : NSFetchRequest<Transaction> = Transaction.fetchRequest()) -> [Transaction] {
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Transaction]()
    }
    
    func create(amount: Double, date: Date, type: String, note: String, fromAccount: Account, toCategory: Category?, toAccount: Account?) {
        let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: viewContext)
        transaction.setValue(amount, forKey: "amount")
        transaction.setValue(date, forKey: "date")
        transaction.setValue(type, forKey: "type")
        transaction.setValue(note, forKey: "note")
        transaction.setValue(fromAccount, forKey: "fromAccount")
        transaction.setValue(toCategory, forKey: "toCategory")
        transaction.setValue(toAccount, forKey: "toAccount")
        
        save()
    }
}
