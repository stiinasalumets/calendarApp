import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var viewModel: ViewModel
    
    @State private var currentIsOpen = true
    @State private var formerIsOpen = false
    
    init(moc: NSManagedObjectContext) {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
    }
    
    var body: some View {
        ScrollView {
            VStack{
                VStack {
                    Text("Statistics")
                        .font(.largeTitle)
                        .foregroundColor(Color("grey"))
                        .padding(.top)
                    
                }
                
                VStack(alignment: .center, spacing: 4) {
                    Text("Streak")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color("grey"))
                    
                    Text("\(viewModel.habitStreak) days")
                        .font(.system(size: 35, weight: .bold))
                        .bold()
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                
                
                VStack {
                    HStack {
                        Text("Current habits")
                            .font(.title2)
                            .foregroundColor(Color("grey"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            if (currentIsOpen) {
                                currentIsOpen = false
                            } else {
                                currentIsOpen = true
                            }
                        }) {
                            if (currentIsOpen) {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color("grey"))
                                    .font(.title2)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("grey"))
                                    .font(.title2)
                            }
                        }
                        .padding(.trailing)
                    }
                    .background(Color("purple"))
                    
                    if (currentIsOpen) {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.habitStatsActive.sorted(by: { $0.key.title ?? "" < $1.key.title ?? "" }), id: \.key) { habit, percentage in
                                DonutChartView(percentage: percentage, title: habit.title ?? "", color: viewModel.chooseListColor())
                            }
                        }.padding(.top)
                    }
                   
                }.padding(.bottom)
                
                VStack {
                    HStack {
                        Text("Former habits")
                            .font(.title2)
                            .foregroundColor(Color("grey"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            if (formerIsOpen) {
                                formerIsOpen = false
                            } else {
                                formerIsOpen = true
                            }
                        }) {
                            if (formerIsOpen) {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color("grey"))
                                    .font(.title2)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("grey"))
                                    .font(.title2)
                            }
                        }
                        .padding(.trailing)
                    }
                    .background(Color("purple"))
                    
                    if (formerIsOpen) {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.habitStats.sorted(by: { $0.key.title ?? "" < $1.key.title ?? "" }), id: \.key) { habit, percentage in
                                DonutChartView(percentage: percentage, title: habit.title ?? "", color: viewModel.chooseListColor())
                            }
                        }.padding(.top)
                    }
                    
                }
            }
        }
    }
}

