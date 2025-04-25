import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var viewModel: ViewModel
    
    
    @State private var isCatPerson: Bool = false
    @State private var isDogPerson: Bool = false
    
    @State private var isAddingNew: Bool = false
    @State private var scheduleDate = Date()
    
    init(moc: NSManagedObjectContext, lnManager: LocalNotificationManager) {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc, lnManeger: lnManager))
    }
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding(.top)
                .foregroundColor(Color("grey"))
            
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
                
                Section(header: Text("Notifications")) {
                    if viewModel.lnManager.isGranted {
                        if (!isAddingNew) {
                            
                            if let request = viewModel.lnManager.pendingRequests.first,
                               let trigger = request.trigger as? UNCalendarNotificationTrigger,
                               let hour = trigger.dateComponents.hour,
                               let minute = trigger.dateComponents.minute {

                                HStack() {
                                    Text("Reminder at:")
                                    Spacer()
                                    Text(String(format: "%02d:%02d", hour, minute))
                                }
                            }
                            Button("Change time") {
                                isAddingNew = true
                            }
                        } else {
                            GroupBox {
                                VStack(spacing: 12) {
                                    DatePicker(
                                        "",
                                        selection: $scheduleDate,
                                        displayedComponents: .hourAndMinute
                                    )
                                    .labelsHidden()
                                    .datePickerStyle(.wheel)
                                    .frame(maxWidth: 150) // constrain width
                                    .clipped()
                                    
                                    Button("Save") {
                                        Task {
                                            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduleDate)
                                            let localNotification = LocalNotification(
                                                identifier: UUID().uuidString,
                                                title: "Remember to complete your habits",
                                                body: "You have uncompleted habits, let's get it done",
                                                dateComponents: dateComponents,
                                                repeats: true
                                            )
                                            
                                            viewModel.lnManager.clearRequests()
                                            await viewModel.lnManager.schedule(localNotification: localNotification)
                                            isAddingNew = false
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 10)
                            }
                        }
                    } else {
                        Button("Enable Notifications") {
                            viewModel.lnManager.openSettings()
                        }.buttonStyle(.borderedProminent)
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
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
                
            }
        }
       
    }
    
}

