//
//  HabitVM + Category.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/1/22.
//

import SwiftUI
import CoreData

let categorySamples: [CategorySample] = [CategorySample(title: "General", color: "Red"), CategorySample(title: "Personal", color: "Orange"), CategorySample(title: "Professional", color: "Yellow"), CategorySample(title: "Hobbies", color: "Green"), CategorySample(title: "Lifestyle", color: "Blue")]

extension HabitViewModel {
    func createCategories() {
        
        for category in categorySamples {
            _ = addCategory(title: category.title, color: category.color)
        }
        
        do {
            try viewContext.save()
            hasCreatedCategories = true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addCategory(title: String, color: String) -> Category {
        let newCategory = Category(context: viewContext)
        newCategory.title = title
        newCategory.color = color
        
        return newCategory
    }
    
    func deleteCategory(category: Category) {
        let habitRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        habitRequest.includesPropertyValues = false
        
        let categoryRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        categoryRequest.includesPropertyValues = false
        
        do {
            let habits = try viewContext.fetch(habitRequest) as! [Habit]
            let filteredHabits = habits.filter({ $0.category == category })
                        
            let categories = try viewContext.fetch(categoryRequest) as! [Category]
            let generalCategory = categories.first(where: { $0.title == "General" })
            
            filteredHabits.forEach { habit in
                habit.category = generalCategory
            }
            
            viewContext.delete(category)
            
            try viewContext.save()
            refreshID = UUID()
        } catch {
            print("Unable to delete category: ", error)
        }
    }
}

struct CategorySample: Identifiable {
    var id = UUID()
    var title: String
    var color: String
}
