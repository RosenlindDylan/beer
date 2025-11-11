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
    private var beerCount: Int { beerItems.count }
    

    var body: some View {
        NavigationStack {
                VStack(spacing: 12) {
                    // Centered beer count
                    Text("Beers Today: \(beerCount)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity) // ensures centering horizontally

                    Button(action: addBeerItem) {
                        Text("+Add Beer+")
                    }
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
