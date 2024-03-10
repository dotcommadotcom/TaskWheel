import SwiftUI
import DequeModule

struct WheelView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    @State var selected: Int = -1
    @State var rotating: CGFloat = 0.0
    @State var spinAngle: CGFloat = 0.0
    @State var textWidth: CGFloat = 20
    
    private let diameter: CGFloat = 350

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            wheelCircleView()
                .rotationEffect(.degrees(spinAngle))
                .animation(.easeInOut(duration: 4), value: spinAngle)
            
            spinButton()
                .padding(.horizontal, -10)
                .shadow(radius: 3)
        }
        .frame(maxWidth: .infinity)
        .offset(x: -80, y: 0)
        .scaleEffect(1.9)
        .padding()
        .onReceive(taskViewModel.$tasks) { _ in
            self.spinAngle = 0
            self.selected = -1
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
        
        return Text(task.title)
            .lineLimit(1)
            .font(.system(size: 10))
            .visualEffect { content, proxy in
                content
                    .rotationEffect(.degrees(angle))
                    .offset(
                        x: cos(angleRads) * (sizeOffset - proxy.size.width / 2),
                        y: sin(angleRads) * (sizeOffset - proxy.size.width / 2))
            }
            .frame(maxWidth: 80)
            .fontWeight(selected == index ? .bold : .regular)
    }
    
    private func spinButton() -> some View {
        Button {
            selected = Int.random(in: 0..<taskViewModel.currentCount())
            
            withAnimation(.easeInOut(duration: 6)) {
                spinAngle += 360 * 5 + angleDifference(from: selected)
            }
            
        } label: {
            Icon(this: .ticker, size: 15)
        }
    }
}

extension WheelView {

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
