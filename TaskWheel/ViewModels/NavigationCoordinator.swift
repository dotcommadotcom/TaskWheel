import Foundation
import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func goForward(value: any Hashable) {
        path.append(value)
    }
    
    func goBack() {
        path.removeLast()
    }
}
