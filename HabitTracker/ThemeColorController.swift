import Foundation
import SwiftUI

class ThemeColorController {
    func randomColorInList(prevColor: String) -> String {
        var newColor = false
        while (!newColor) {
            let color = randomColor()
            
            if (color != prevColor) {
                newColor = true
                return color
            }
        }
    }
    
    func randomColor() -> String {
        let rn = Int.random(in: 0..<4)
        
        switch rn {
        case 0:
            return "blue"

        case 1:
            return "green"

        case 2:
            return "orange"
            
        case 3:
            return "pink"
            
        case 4:
            return "yellow"

        default:
            return "purple"
        }
    }
}
