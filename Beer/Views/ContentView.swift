//
//  ContentView.swift
//  Beer
//
//  Created by Travis Hand on 11/8/25.
//
//

import SwiftUI
import SwiftData
import Combine
import VisionKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    // this happens in memory, could become tech debt issue
    // better format for testing than prev but revisit this
    @Query(sort: \BeerItem.timestamp, order: .reverse) private var beerItems: [BeerItem]

    private var todayBeers: [BeerItem] {
        let r = DateRanges.today(now: Date())
        return beerItems.filter { r.contains($0.timestamp) }
    }

    private var weekBeers: [BeerItem] {
        let r = DateRanges.thisWeek(now: Date())
        return beerItems.filter { r.contains($0.timestamp) }
    }

    private var monthBeers: [BeerItem] {
        let r = DateRanges.thisMonth(now: Date())
        return beerItems.filter { r.contains($0.timestamp) }
    }

    private var beerCount: Int { beerItems.count }
    private var monthCount: Int { monthBeers.count }
    private var weekCount: Int { weekBeers.count }
    private var todayCount: Int { todayBeers.count }

    @State private var cooldown = 0
    let cooldownSeconds = 60

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var isShowingScanner = false
    @State private var scannedText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                
                VStack(spacing: 4) {
                    Text("🍺 Beer Counter")
                        .font(.largeTitle.bold())
                        .padding(.top, 20)

                    Text("Today: \(todayCount)")
                        .font(.title2.weight(.semibold))
                }


                Spacer()

                // Beer button
                Button(action: addBeerItem) {
                    VStack {
                        Image(systemName: "mug.fill")
                            .font(.system(size: 40))
                            .padding(.bottom, 4)

                        Text(cooldown == 0 ? "Add Beer 😎" : "Wait \(cooldown)s 🥶")
                            .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                }
                .buttonStyle(.borderedProminent)
                .tint(cooldown == 0 ? .blue : .gray)
                .disabled(cooldown > 0)
                .padding(.horizontal)
                
                Spacer()


                // Navigation
                NavigationLink("View Total Beers →") {
                    Beertistics(totalBeers: beerCount, monthBeerCount: monthCount, weekBeerCount: weekCount)
                }
                .font(.headline)
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
        .onAppear { restoreCooldown() }
        .onReceive(timer) { _ in tick() }
        .fullScreenCover(isPresented: $isShowingScanner) {
            BarcodeScannerView(
                isShowingScanner: $isShowingScanner,
                scannedText: $scannedText)
        }
    }

    // Cooldown logic
    private func tick() {
        if cooldown > 0 {
            cooldown -= 1
            if cooldown == 0 {
                UserDefaults.standard.removeObject(forKey: "lastBeerTimestamp")
            }
        }
    }

    private func restoreCooldown() {
        if let last = UserDefaults.standard.object(forKey: "lastBeerTimestamp") as? Date {
            let elapsed = Int(Date().timeIntervalSince(last))
            let remain = cooldownSeconds - elapsed
            if remain > 0 {
                cooldown = remain
            } else {
                cooldown = 0
            }
        }
    }

    private func addBeerItem() {
        guard cooldown == 0 else { return }

        withAnimation {
            let beer = BeerItem(timestamp: Date())
            modelContext.insert(beer)

            // Set cooldown - this is required so it persists on app close
            cooldown = cooldownSeconds
            UserDefaults.standard.set(Date(), forKey: "lastBeerTimestamp")
            isShowingScanner = true
        }
    }
}
