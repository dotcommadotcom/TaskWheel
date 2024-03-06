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
    
    let date: Date?
    let priority: PriorityItem
    let isDate: Bool
    private let text: String
    
    init(date: Date?, priority: PriorityItem?, isDate: Bool = false) {
        self.date = date ?? nil
        self.priority = priority ?? PriorityItem(3)
        self.isDate = isDate
        
        if isDate {
            self.text = date?.string() ?? ""
        } else {
            self.text = priority?.text ?? ""
        }
    }
    
    init(date: Date) {
        self.init(date: date, priority: nil, isDate: true)
    }
    
    init(priority: PriorityItem) {
        self.init(date: nil, priority: priority)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(isDate ? Color.clear : priority.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.text.opacity(0.7), lineWidth: 2)
                        .opacity(isDate ? 1 : 0) 
                )

            Text(text)
                .padding(8)
                .padding(.horizontal, 8)
        }
        .fontWeight(.medium)
        .foregroundStyle(Color.text)
        .fixedSize()
    }
}

#Preview("date") {
    TextButtonView(date: Date())
}

#Preview("priority") {
    VStack {
        TextButtonView(priority: .high)
        TextButtonView(priority: .medium)
        TextButtonView(priority: .low)
    }
}

#Preview("priority dark") {
    ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            TextButtonView(priority: .high)
            TextButtonView(priority: .medium)
            TextButtonView(priority: .low)
        }
    }
    .preferredColorScheme(.dark)
}
