import SwiftUI

struct AddSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String = ""
    @State var detailsInput: String = ""
    @State var priorityInput: Int = 3
    @State var dateInput: Date?
    
    @State private var showDetails = false
    @State private var showSchedule = false
    @State private var isPriorityReset = false
    @State private var sheetHeight: CGFloat = .zero
    
    private let color = ColorSettings()
    private let iconSize: CGFloat = 22
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            TextField(textDefault, text: $titleInput, axis: .vertical)
                .lineLimit(20)
            
            if showDetails {
                TextField(detailDefault, text: $detailsInput, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: 17))
            }
            
            addBarView()
                .buttonStyle(NoAnimationStyle())
                
        }
        .fixedSize(horizontal: false, vertical: true)
        .onSubmit { clickSave() }
    }
    
}

extension AddSheetView {
    
    private func addBarView() -> some View {
        HStack(spacing: 30) {
            detailsButton()
            
            scheduleButton()
            
            priorityButton()
            
            saveButton()
        }
    }
    
    private func detailsButton() -> some View {
        Button {
            showDetails.toggle()
        } label: {
            IconView(icon: .details, size: iconSize)
        }
        .foregroundStyle(!detailsInput.isEmpty ? color.accent : color.text)
    }
    
    private func scheduleButton() -> some View {
        Button {
            showSchedule.toggle()
        } label: {
            IconView(icon: .schedule, size: iconSize)
        }
        .foregroundStyle(dateInput == nil ? color.text : color.accent)
        .popover(isPresented: $showSchedule) {
            VStack(alignment: .leading, spacing: 22) {
                CalendarView(selected: $dateInput, showSchedule: $showSchedule)
            }
            .font(.system(size: 22))
            .padding(30)
            .presentSheet($sheetHeight)
        }
    }
    
    private func priorityButton() -> some View {
        Button {
            priorityInput = (priorityInput + 3) % 4
        } label: {
            IconView(icon: .priority, isAlt: priorityInput != 3, size: iconSize)
        }
        .foregroundStyle(PriorityItem(priorityInput).color)
        .padding(.vertical, 8)
        .onLongPressGesture(minimumDuration: 1) {
            priorityInput = 3
        }
    }
    
    private func saveButton() -> some View {
        Button {
            clickSave()
        } label: {
            IconView(icon: .save, isSpace: true, size: iconSize)
        }
        .disabled(isTaskEmpty() ? true : false)
        .foregroundStyle(isTaskEmpty() ? .gray : color.text)
    }
}

extension AddSheetView {
    
    private func clickSave() {
        taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput, date: dateInput)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty && priorityInput == 3 && dateInput == nil
    }
    
}



#Preview("empty", traits: .sizeThatFitsLayout) {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView()
            .padding(30)
            .background(.white)
    }
    .environmentObject(TaskViewModel())
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: "Hello, World!", detailsInput: "Hiya", priorityInput: 1)
            .padding(30)
            .background(.white)
    }
    .environmentObject(TaskViewModel())
}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: String(repeating: longText, count: 5),
                     detailsInput: String(repeating: longText, count: 3))
    }
    .environmentObject(TaskViewModel())
}


