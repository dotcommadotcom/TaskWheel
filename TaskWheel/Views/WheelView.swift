import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = 0
    
    var body: some View {
        HStack(alignment: .center) {
            GeometryReader { geometry in
                HStack {
                    ZStack(alignment: .center) {
                        Circle().fill(.lowBackground)
                            .frame(width: geometry.size.width * 2, height: geometry.size.width * 2)
                        
                        Rectangle().fill(.pink)
                            .frame(width: 5, height: geometry.size.width * 2)
                    }
                    .position(CGPoint(x: 0, y: geometry.size.height / 2))
                    
                    Triangle().fill(.high)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 20, height: 30)
                        .shadow(radius: 4)
                }
            }
            .background(.text.opacity(0.1))
            
            spinButton()
                .padding(25)
        }
    }
    
    private func spinButton() -> some View {
        Button {
            print("spinning")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.accent)
                
                Text("Spin").foregroundStyle(.textAlt)
                    .padding(8)
                    .padding(.horizontal, 8)
            }
            .frame(height: 30)
            .fixedSize()
        }
    }
    
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}


#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
