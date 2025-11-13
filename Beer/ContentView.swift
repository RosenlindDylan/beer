//
//  ContentView.swift
//  Beer
//
//  Created by Travis Hand on 11/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var beerItems: [BeerItem]
    
    @Query(
        filter: #Predicate<BeerItem> { beer in
            beer.timestamp >= todayRange.lowerBound &&
            beer.timestamp < todayRange.upperBound
        },
        sort: \.timestamp,
        order: .reverse
    ) private var todayBeers: [BeerItem]
    
    private var beerCount: Int { beerItems.count }
    private var todayCount: Int {todayBeers.count}
    

    var body: some View {
        NavigationStack {
                VStack(spacing: 12) {
                    // Centered beer count
                    Text("Beers Today: \(todayCount)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity) // ensures centering horizontally
                    Text("Total Beers Drank: \(beerCount)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity)

                    Button(action: addBeerItem) {
                        Text("Drank A Beer")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .navigationTitle("Beer Counter 🍻")
                .navigationBarTitleDisplayMode(.inline)
            }

    }

    private func addBeerItem() {
        withAnimation {
            let beerItem = BeerItem(timestamp: Date())
            modelContext.insert(beerItem)
        }
    }
    
    static var todayRange: Range<Date> = {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        return start..<end
    }()
    
    

    
    
    // don't need delete
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: BeerItem.self, inMemory: true)
}
