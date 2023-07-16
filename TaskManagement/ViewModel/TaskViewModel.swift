//
//  TaskViewModel.swift
//  TaskManagement
//
//  Created by Jon Salkin on 7/15/23.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // Sample Tasks
    @Published var storedTasks: [Task] = [
    
        Task(taskTitle: "Meeting", taskDescription: "Discuss team tasks for the day", taskDate: .init(timeIntervalSince1970: 1689105854)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1689192254)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1689278654)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate: .init(timeIntervalSince1970: 1689365054)),
        Task(taskTitle: "Team party", taskDescription: "Have fun with the team", taskDate: .init(timeIntervalSince1970: 1689465854)),
        Task(taskTitle: "Client Meeting", taskDescription: "Propose project to client", taskDate: .init(timeIntervalSince1970: 1689469454)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1689473054)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next app proposal", taskDate: .init(timeIntervalSince1970: 1689519854))
    
    ]
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    // MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // MARK: Filter Today Tasks
    func filterTodayTasks() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
            
        }
        
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
        
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
