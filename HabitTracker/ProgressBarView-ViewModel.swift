import Foundation
import SwiftUI
import CoreData

extension ProgressBarView {
    class ViewModel: ObservableObject {
        
        private var moc: NSManagedObjectContext
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
        }
    }
}
