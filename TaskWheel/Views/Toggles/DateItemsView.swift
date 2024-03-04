import SwiftUI

struct DateItemsView: View {
    let date: Date
    
    private var dateItems: [Date] {
        return [date]
    }
    
    private let color = ColorSettings()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(dateItems, id: \.self) { item in
                    dateItemView(item)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

extension DateItemsView {
    private func dateItemView(_ item: Date) -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.accent, lineWidth: 2)
            
            Text(string(from: item))
                .padding(7)
        }
        .padding(.vertical, 5)
        .font(.system(size: 17))
        .opacity(0.7)
        .fixedSize()
    }
    
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DateItemsView(date: Date())
}
