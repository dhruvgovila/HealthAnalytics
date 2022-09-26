//
//  ContentView.swift
//  HealthAnalytics
//
//  Created by Govila, Dhruv on 25/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @State var steps: Double = 0
    @State var didUpdateSteps = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            if didUpdateSteps {
                Text("Steps Today: \(String(format: "%.0f", steps))")
            } else {
                EmptyView()
            }
        }.onAppear {
            fetchStepsData()
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                break
            case .inactive:
                break
            case .active:
                fetchStepsData()
            @unknown default:
                break
            }
        }
    }
    
    private func fetchStepsData() {
        HealthHelper.shared.askAuthorization { success in
            if success {
                HealthHelper.shared.getTodaysSteps { count in
                    self.steps = count
                    self.didUpdateSteps = true
                    print("Steps Today: \(String(format: "%.0f", steps))")
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
