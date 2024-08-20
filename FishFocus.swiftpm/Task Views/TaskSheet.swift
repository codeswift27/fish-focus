//
//  TaskSheet.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 01/02/2024.
//

import SwiftUI

struct TaskSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    let task: Task?
    @State var title: String
    @State var notes: String
    @State var priority: Priority
    @State var deadline: Date
    
    init(task: Task) {
        self.task = task
        self._title = State(initialValue: task.title)
        self._notes = State(initialValue: task.notes ?? "") // Default empty string
        self._priority = State(initialValue: task.priority)
        self._deadline = State(initialValue: task.deadline)
    }
    
    init(title: String, notes: String? = "", priority: Priority, deadline: Date) {
        self.task = nil
        self._title = State(initialValue: title)
        self._notes = State(initialValue: notes ?? "")      // Default empty string
        self._priority = State(initialValue: priority)
        self._deadline = State(initialValue: deadline)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title, axis: .vertical)
                        .lineLimit(...6)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(4...8)
                }
                Section {
                    Picker("Priority", selection: $priority) {
                        Text("None").tag(Priority.none)
                        Text("Important").tag(Priority.important)
                        Text("Very Important").tag(Priority.veryImportant)
                    }
                }
                Section {
                    DatePicker("Due", selection: $deadline)
                }
            }
            .navigationBarItems(leading: Button(action: { dismiss() } , label: { Text("Cancel") }))
            .navigationBarItems(trailing: Button(action: {
                saveChanges()
                dismiss()
            }, label: {
                Text(task == nil ? "Add" : "Done").bold()
            })
            .disabled(title == ""))
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveChanges() {
        withAnimation {
            if let _ = task {
                task!.title = title
                task!.notes = notes != "" ? notes : nil
                task!.deadline = deadline
                task!.priority = priority
                task!.id = UUID()
            } else {
                let newTask = Task(context: viewContext)
                newTask.title = title
                newTask.notes = notes != "" ? notes : nil
                newTask.deadline = deadline
                newTask.priority = priority
                newTask.id = UUID()
            }

            do {
                try viewContext.save()
            } catch {
                print("Error saving changes: \(error)")
            }
        }
    }
}

#Preview {
    TaskSheet(title: "", notes: "", priority: .none, deadline: Date())
}
