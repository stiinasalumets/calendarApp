import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var viewModel: ViewModel
    
    @State private var isCatPerson: Bool = false
    @State private var isDogPerson: Bool = false
    
    init(moc: NSManagedObjectContext) {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
    }
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding(.top)
            
            List {
                Section(header: Text("Animal Preference")) {
                    Toggle(isOn: $isCatPerson) {
                        Text("Cat Person")
                    }
                    .onChange(of: isCatPerson) { newValue in
                        if let setting = viewModel.setting.first {
                            setting.catPerson = newValue
                            try? moc.save()
                        }
                    }
                    
                    Toggle(isOn: $isDogPerson) {
                        Text("Dog Person")
                    }
                    .onChange(of: isDogPerson) { newValue in
                        if let setting = viewModel.setting.first {
                            setting.dogPerson = newValue
                            try? moc.save()
                        }
                    }
                }
                
                if let intervalString = viewModel.setting.first?.notificationInterval {
                    let notificationTimes = intervalString.components(separatedBy: ",")
                    
                    Section(header: Text("Notifications")) {
                        ForEach(notificationTimes, id: \.self) { time in
                            Text(time)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // Optional, for a native Settings look
        }
        .onAppear {
            if let setting = viewModel.setting.first {
                isCatPerson = setting.catPerson
                isDogPerson = setting.dogPerson
            }
        }
    }
    
}

