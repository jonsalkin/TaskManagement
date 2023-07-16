//
//  Task.swift
//  TaskManagement
//
//  Created by Jon Salkin on 7/15/23.
//

import SwiftUI

// Task Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
