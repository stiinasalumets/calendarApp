import Foundation
import SwiftUI

struct HabitViewCard: View {
    var title: String
    var color: String
    
    
    
    var body: some View {
        
        VStack() {
            HStack() {
                    Text(title)
                    .padding()
                    .foregroundColor(Color("grey"))
                    Spacer()
                    Image(systemName: "chevron.right")
                    .padding(.trailing, 10)
                    .foregroundColor(Color("grey"))
                }
        }
        .background(Color(color))
    }
}
