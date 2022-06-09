//
//  TaskViewModel.swift
//  TaskManagerAppUI
//
//  Created by NGUYEN MINH DUC on 06/06/2022.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    //MARK: - New Task Properties
    @Published var openTaskEdit: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    //MARK: - Editing Existing Task Data
    @Published var editTask: Task?
    
    //MARK: - Adding Task To Core Data
    func addTask(context: NSManagedObjectContext) -> Bool {
        //MARK: - Updating Existing Data in Core Data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
            
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    //MARK: - Resetting Data
    func resetTaskData() {
        taskType = "Basic"
        taskTitle = ""
        taskColor = "Yellow"
        taskDeadline = Date()
    }
    
    //MARK: - If Edit Task Is Avaiable then Setting Existing Data
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskTitle = editTask.title ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}
