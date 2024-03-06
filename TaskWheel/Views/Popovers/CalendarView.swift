import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var calendarVM = CalendarViewModel()
    @State var optionSelected: IconItem? = nil
    
    @Binding var selected: Date?
    @Binding var showSchedule: Bool
    
    private let optionTabs: [IconItem] = [.cancel, .save]
    
    init(selected: Binding<Date?>, showSchedule: Binding<Bool>) {
        self._calendarVM = StateObject(wrappedValue: CalendarViewModel(selectedDate: selected.wrappedValue ?? Date()))
        self._selected = selected
        self._showSchedule = showSchedule
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            monthYearView()
            
            daysView()
            
            weeksView()
            
            calendarBarView()
        }
        .font(.system(size: 18))
        .background(Color.background)
        .foregroundStyle(Color.text)
        .onReceive(calendarVM.datePublisher) { date in
            selected = date
        }
    }
    
}

extension CalendarView {
    
    private func monthYearView() -> some View {
        HStack {
            Button {
                calendarVM.adjustMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Text(calendarVM.monthTitle())
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            
            Button{
                calendarVM.adjustMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .buttonStyle(NoAnimationStyle())
    }
    
    private func daysView() -> some View {
        HStack {
            ForEach(calendarVM.xdays, id: \.self) { xday in
                Text("\(xday)")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text.opacity(0.75))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func weeksView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 22) {
            ForEach(calendarVM.weeks, id: \.self) { week in
                ForEach(week, id: \.self) { day in
                    dayButton(day)
                }
            }
        }
    }
    
    private func dayButton(_ day: Date) -> some View {
        Button {
            selected = day
        } label: {
            ZStack {
                Circle()
                    .fill(selected == day ? Color.text : .clear)
                
                Text("\(calendarVM.calendar.component(.day, from: day))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .opacity(calendarVM.isInMonth(this: day) ? 1 : 0.5)
                    .foregroundColor(selected == day ? Color.background : Color.text)
            }
        }
    }
    
    private func calendarBarView() -> some View {
        BarContainerView(selected: $optionSelected, padding: 10) {
            ForEach(optionTabs, id: \.self) { tab in
                IconView(icon: tab, isSpace: tab == optionTabs.last, size: 20)
                    .onTapGesture {
                        optionSelected = tab
                        
                        if optionSelected == .cancel {
                            clickCancel()
                        } else if optionSelected == .save {
                            clickSave()
                        }
                    }
            }
        }
    }
}

extension CalendarView {
    
    private func clickCancel() {
//        showSchedule.toggle()
//        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickSave() {
//        calendarVM.select(this: selected ?? Date())
//        showSchedule.toggle()
//        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("calendar") {
    CalendarView(selected: .constant(date(2024, 12, 16)), showSchedule: .constant(true))
}

#Preview("dark calendar") {
    CalendarView(selected: .constant(Date()), showSchedule: .constant(true))
        .preferredColorScheme(.dark)
}

