//
//  Beertistics.swift
//  Beer
//
//  Created by Dylan Kjell Rosenlind on 11/20/25.
//

import SwiftUI
struct Beertistics: View {
    let totalBeers: Int
    let monthBeerCount: Int
    let weekBeerCount: Int

    @State private var randomMessage: String = ""

    private let encouragingMessages = [
        "Keep it up!",
        "You're doing great!",
        "You're a legend!",
        "You're unstoppable!",
        "You're a force to be reckoned with!",
        "You're a true champion!",
        "You're a beer-loving hero!",
        "You're a legend in the making!",
        "You're a true beer enthusiast!",
        "You're a beast!"
    ]

    var body: some View {
        VStack(spacing: 20) {
            
            // This week
            Text("🥺 This Week 😻")
                .font(.largeTitle.bold())
                .padding(.top, 40)
            Text("\(weekBeerCount)")
                .font(.system(size: 50, weight: .heavy))
                .padding()
            
            // This month
            Text("🥸 This Month 📅")
                .font(.largeTitle.bold())
                .padding(.top, 40)
            Text("\(monthBeerCount)")
                .font(.system(size: 50, weight: .heavy))
                .padding()
            
            
            Text("🍻 Total Beers Drank 😮")
                .font(.largeTitle.bold())
                .padding(.top, 40)

            Text("\(totalBeers)")
                .font(.system(size: 50, weight: .heavy))
                .padding()

            Spacer()

            Text(randomMessage)
                .font(.system(size: 24, weight: .medium))
                .padding(.bottom, 40)
        }
        .navigationTitle("Beertistics").bold()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            randomMessage = encouragingMessages.randomElement()!
        }
    }
}
