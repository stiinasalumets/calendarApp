import Foundation
import SwiftUI

struct HabitViewCard: View {
    var title: String
    
    var body: some View {
        
        VStack() {
            HStack() {
                    Text(title)
                    .padding()
                    Spacer()
                    Image(systemName: "chevron.right")
                    .padding(.trailing, 10)
                }
        }
            .background(Color("purple"))
    }
}
