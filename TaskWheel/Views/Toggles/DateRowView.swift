import SwiftUI

enum PropertyItem: Identifiable {
    case date, priority
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .date: return "Rename list"
        case .priority: return "Set as default"
        }
    }
    
}

struct PropertyItemView: View {
    
    let item: Date
    private let color = ColorSettings()
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .stroke(color.text.opacity(0.7), lineWidth: 2)
            
            Text(string(from: item))
                .padding(8)
                .padding(.horizontal, 8)
        }
        .foregroundStyle(color.text)
        .opacity(0.9)
        .fixedSize()
    }
    
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DateRowView(date: Date())
}
