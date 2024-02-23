import SwiftUI

struct UpdateView: View {
    let task: TaskModel
    
    private let colorBackground: Color = .seasaltJet
    private let colorContrast: Color = .jetSeasalt
    private let colorAccent: Color = .crayolaBlue
    
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details."
    private let cornerRadius: CGFloat = 25
    private let sizePadding: CGFloat = 30
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: sizePadding - 10) {
            Text(task.title)
                .font(.system(size: sizeFont * 2))
                .foregroundStyle(.primary)
                .strikethrough(task.isComplete ? true : false)
            PropertiesUpdateView(imageName: "text.alignleft", text: task.details)
            PropertiesUpdateView(imageName: "alarm", text: "date tbd")
            PropertiesUpdateView(imageName: "tag", text: "priority tbd")
            Spacer()
            Text("Delete left Checkmark right")
        }
        .padding(sizePadding)
        .font(.system(size: sizeFont))
        .foregroundStyle(colorContrast)
        .background(colorBackground)
        
    }
}

struct PropertiesUpdateView: View {
    
    let imageName: String
    let input: String
    
    private let sizePadding: CGFloat = 20
    
    init(imageName: String, text: String) {
        self.imageName = imageName
        self.input = text
    }
    
    var body: some View {
        HStack(spacing: sizePadding) {
            Image(systemName: imageName)
            
            Text(input)
                
            Spacer()
        }
    }
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let incomplete = TaskModel(title: "first task", isComplete: false, details: "first task details")
    return UpdateView(task: incomplete)
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let completed = TaskModel(title: "second task", isComplete: true, details: "i'm completed")
    return UpdateView(task: completed)
}
