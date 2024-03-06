import SwiftUI

enum TextButtonItem {
    case date(String), priority(PriorityItem)
    
    var text: String {
        switch self {
        case .date(let dateString):
            return dateString
        case .priority(let priority):
            return priority.text
        }
    }
}

struct TextButtonView: View {
    
    let item: TextButtonItem
    
    var body: some View {
        ZStack(alignment: .center) {
            switch item {
            case .date(_):
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.text.opacity(0.7), lineWidth: 2)
            case .priority(let priority):
                RoundedRectangle(cornerRadius: 5)
                    .fill(priority.color.opacity(0.5))
            }
            
            Text(item.text)
                .padding(8)
                .padding(.horizontal, 8)
        }
        .foregroundStyle(Color.text)
        .fixedSize()
    }
}

#Preview("date") {
    TextButtonView(item: .date(Date().string()))
}

#Preview("priority") {
    TextButtonView(item: .priority(.high))
}
