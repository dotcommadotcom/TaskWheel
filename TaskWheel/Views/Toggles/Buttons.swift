import SwiftUI

struct PriorityButton: View {
    @State private var show: Bool = false
    
    @Binding var priority: PriorityItem
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(priority.background)

            HStack(spacing: 10) {
                Text(priority.text)
                
                Button {
                    priority = .no
                } label: {
                    IconView(icon: .cancel, size: 14)
                }
            }
            .padding(8)
            .padding(.horizontal, 8)
        }
        .fontWeight(.medium)
        .foregroundStyle(Color.text)
        .fixedSize()
        .onTapGesture {
            show.toggle()
        }
        .popPriority(show: $show, input: $priority)
    }
}

struct ScheduleButton: View {
    @State private var show: Bool = false
    
    @Binding var date: Date?
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.text.opacity(0.7), lineWidth: 2)

            HStack(spacing: 10) {
                Text(date?.string() ?? "")
                
                Button {
                    date = nil
                } label: {
                    IconView(icon: .cancel, size: 14)
                }
            }
            .padding(8)
            .padding(.horizontal, 8)
        }
        .fontWeight(.medium)
        .foregroundStyle(Color.text)
        .fixedSize()
        .onTapGesture {
            show.toggle()
        }
        .popSchedule(show: $show, input: $date)
    }
}

#Preview("priority") {
    VStack {
        PriorityButton(priority: .constant(.high))
        PriorityButton(priority: .constant(.medium))
        PriorityButton(priority: .constant(.low))
    }
}

#Preview("priority dark") {
    ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            PriorityButton(priority: .constant(.high))
            PriorityButton(priority: .constant(.medium))
            PriorityButton(priority: .constant(.low))
        }
    }
    .preferredColorScheme(.dark)
}


#Preview("date") {
    ScheduleButton(date: .constant(Date()))
}
