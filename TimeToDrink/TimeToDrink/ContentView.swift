//
//  ContentView.swift
//  TimeToDrink
//
//  Created by Jaejun Shin on 13/8/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("waterConsumed") private var waterConsumed = 0.0
    @AppStorage("waterRequired") private var waterRequired = 2000.0
    @AppStorage("useMetricUnits") private var useMetricUnits = true
    
    @AppStorage("lastDrink") private var lastDrink = Date.now.timeIntervalSinceReferenceDate
    
    @State private var showingGoalSlider = false
    @State private var showingDrinkMenu = false
    
    let mlToOz = 0.0351952
    let OzToMl = 29.5735
    
    var goalProgress: Double {
        waterConsumed / waterRequired
    }
    
    var statusText: Text {
        if useMetricUnits {
            return Text("\(Int(waterConsumed))ml / \(Int(waterRequired))ml")
        } else {
            let adjustedConsumed = waterConsumed * mlToOz
            let adjustedRequired = waterRequired * mlToOz
            return Text("\(Int(adjustedConsumed))oz / \(Int(adjustedRequired))oz")
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan, .blue], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                statusText
                    .font(.largeTitle)
                    .padding(.top)
                    .onTapGesture {
                        withAnimation {
                            showingGoalSlider.toggle()
                        }
                    }
                
                if showingGoalSlider {
                    VStack {
                        Text("Adjust Goal")
                            .font(.headline)
                        
                        Slider(value: $waterRequired, in: 500...4000)
                            .tint(.white)
                    }
                    .padding()
                }
                
                Image(systemName: "drop")
                    .resizable()
                    .font(.title.weight(.ultraLight))
                    .scaledToFit()
                    .background(
                        Rectangle()
                            .fill(.white)
                            .scaleEffect(x: 1, y: goalProgress, anchor: .bottom)
                    )
                    .mask {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .font(.title.weight(.ultraLight))
                            .scaledToFit()
                    }
                    .padding()
                    .onTapGesture {
                        showingDrinkMenu.toggle()
                    }
                
                Toggle("Use Metric Units", isOn: $useMetricUnits)
                    .padding()
            }
        }
        .foregroundColor(.white)
        .alert("Add Drink", isPresented: $showingDrinkMenu) {
            if useMetricUnits {
                ForEach([200, 300, 400, 500], id: \.self) { number in
                    Button("\(number)ml") { add(Double(number)) }
                }
            } else {
                ForEach([8, 12, 16, 20, 24], id: \.self) { number in
                    Button("\(number)oz") { add(Double(number) * OzToMl)}
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { output in
            checkForReset()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { output in
            checkForReset()
        }
        .onChange(of: waterConsumed) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: waterRequired) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func add(_ amount: Double) {
        lastDrink = Date.now.timeIntervalSinceReferenceDate
        waterConsumed += amount
    }
    
    func checkForReset() {
        let lastChecked = Date(timeIntervalSinceReferenceDate: lastDrink)
        
        if Calendar.current.isDateInToday(lastChecked) == false {
            waterConsumed = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
