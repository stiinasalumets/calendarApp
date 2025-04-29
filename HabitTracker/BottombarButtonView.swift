import SwiftUI

struct BottombarButtonView: View {
    var image:String
    var isActive:Bool
    
    var body: some View {
        HStack(spacing: 10) {
            
            VStack(spacing: 3) {
                Rectangle()
                    .frame(height: 0)
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isActive ?  .purple : Color("grey"))
            }
        }
    }
}



