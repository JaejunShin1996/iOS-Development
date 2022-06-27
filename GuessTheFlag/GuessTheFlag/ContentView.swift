//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jaejun Shin on 24/4/2022.
//

import SwiftUI

struct FlagImage: View {
    var flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray, radius: 10, x: 0, y: 0)
    }
}

struct ContentView: View {

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var selectedCountry = ""
    @State private var gamePlayed = 0
    @State private var showingResult = false
    @State private var selectedNumber = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selected: Int?
    
    @State private var rotateDegree: Double = 0.0
    @State private var opacity = 1.0
    @State private var scaleAmount = 1.0
    @State private var isOpaqueScaledDown = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .cyan, location: 0.3),
                .init(color: Color(red: 0.75, green: 0.21, blue: 0.35), location: 0.6)
            ], center: .top, startRadius: 200, endRadius: 500)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.medium))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            print("button\(number) pressed")
                            scoreTracker(number)
                            gamePlayed += 1
                            selectedCountry = countries[number]
                            selectedNumber = number
                            self.selected = number
                            isOpaqueScaledDown = true
                            withAnimation(.interpolatingSpring(stiffness: 10, damping: 7)) {
                                rotateDegree = 360
                            }
                        } label : {
                            FlagImage(flagName: countries[number])
                        }
                        .opacity(isOpaqueScaledDown ? (self.selected == number) ? opacity : opacity - 0.75 : opacity)
                        .scaleEffect(isOpaqueScaledDown ? (self.selected == number) ? scaleAmount : scaleAmount - 0.5 : scaleAmount)
                        .animation(.interpolatingSpring(mass: 1, stiffness: 10, damping: 7, initialVelocity: 6))
                        
                        .rotation3DEffect(.degrees(rotateDegree),
                                          axis: (x: 0,
                                                 y: (self.selected == number) ? 1 : 0,
                                                 z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                Spacer()
                Spacer()
                
                Text("Score: \(score) / \(gamePlayed)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            
        } .alert(scoreTitle, isPresented: $showingScore) {
            Button(gamePlayed != 8 ? "Continue" : "End",
                   action: gamePlayed != 8 ? askQuestion : showingResultAlert)
        } message: {
            if scoreTitle == "Correct" {
                Text("Your score is \(score) / 8")
            } else {
                Text("NO! That's the flag of \(selectedCountry)")
            }
            
        } .alert("End of the Game", isPresented: $showingResult) {
            Button("Restart", action: resetGame)
            Button("End", action: resetGame)
        } message: {
            Text("\(score) out of 8")
        }
    }
    
    func scoreTracker(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.remove(at: selectedNumber)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        isOpaqueScaledDown = false
        opacity = 1.0
        scaleAmount = 1.0
        rotateDegree = 0
    }
    
    func resetGame() {
        score = 0
        gamePlayed = 0
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
        correctAnswer = Int.random(in: 0...2)
        
        isOpaqueScaledDown = false
        opacity = 1.0
        scaleAmount = 1.0
        rotateDegree = 0
    }
    
    func showingResultAlert() {
        showingResult = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
