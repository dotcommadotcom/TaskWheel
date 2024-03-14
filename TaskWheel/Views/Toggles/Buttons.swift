import SwiftUI

struct RoundedButton: View {
    let text: String
    let tap: () -> Void
    let action: () -> Void
    
    var textColor: Color
    var strokeColor: Color
    var fillColor: Color
    
    init(
        _ text: String,
        textColor: Color = Color.text,
        strokeColor: Color = Color.text.opacity(0.7),
        fillColor: Color = Color.clear,
        tap: @escaping () -> Void,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.textColor = textColor
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.tap = tap
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(text).smallFont()
            
            Button(action: action) {
                Icon(this: .cancel, size: .xsmall, style: IconOnly()) {}
            }
        }
        .padding(8).padding(.horizontal, 8)
        .fixedSize()
        .fontWeight(.medium)
        .foregroundStyle(textColor)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(fillColor)
                .stroke(strokeColor, lineWidth: 2)
        )
        .onTapGesture {
            tap()
        }
    }
}

#Preview("rounded") {
    VStack {
        RoundedButton("this is me") {
            print("show!")
        } action: {
            print("cancel!")
        }
    }
}

#Preview("priority") {
    let priorities: [PriorityItem] = [.high, .medium, .low]
    
    return VStack {
        ForEach(priorities, id: \.self) { priorityInput in
            RoundedButton(
                priorityInput.text,
                strokeColor: priorityInput.color,
                fillColor: priorityInput.background,
                tap: {},
                action: {}
            ) 
        }
    }
}

#Preview("priority dark") {
    let priorities: [PriorityItem] = [.high, .medium, .low]
    
    return ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            ForEach(priorities, id: \.self) { priorityInput in
                RoundedButton(
                    priorityInput.text,
                    strokeColor: priorityInput.color,
                    fillColor: priorityInput.background,
                    tap: {},
                    action: {}
                )
            }
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("future") {
    let dates: [Date] = [
        ago(days: 1),
        Date(),
        fromNow(days: 1),
        fromNow(days: 2),
        fromNow(days: 3),
        fromNow(days: 4),
        fromNow(days: 5),
        fromNow(days: 6),
        fromNow(days: 7),
        fromNow(days: 8),
        fromNow(days: 9),
        fromNow(days: 400)
    ]
    
    return VStack {
        ForEach(dates, id: \.self) { dateInput in
            RoundedButton(
                dateInput.relative(),
                textColor: dateInput.isPast() ? Color.past : Color.text,
                tap: {},
                action: {}
            )
        }
    }
}

#Preview("past") {
    let dates: [Date] = [
        ago(days: 21),
        ago(days: 9),
        ago(days: 7),
        ago(days: 5),
        ago(days: 4),
        ago(days: 3),
        ago(days: 2),
        ago(days: 1),
        Date(),
        fromNow(days: 1)
    ]
    
    return ZStack {
        Color.background.ignoresSafeArea()
        
        VStack {
            ForEach(dates, id: \.self) { dateInput in
                RoundedButton(
                    dateInput.relative(),
                    textColor: dateInput.isPast() ? Color.past : Color.text,
                    tap: {},
                    action: {}
                )
            }
        }
    }
    .preferredColorScheme(.dark)
}
