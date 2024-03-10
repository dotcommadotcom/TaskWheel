import SwiftUI
import DequeModule

struct WheelView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    @State var selected: Int = -1
    @State var rotating: CGFloat = 0.0
    @State var spinAngle: CGFloat = 0.0
    @State var textWidth: CGFloat = 20

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            wheelCircleView(diameter: 300)
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
    
    private func wheelCircleView(diameter: CGFloat) -> some View {
        ZStack {
            Circle().fill(Color.text.opacity(0.1))
            
            ForEach(Array(taskViewModel.currentTasks().enumerated()), id: \.1.id) { index, task in
                let textOffset: CGFloat = CGFloat((0.9 * diameter) / 2.0)
                let angle = angle(at: index)
                let xOffset = cos(angle * .pi / 180.0) * (textOffset - textWidth / 2.0)
                let yOffset = sin(angle * .pi / 180.0) * (textOffset - textWidth / 2.0)
                
                Text(task.title)
                    .lineLimit(1)
                    .font(.system(size: 10))
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    textWidth = proxy.size.width
                                }
                        }
                    }
                    .rotationEffect(.degrees(angle))
                    .offset(x: xOffset, y: yOffset)
                    .frame(maxWidth: 80)
                    .fontWeight(selected == index ? .bold : .regular)
//                sliceView(task: task, index: index, diameter: diameter)
            }
        }
        .frame(width: diameter, height: diameter)
    }
    
//    private func sliceView(task: TaskModel, index: Int, diameter: CGFloat) -> some View {
//        
//    }
    
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

    private func angle(at index: Int) -> CGFloat {
        return 360.0 / CGFloat(taskViewModel.currentCount()) * CGFloat(index)
    }

    private func angleDifference(from index: Int) -> Double {
        let currentAngle = fmod(spinAngle, 360)
        let targetAngle = 360 - Double(selected) * 360.0 / Double(taskViewModel.currentCount())
        return fmod(360 - currentAngle + targetAngle, 360)
    }
}

struct WheelSegmentView: View {
    
    @State var text: String
    @State var index: Int
    @State var angle: CGFloat
    @State var textOffset: CGFloat
    @State var textWidth: CGFloat = 20
    
    @Binding var selectedIndex: Int
    
    var fontSize: CGFloat = 10
    
    var body: some View {
        let xOffset = cos(angle * .pi / 180.0) * (textOffset - textWidth / 2.0)
        let yOffset = sin(angle * .pi / 180.0) * (textOffset - textWidth / 2.0)
        
        Text(text)
            .lineLimit(1)
            .font(.system(size: fontSize))
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            textWidth = proxy.size.width
                        }
                }
            }
            .rotationEffect(.degrees(angle))
            .offset(x: xOffset, y: yOffset)
            .frame(maxWidth: 80)
            .fontWeight(selectedIndex == index ? .bold : .regular)
    }
}

#Preview {
    WheelView(taskViewModel: TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
