//
//  TaskCard.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 04/01/2024.
//

import SwiftUI

struct TaskCard: View {
    @Environment(\.managedObjectContext) private var viewContext
    let task: Task
    var sameYear: Bool
    let isEditable: Bool
    let isSelected: Bool
    @State var showTimePicker: Bool = false
    @State var willDeleteTask = false
    
    // Other variables
    @Binding var taskWasDeleted: Bool
    @Binding var taskToEdit: Task?
    @Binding var timer: Int?
    @Binding var tasksToComplete: Set<Task>
    
    init(task: Task, isEditable: Bool, isSelected: Bool, taskToEdit: Binding<Task?>, taskWasDeleted: Binding<Bool>, timer: Binding<Int?>, tasksToComplete: Binding<Set<Task>>) {
        self.task = task
        self.sameYear = Calendar.current.dateComponents([.year], from: task.deadline) == Calendar.current.dateComponents([.year], from: Date())
        self.isEditable = isEditable
        self.isSelected = isSelected
        self._taskToEdit = taskToEdit
        self._taskWasDeleted = taskWasDeleted
        self._timer = timer
        self._tasksToComplete = tasksToComplete
    }
    
    var body: some View {
        if isSelected {
            GroupBox {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if task.priority == .important {
                            Image(systemName: "exclamationmark")
                                .foregroundStyle(Color(UIColor.white))
                                
                        } else if task.priority == .veryImportant {
                            Image(systemName: "exclamationmark.2")
                                .foregroundStyle(Color(UIColor.white))
                        }
                        Text(task.title)
                            .foregroundStyle(Color(UIColor.white))
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Color(UIColor.white))
                    }
                    if let notes = task.notes {
                        Text(notes)
                            .font(.callout)
                            .foregroundStyle(Color(UIColor.lightText))
                    }
                    Text("Due " + (sameYear ? formatDate(from: task.deadline) : formatDate(from: task.deadline, using: "E, MMM d, y")) + " at " + formatDate(from: task.deadline, using: "hh:mm a"))
                        .font(.callout)
                        .foregroundStyle(Color(UIColor.lightText))
                        .padding(.top, 4)
                }
            }
            .backgroundStyle(Color.accentColor)
        } else if isEditable {
            GroupBox {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if task.priority == .important {
                            Image(systemName: "exclamationmark")
                                .foregroundStyle(Color.accentColor)
                                
                        } else if task.priority == .veryImportant {
                            Image(systemName: "exclamationmark.2")
                                .foregroundStyle(Color.accentColor)
                        }
                        Text(task.title)
                        Spacer()
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                    }
                    if let notes = task.notes {
                        Text(notes)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    Text("Due " + (sameYear ? formatDate(from: task.deadline) : formatDate(from: task.deadline, using: "E, MMM d, y")) + " at " + formatDate(from: task.deadline, using: "hh:mm a"))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
        } else {
            GroupBox {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if task.priority == .important {
                            Image(systemName: "exclamationmark")
                                .foregroundStyle(Color.accentColor)
                                
                        } else if task.priority == .veryImportant {
                            Image(systemName: "exclamationmark.2")
                                .foregroundStyle(Color.accentColor)
                        }
                        Text(task.title)
                        Spacer()
                        Menu {
                            taskMenu(task: task)
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    if let notes = task.notes {
                        Text(notes)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    Text("Due " + (sameYear ? formatDate(from: task.deadline) : formatDate(from: task.deadline, using: "E, MMM d, y")) + " at " + formatDate(from: task.deadline, using: "hh:mm a"))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
            .onTapGesture {
                // To prevent both dialogues from triggering at the same time
                if !willDeleteTask {
                    showTimePicker.toggle()
                }
            }
            .contextMenu {
                if !isEditable {
                    taskMenu(task: task)
                }
            }
            .confirmationDialog("Select Time", isPresented: $showTimePicker) {
                TimePicker(tasks: [task], timer: $timer, tasksToComplete: $tasksToComplete)
            } message: {
                Text("How long would you like to focus?")
            }
            .confirmationDialog("Delete Task", isPresented: $willDeleteTask) {
                Button(role: .destructive) {
                    viewContext.delete(task)
                    taskWasDeleted = true
                } label: { Text("Delete Task") }
            } message: {
                Text("Are you sure you want to delete this task?")
            }
        }
    }
    
    func formatDate(from date: Date, using format: String = "E, MMM d") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

private extension TaskCard {
    @ViewBuilder func taskMenu(task: Task) -> some View {
        Menu {
            TimePicker(tasks: [task], timer: $timer, tasksToComplete: $tasksToComplete)
        } label: { Label("Start Task", systemImage: "play") }
        Button {
            taskToEdit = task
        } label: { Label("Edit", systemImage: "pencil") }
        Button(role: .destructive) {
            if showTimePicker {
                showTimePicker = false
                // To prevent both dialogues from triggering at the same time
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    willDeleteTask.toggle()
                }
            } else {
                willDeleteTask.toggle()
            }
        } label: { Label("Delete", systemImage: "trash")}
    }
}
