//
//  DynamicFilteredView.swift
//  TaskManagementCoreData
//
//  Created by MINH DUC NGUYEN on 19/06/2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject{
    //MARK: - Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    //MARK: - Building Custom ForEach which will give CoreData object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today" {
            //MARK: - Predicate to Filter current date Task
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            // Filter Key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 hours
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow,0])
        } else if currentTab == "Upcoming" {
            //MARK: - Predicate to Filter current date Task
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            // Filter Key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 hours
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow,0])
        } else if currentTab == "Failed" {
            //MARK: - Predicate to Filter current date Task
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            // Filter Key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 hours
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today,0])
        }else {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        // Intializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
