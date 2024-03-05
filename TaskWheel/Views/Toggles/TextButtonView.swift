import SwiftUI

enum TextButtonItem {
    case date(Date), priority(PriorityItem)
    
    var text: String {
        switch self {
        case .date(let date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        case .priority(let priority):
            return priority.text
        }
    }
}

struct TextButtonView: View {
    
    let item: TextButtonItem
    private let color = ColorSettings()
    
    var body: some View {
        ZStack(alignment: .center) {
            switch item {
            case .date(_):
                RoundedRectangle(cornerRadius: 5)
                    .stroke(color.text.opacity(0.7), lineWidth: 2)
            case .priority(let priority):
                RoundedRectangle(cornerRadius: 5)
                    .fill(priority.color.opacity(0.5))
            }
            
            Text(item.text)
                .padding(8)
                .padding(.horizontal, 8)
        }
        .foregroundStyle(color.text)
        .fixedSize()
    }
}

#Preview("date") {
    TextButtonView(item: .date(Date()))
}

#Preview("priority") {
    TextButtonView(item: .priority(.high))
}
