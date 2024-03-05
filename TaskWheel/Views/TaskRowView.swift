import SwiftUI

struct TaskRowView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let task: TaskModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 10) {
                Button {
                    taskViewModel.toggleDone(task)
                } label: {
                    IconView(icon: .complete, isAlt: task.isDone, size: 22)
                        .foregroundStyle(task.isDone ? .gray : PriorityItem(task.priority).color)
                }
                
                Text(task.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            VStack(alignment: .leading) {
                if !task.details.isEmpty {
                    Text(task.details)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .fontWeight(.light)

                }
                
                if let date = task.date {
                    let dateTextButton: TextButtonItem = .date(date)
                    TextButtonView(item: dateTextButton)
                        .frame(height: 30)
                }
            }
            .padding(.leading, 30)
            .font(.system(size: 20))
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .font(.system(size: 23))
        .check(isComplete: task.isDone)
    }
}

struct TaskRowModifier: ViewModifier {
    let isComplete: Bool
    let color = ColorSettings()
    
    func body(content: Content) -> some View {
        if isComplete {
            return AnyView(content.strikethrough().foregroundStyle(color.text.opacity(0.5)))
        } else {
            return AnyView(content.foregroundStyle(color.text))
        }
    }
}

extension View {
    func check(isComplete: Bool) -> some View {
        self
            .modifier(TaskRowModifier(isComplete: isComplete))
    }
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let color = ColorSettings()
    let incomplete = TaskModel(title: "incomplete task", isComplete: false, details: "i'm not completed", priority: 3)
    
    return ZStack {
        color.background.ignoresSafeArea()
        
        TaskRowView(task: incomplete)
    }
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let color = ColorSettings()
    let complete = TaskModel(title: "completed task", isComplete: true, details: "i'm completed")
    
    
    return ZStack {
        color.background.ignoresSafeArea()
        
        TaskRowView(task: complete)
            .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
    }
    .preferredColorScheme(.dark)
}


