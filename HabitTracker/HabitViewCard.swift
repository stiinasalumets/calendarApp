import Foundation
import SwiftUI

struct HabitViewCard: View {
    var title: String
    
    var body: some View {
        
        HStack() {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }.padding()
            .background(Color("purple"))
    }
}
