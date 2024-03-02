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
                        .opacity(0.7)
                        .lineLimit(2)
                        .truncationMode(.tail)
    
                    PropertiesRowView(task: task)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .font(.system(size: 23))
        .check(isComplete: task.isDone)
    }
}

struct PropertiesRowView: View {
    
    let sampleProperties: [String] = [
        "due tomorrow 2/24",
        "every week",
        "school",
    ]
    
    let task: TaskModel
    
    let color = ColorSettings()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(sampleProperties, id: \.self) { property in
                    propertyItemView(property: property)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

extension PropertiesRowView {
    
    private func propertyItemView(property: String) -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.accent, lineWidth: 2)
            
            Text(property)
                .padding(7)
        }
        .padding(.vertical, 5)
        .font(.system(size: 17))
        .opacity(0.7)
        .fixedSize()
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


