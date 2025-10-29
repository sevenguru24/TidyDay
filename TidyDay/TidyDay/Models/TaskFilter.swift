//
//  TaskFilter.swift
//  TidyDay
//
//  Created by John Rediker on 10/29/25.
//

import Foundation

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case pending = "Pending"
}