import SwiftUI
import DequeModule

struct WheelView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    @State var selected: Int = -1
    @State var spinAngle: CGFloat = 0.0
    @State var isSpinDisabled: Bool
    private let diameter: CGFloat = 300
    private let spinVM: SpinViewModel
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        _isSpinDisabled = State(initialValue: taskViewModel.currentCount() == 0)
        self.spinVM = SpinViewModel()
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            wheelCircleView()
                .rotationEffect(.degrees(spinAngle))
            
            spinButton()
                .padding(.horizontal, -10)
                .shadow(radius: 3)
        }
        .frame(maxWidth: .infinity)
        .offset(x: -80, y: 0)
        .scaleEffect(1.9)
        .padding()
        .onReceive(taskViewModel.$tasks) { _ in
            self.selected = -1
            self.spinAngle = 0
            self.isSpinDisabled = taskViewModel.currentCount() == 0
        }
        .onReceive(taskViewModel.$current) { _ in
            self.isSpinDisabled = taskViewModel.currentCount() == 0
        }
        .onLongPressGesture {
            spin()
        }
    }
}

extension WheelView {
    
    private func wheelCircleView() -> some View {
        ZStack {
            Circle().fill(Color.text.opacity(0.1))
            
            ForEach(Array(taskViewModel.currentTasks().enumerated()), id: \.1.id) { index, task in
                sliceView(task: task, index: index)
            }
        }
        .frame(width: diameter, height: diameter)
    }
    
    private func sliceView(task: TaskModel, index: Int) -> some View {
        let sizeOffset: CGFloat = CGFloat(0.9 * diameter / 2)
        let angle = angle(at: index)
        let angleRads = angle * .pi / 180.0
        
        return NavigationLink(value: task) {
            Text(task.title.isEmpty ? "Empty task" : task.title)
        }
        .lineLimit(1)
        .font(.system(size: 10))
        .visualEffect { content, proxy in
            content
                .rotationEffect(.degrees(angle))
                .offset(
                    x: cos(angleRads) * (sizeOffset - proxy.size.width / 2),
                    y: sin(angleRads) * (sizeOffset - proxy.size.width / 2))
        }
        .frame(maxWidth: diameter / 2 * 0.6)
    }
    
    private func spinButton() -> some View {
        Button {
            spin()
        } label: {
            Icon(this: .ticker, size: 15)
        }
        .disabled(isSpinDisabled)
        .foregroundStyle(isSpinDisabled ? Color.text.opacity(0.5) : .accent)
    }
}

extension WheelView {
    
    private func spin() {
        guard !isSpinDisabled else { return }
        
        selected = spinVM.selectRandomIndex(from: taskViewModel.currentTasks())
        
        withAnimation(.easeInOut(duration: 6)) {
            spinAngle += 360 * 5 + angleDifference(from: selected)
        }
    }
    
    private func angle(at index: Int) -> CGFloat {
        return 360.0 / CGFloat(taskViewModel.currentCount()) * CGFloat(index)
    }
    
    private func angleDifference(from index: Int) -> Double {
        let currentAngle = fmod(spinAngle, 360)
        let targetAngle = 360 - Double(selected) * 360.0 / Double(taskViewModel.currentCount())
        return fmod(360 - currentAngle + targetAngle, 360)
    }
}

#Preview {
    WheelView(taskViewModel: TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
