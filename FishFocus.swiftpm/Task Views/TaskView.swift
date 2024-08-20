//
//  TaskView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 25/01/2024.
//

import SwiftUI

struct TaskView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @SectionedFetchRequest(sectionIdentifier: \Task.day, sortDescriptors: [SortDescriptor(\Task.deadline)])
    private var taskGroups: SectionedFetchResults<String, Task>
    
    // New/edit task
    @State private var showTaskSheet = false
    @State private var taskToEdit: Task?
    @State private var editMode = false
    @State private var isEditable = false // separate variable because of how WiggleModifier functions
    @State private var selection: Set<Task> = []
    
    // Delete task
    @State private var willDeleteTask = false
    @State private var taskWasDeleted = false  // workaround because the app sometimes crashes if I save deletions immediately :(
    
    // Complete task
    @State private var showTimePicker = false
    @State private var timer: Int?
    @State private var tasksToComplete: Set<Task> = []
    @State private var showAlert = false
    
    var body: some View {
        Group {
            if taskGroups.isEmpty {
                Text("Psst... click + to add a task!")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    ForEach(taskGroups) { taskGroup in
                        VStack {
                            HStack {
                                Text(taskGroup.id)
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 6)
                                Spacer()
                            }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), alignment: .top)]) {
                                ForEach(taskGroup.sorted { $0.priorityValue > $1.priorityValue }) { task in
                                    VStack {
                                        TaskCard(
                                            task: task,
                                            isEditable: isEditable,
                                            isSelected: selection.contains(task),
                                            taskToEdit: $taskToEdit,
                                            taskWasDeleted: $taskWasDeleted,
                                            timer: $timer,
                                            tasksToComplete: $tasksToComplete
                                        )
                                    }
                                    .wiggling(isWiggling: $editMode, rotationAmount: 3)
                                    .rotationEffect(Angle(degrees: editMode ? -1.5 : 0))
                                    .onTapGesture {
                                        if editMode {
                                            if let index = selection.firstIndex(of: task) {
                                                selection.remove(at: index)
                                            } else {
                                                selection.insert(task)
                                            }
                                        }
                                    }
                                    .padding(6)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .sheet(item: $taskToEdit, onDismiss: { taskToEdit = nil }) { task in
                    TaskSheet(task: task)
                }
                .fullScreenCover(item: $timer, onDismiss: {
                    timer = nil
                    showAlert = true
                }) { time in
                    ZStack {
                        FishSilhouetteView()
                        FocusView(minutes: time)
                    }
                }
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            if editMode {
                let allTasks = Set(taskGroups.flatMap { $0 })
                Button(selection.count == allTasks.count && selection.count != 0 ? "Deselect All" : "Select All") {
                    if selection.count == allTasks.count && selection.count != 0 {
                        selection = []
                    } else {
                        selection = allTasks
                    }
                }
            } else {
                Button(action: { showTaskSheet.toggle() }) {
                    Image(systemName: "plus")
                }
            }
            Button(action: {
                if editMode { selection = [] }
                withAnimation { editMode.toggle() }
                isEditable.toggle()
            }) {
                Text(editMode ? "Done" : "Select")
                    .bold(editMode)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
        }
        .toolbar {
            if editMode {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Start Tasks") {
                        tasksToComplete = selection
                        showTimePicker.toggle()
                    }
                    .disabled(selection.isEmpty)
                    .confirmationDialog("Select Time", isPresented: $showTimePicker) {
                        Button("5 minutes") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 5
                        }
                        Button("10 minutes") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 10
                        }
                        Button("15 minutes") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 15
                        }
                        Button("30 minutes") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 30
                        }
                        Button("1 hour") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 60
                        }
                        Button("2 hours") {
                            tasksToComplete = selection
                            selection = []
                            withAnimation {
                                editMode.toggle()
                            }
                            isEditable.toggle()
                            timer = 120
                        }
                        
                    } message: {
                        Text("How long would you like to focus?")
                    }
                    Spacer()
                    // This is a workaround because the destructive color won't show up automatically
                    if selection.isEmpty {
                        Button("Delete", role: .destructive) {} // Fake button
                            .disabled(selection.isEmpty)
                    } else {
                        Button {
                            willDeleteTask.toggle()
                        } label: {
                            Text("Delete")
                                .foregroundStyle(Color.red)     // Manually adding red color bc it won't automatically add
                        }
                        .confirmationDialog(selection.count > 1 ? "Delete \(selection.count) Tasks" : "Delete Task", isPresented: $willDeleteTask) {
                            Button(role: .destructive) {
                                for task in selection {
                                    viewContext.delete(task)
                                }
                                taskWasDeleted = true
                                selection = []
                                withAnimation {
                                    editMode.toggle()
                                }
                                isEditable.toggle()
                            } label: { Text(selection.count > 1 ? "Delete \(selection.count) Tasks" : "Delete Task") }
                        } message: {
                            if selection.count > 1 {
                                Text("Are you sure you want to delete these tasks?")
                            } else {
                                Text("Are you sure you want to delete this task?")
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showTaskSheet) {
            TaskSheet(title: "", priority: .none, deadline: Date())
        }
        .alert("Did you complete the following task(s)?", isPresented: $showAlert) {
            Button("Yes") {
                for task in tasksToComplete {
                    viewContext.delete(task)
                }
                taskWasDeleted = true
                tasksToComplete = []
            }
            Button("No") {
                tasksToComplete = []
            }
        } message: { Text(tasksToComplete.map { $0.title }.joined(separator: "\n")) }
        .onDisappear {
            if taskWasDeleted {    // If something was deleted, save when view disappears
                do {
                    try viewContext.save()
                } catch {
                    print("Error deleting items: \(error)")
                }
            }
        }
    }
}

extension Int: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return self
    }
}

struct TimePicker: View {
    let tasks: Set<Task>
    @Binding var timer: Int?
    @Binding var tasksToComplete: Set<Task>
    var body: some View {
        Button("5 minutes") {
            tasksToComplete = tasks
            timer = 5
        }
        Button("10 minutes") {
            tasksToComplete = tasks
            timer = 10
        }
        Button("15 minutes") {
            tasksToComplete = tasks
            timer = 15
        }
        Button("30 minutes") {
            tasksToComplete = tasks
            timer = 30
        }
        Button("1 hour") {
            tasksToComplete = tasks
            timer = 60
        }
        Button("2 hours") {
            tasksToComplete = tasks
            timer = 120
        }
    }
}

private extension TaskView {
    @ViewBuilder func taskMenu(task: Task) -> some View {
        Menu {
            TimePicker(tasks: [task], timer: $timer, tasksToComplete: $tasksToComplete)
        } label: { Label("Start Task", systemImage: "play") }
        Button {
            taskToEdit = task
        } label: { Label("Edit", systemImage: "pencil") }
        Button(role: .destructive) {
            viewContext.delete(task)
            taskWasDeleted = true
        } label: { Label("Delete", systemImage: "trash")}
    }
}
