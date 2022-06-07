//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-04-19.
//

import Foundation
import CoreData

class CoreDataManager{
    
    private let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpenseTracker")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    private init() {}
    
    
    func saveContext () {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func getCategories(request : NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]? {
        let context = persistentContainer.viewContext
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do{
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        return nil
    }
    
    
    func getAccounts(request : NSFetchRequest<Account> = Account.fetchRequest()) -> [Account]? {
        let context = persistentContainer.viewContext
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do{
            return try context.fetch(request)
        } catch {
            print("Error loading accounts \(error)")
        }
        return nil
    }
    
    
    func setBudget(for category: Category, limit: Double) -> Category {
        let context     = persistentContainer.viewContext
        let newBudget   = Budget(context: context)
        newBudget.month = Date()
        newBudget.limit = limit
        category.budget = newBudget
        saveContext()
        return category
    }
    
    
    func setDefaultData() {
        saveDefaultCategories(data: defaulData.incomeCategories, type: defaulData.categoryType[0])
        saveDefaultCategories(data: defaulData.expenseCategories, type: defaulData.categoryType[1])
        setDefaultAccounts()
    }
    
    func saveDefaultCategories(data categories: [String: String], type: String) {
        print("")
        let context         = persistentContainer.viewContext
        privateMOC.parent   = context
        privateMOC.performAndWait {
            do {
                for category in categories {
                    let expenseCategoryEntry = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
                    expenseCategoryEntry.setValue(category.key, forKey: "name")
                    expenseCategoryEntry.setValue(type, forKey: "type")
                    expenseCategoryEntry.setValue("\(category.value).png", forKey: "image")
                    try context.save()
                }
            } catch {
                print("setDefaultExpenseCategories failed, \(error), \(error.localizedDescription)")
            }
        }
    }
    
    
    func setDefaultAccounts() {
        let context         = persistentContainer.viewContext
        privateMOC.parent   = context
        privateMOC.performAndWait {
            do {
                for account in defaulData.accounts {
                    let accountEntry = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context)
                    accountEntry.setValue(account.key, forKey: "name")
                    accountEntry.setValue(0, forKey: "initial_amount")
                    accountEntry.setValue("\(account.value).png", forKey: "image")
                    try context.save()
                }
            } catch {
                print("setDefaultExpenseCategories failed, \(error), \(error.localizedDescription)")
            }
        }
    }
    
}
