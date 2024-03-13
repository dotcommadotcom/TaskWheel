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
                    .smallFont()
                
                Button {
                    priority = .no
                } label: {
                    Icon(this: .cancel, size: .xsmall, style: IconOnly()) {}
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
                    .smallFont()
                
                Button {
                    date = .distantPast
                } label: {
                    Icon(this: .cancel, size: .xsmall, style: IconOnly()) {}
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
        ScheduleButton(date: .constant(ago(days: 1)))
        ScheduleButton(date: .constant(Date()))
        ScheduleButton(date: .constant(fromNow(days: 1)))
        ScheduleButton(date: .constant(fromNow(days: 2)))
        ScheduleButton(date: .constant(fromNow(days: 3)))
        ScheduleButton(date: .constant(fromNow(days: 4)))
        ScheduleButton(date: .constant(fromNow(days: 5)))
        ScheduleButton(date: .constant(fromNow(days: 6)))
        ScheduleButton(date: .constant(fromNow(days: 7)))
        ScheduleButton(date: .constant(fromNow(days: 8)))
        ScheduleButton(date: .constant(fromNow(days: 9)))
        ScheduleButton(date: .constant(fromNow(days: 400)))
    }
}

#Preview("past") {
    ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            ScheduleButton(date: .constant(ago(days: 21)))
            ScheduleButton(date: .constant(ago(days: 9)))
            ScheduleButton(date: .constant(ago(days: 7)))
            ScheduleButton(date: .constant(ago(days: 6)))
            ScheduleButton(date: .constant(ago(days: 5)))
            ScheduleButton(date: .constant(ago(days: 4)))
            ScheduleButton(date: .constant(ago(days: 3)))
            ScheduleButton(date: .constant(ago(days: 2)))
            ScheduleButton(date: .constant(ago(days: 1)))
            ScheduleButton(date: .constant(Date()))
        }
    }
    .preferredColorScheme(.dark)
}
