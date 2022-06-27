//
//  ContentView.swift
//  TimeConversion
//
//  Created by Jaejun Shin on 23/4/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var time: Double = 0
    
    @State private var input = "Second"
    @State private var output = "Second"
    @FocusState private var timeFocused: Bool
    
    var convertedTime: Double {
        switch input {
        case "Second" :
            switch output {
            case "Second" :
                return time
            case "Minute" :
                return time / 60
            case "Hour" :
                return time / 3600
            case "Day" :
                return time / 86400
            default:
                return 0
            }
        case "Minute" :
            switch output {
            case "Second" :
                return time * 60
            case "Minute" :
                return time
            case "Hour" :
                return time / 60
            case "Day" :
                return time / 1440
            default:
                return 0
            }
        case "Hour" :
            switch output {
            case "Second" :
                return time * 3600
            case "Minute" :
                return time * 60
            case "Hour" :
                return time
            case "Day" :
                return time / 24
            default:
                return 0
            }
        case "Day" :
            switch output {
            case "Second" :
                return time * 86400
            case "Minute" :
                return time * 3600
            case "Hour" :
                return time * 24
            case "Day" :
                return time
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    let unit: [String] = ["Second", "Minute", "Hour", "Day"]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Picker("Input Unit", selection: $input) {
                        ForEach(unit, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Input Unit")
                }
                
                Section {
                    Picker("Output Unit", selection: $output) {
                        ForEach(unit, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Output Unit")
                }
                
                Section {
                    TextField("Enter your time", value: $time, format: .number)
                        .keyboardType(.decimalPad)
                        .modifier(TextFieldClearButton(num: $time))
                        .multilineTextAlignment(.leading)
                        .focused($timeFocused)
                        
                } header: {
                    Text("Convert time")
                }
                
                Section {
                    Text(String(format: "%.2f", ceil((convertedTime)*100)/100) + " " + output + "s")
                } header: {
                    Text("Converted Time")
                }
                
            }.navigationTitle("Time Conversion")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            timeFocused = false
                        }
                    }
                }
        }
    }
    
}

struct TextFieldClearButton: ViewModifier {
    @Binding var num: Double
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if num != 0 {
                Button(
                    action: { self.num = 0 },
                    label: {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
