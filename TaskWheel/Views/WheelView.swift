import SwiftUI
import DequeModule

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = -1
    @State var rotateBy: CGFloat = 0.0

    var wheelTasks: [String] { taskViewModel.currentTasks().map { $0.title } }
    var numSlices: Int { wheelTasks.count }
    var sliceSize: CGFloat { return 360.0 / CGFloat(numSlices) }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            wheelCircleView(diameter: 600)
                .rotationEffect(.degrees(rotateBy))
                .animation(.easeInOut(duration: 4), value: rotateBy)
            
            spinButton()
                .padding(.horizontal, -10)
        }
        .frame(maxWidth: .infinity)
        .offset(x: -150, y: 0)
        .scaledToFit()
        .padding()
    }
}

extension WheelView {
    
    func wheelCircleView(diameter: CGFloat) -> some View {
        ZStack {
            Circle().fill(.gray.opacity(0.2))
            
            ForEach(wheelTasks.indices, id: \.self) { index in
                WheelSegmentView(
                    text: wheelTasks[index],
                    index: index,
                    angle: angle(at: index),
                    textOffset: (0.9 * diameter) / 2,
                    selectedIndex: $selected
                )
            }
        }
        .frame(width: diameter, height: diameter)
    }
    
    private func spinButton() -> some View {
        Button {
            selected = Int.random(in: 0..<numSlices)
            
            withAnimation(.easeInOut(duration: 6)) {
                rotateBy += 360 * 5 + angleDifference(from: selected)
            }
            
        } label: {
            Icon(this: .ticker, size: 20)
        }
    }

    private func angle(at index: Int) -> CGFloat {
        return sliceSize * CGFloat(index)
    }

    private func angleDifference(from index: Int) -> Double {
        let currentAngle = fmod(rotateBy, 360)
        let targetAngle = 360 - Double(selected) * 360.0 / Double(numSlices)
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
    
    var fontSize: CGFloat = 20
    
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
            .frame(maxWidth: 150)
            .fontWeight(selectedIndex == index ? .bold : .regular)
    }
}

#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
