
import Foundation
import SwiftUI

class NavigationStackManager: ObservableObject {
    @Published var stack: [AnyView] = []
    
    func push<V: View>(_ view: V) {
        stack.append(AnyView(view))
    }
    
    func pop() {
        _ = stack.popLast()
    }
    
    func clear() {
        while (stack.count > 0) {
            pop()
        }
    }
}

