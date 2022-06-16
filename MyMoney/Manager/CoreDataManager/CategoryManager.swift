//
//  CategoryManager.swift
//  MyMoney
//
//  Created by Piyush Mandaliya on 2022-06-16.
//

import Foundation
import CoreData
import UIKit

class CategoryManager: StorageManager {
    
    override func initDefaultValue() {
        if fetch().count == 0 {
            initDefaultValue(data: defaulData.incomeCategories, type: defaulData.categoryType[0])
            initDefaultValue(data: defaulData.expenseCategories, type: defaulData.categoryType[1])
        }
        
    }
    
    func initDefaultValue(data categories: [String: String], type: String) {
        privateMOC.parent   = viewContext
        privateMOC.performAndWait {
                for category in categories {
                    _ = create(name: category.key, type: type, image: "\(category.value).png")
                }
                save()
        }
    }
    
    func fetch(request : NSFetchRequest<Category> = Category.fetchRequest()) -> [Category] {
        print("Category Fetch")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Category]()
    }
    
    
    func create(name: String, type: String, image: String) -> Category {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: viewContext)
        category.setValue(name, forKey: "name")
        category.setValue(type, forKey: "type")
        category.setValue(image, forKey: "image")
        save()
        return category as! Category
    }
    
    
    func update(category: Category,name: String, type: String, image: String) {
        category.image = image
        category.type = type.lowercased()
        category.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        save()
    }
    
    
    func setBudget(for category: Category, with budget: Budget) -> Category{
        category.budget = budget
        save()
        return category
    }
    
    
    func delete(category: Category) {
        persistentContainer.viewContext.delete(category)
        save()
    }
    
    
    
}
