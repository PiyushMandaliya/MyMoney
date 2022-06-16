//
//  AccountManager.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-06-16.
//

import Foundation
import CoreData

class AccountManager: StorageManager {
    
    override func initDefaultValue() {
        if fetch().count == 0 {
            privateMOC.parent   = viewContext
            privateMOC.performAndWait {
                for account in defaulData.accounts {
                    _ = create(name: account.key, image: "\(account.value).png", initialAmount: "0")
                }
            }
        }
    }
    
    func fetch(request : NSFetchRequest<Account> = Account.fetchRequest()) -> [Account] {
        request.returnsObjectsAsFaults = true
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Account]()
    }
    
    func update(account: Account,name: String, image: String, initialAmount: String) {
        account.image = image
        account.initial_amount = NSDecimalNumber(value: NSString(string: initialAmount).doubleValue)
        account.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        save()
    }
    
    func create(name: String, image: String, initialAmount: String) -> Account {
        let account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: viewContext)
        account.setValue(name, forKey: "name")
        account.setValue(NSDecimalNumber(value: NSString(string: initialAmount).doubleValue), forKey: "initial_amount")
        account.setValue(image, forKey: "image")
        save()
        return account as! Account
    }
    
    func delete(account: Account) {
        persistentContainer.viewContext.delete(account)
        save()
    }
}
