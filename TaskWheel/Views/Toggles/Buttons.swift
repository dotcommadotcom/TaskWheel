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
                    Icon(this: .cancel, size: 14)
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
                Text(date?.relative() ?? "")
                    .foregroundStyle(isPast(date) ? Color.past : Color.text)
                
                Button {
                    date = .distantPast
                } label: {
                    Icon(this: .cancel, size: 14)
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
    
    private func isPast(_ date: Date?) -> Bool {
        if let date = date {
            return date.isPast()
        }
        return false
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


#Preview("future") {
    VStack {
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -1, to: Date())!))
        ScheduleButton(date: .constant(Date()))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 1, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 2, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 3, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 4, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 5, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 6, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 7, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 8, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 9, to: Date())!))
        ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: 400, to: Date())!))
    }
}

#Preview("past") {
    ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -21, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -9, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -7, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -6, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -5, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -4, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -3, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -2, to: Date())!))
            ScheduleButton(date: .constant(Calendar.current.date(byAdding: .day, value: -1, to: Date())!))
            ScheduleButton(date: .constant(Date()))
        }
    }
    .preferredColorScheme(.dark)
}
