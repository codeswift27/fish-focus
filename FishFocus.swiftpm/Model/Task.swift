//
//  Task.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 25/01/2024.
//

import SwiftUI
import CoreData

@objc(Task)
class Task: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var notes: String?
    @NSManaged var deadline: Date
    @NSManaged var priorityValue: Int
    @NSManaged var id: UUID
}

extension Task: Identifiable {
    var priority: Priority {
        set {
            priorityValue = newValue.rawValue
        }
        get {
            Priority(rawValue: priorityValue) ?? .none
        }
    }
    
    @objc
    var day: String {
        if Calendar.current.isDateInYesterday(deadline) {
            return "Yesterday"
        } else if Calendar.current.isDateInToday(deadline) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(deadline) {
            return "Tomorrow"
        } else {
            let date = Calendar.current.dateComponents([.day, .weekday, .month], from: deadline)
            guard let _ = date.day else { return "" }
            guard let _ = date.weekday else { return "" }
            guard let _ = date.month else { return "" }
            return "\(getWeekday(from: date.weekday!)), \(getMonth(from: date.month!)) \(date.day!)"
        }
    }
    
    func getWeekday(from id: Int) -> String {
        switch id {
            case 1: return "Sunday"
            case 2: return "Monday"
            case 3: return "Tuesday"
            case 4: return "Wednesday"
            case 5: return "Thursday"
            case 6: return "Friday"
            case 7: return "Saturday"
            default: return "Unknown"
        }
    }
    
    func getMonth(from id: Int) -> String {
        switch id {
            case 1: return "Jan"
            case 2: return "Feb"
            case 3: return "Mar"
            case 4: return "Apr"
            case 5: return "May"
            case 6: return "Jun"
            case 7: return "Jul"
            case 8: return "Aug"
            case 9: return "Sep"
            case 10: return "Oct"
            case 11: return "Nov"
            case 12: return "Dec"
            default: return "Uknown"
        }
    }
}

enum Priority: Int {
    case none = 0
    case important = 1
    case veryImportant = 2
}
