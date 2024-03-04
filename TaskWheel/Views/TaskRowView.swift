import SwiftUI

struct TaskRowView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let task: TaskModel
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                taskViewModel.toggleDone(task)
            } label: {
                IconView(icon: .complete, isAlt: task.isDone, size: 22)
                    .foregroundStyle(task.isDone ? .gray : PriorityItem(task.priority).color)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                if !task.details.isEmpty {
                    Text(task.details)
                        .font(.system(size: 17))
                        .opacity(0.9)
                        .lineLimit(2)
                        .truncationMode(.tail)
    
                }
                
                if let date = task.date {
                    DateRowView(date: date)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .font(.system(size: 23))
        .check(isComplete: task.isDone)
    }
}

struct DateRowView: View {
    let date: Date
    
    private var dateItems: [Date] {
        return [date]
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(dateItems, id: \.self) { item in
                    PropertyItemView(item: item)
                }
            }
            .padding(.horizontal, 4)
            .font(.system(size: 17))
        }
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


