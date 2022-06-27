//
//  ContentView.swift
//  WeSplit
//
//  Created by Jaejun Shin on 21/4/2022.
//

import SwiftUI

struct ContentView: View {
    
    private let currencyFormatter = FloatingPointFormatStyle<Double>.Currency.currency(code: Locale.current.currencyCode ?? "AUD")
    @State private var check = 0.0
    @State private var people = 0
    @State private var tip = 20
    @FocusState private var amountIsFocused : Bool
    
    let tipPercentages = [0, 10 , 15, 20, 25]
    
    var perPerson: Double {
        let numberOfPeople = Double(people + 2)
        let tipSelected = Double(tip)
        let tipAmount = check / 100 * tipSelected
        
        let totalAmount = check + tipAmount
        let perPerson = totalAmount / numberOfPeople
        return perPerson
    }
    
    var totalAmountWithTip: Double {
        let amount = check + (check / 100 * Double(tip))
        return amount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Check Amount?", value: $check, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("How many people?", selection: $people) {
                        ForEach(2..<100) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section {
                    Picker("How much tip do you want to add?", selection: $tip) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(perPerson, format: currencyFormatter)
                } header: {
                    Text("Amount per Person")
                }
                
                Section {
                    Text(totalAmountWithTip, format: currencyFormatter)
                        .foregroundColor(tip == 0 ? .red : .black)
                } header: {
                    Text("Actual Total Amount")
                }
                
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    } 
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
