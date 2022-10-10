//
//  ContentView.swift
//  Calculator
//
//  Created by Jaejun Shin on 10/10/2022.
//

import SwiftUI

enum CalculatorButton: String {
    case zero, one, two, three, four, five, six, seven, eight, nine, dot
    case divide, multiply, minus, plus, equal
    case ac, plusMinus, percent

    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two:return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .divide: return "%"
        case .multiply: return "x"
        case .minus: return "-"
        case .plus: return "+"
        case .equal: return "="
        case .ac: return "AC"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .dot: return "."
        }
    }

    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .dot:
            return Color(.lightGray)
        case .divide, .multiply, .minus, .plus, .equal:
            return Color(.orange)
        default:
            return Color(.darkGray)
        }
    }
}

struct ContentView: View {
    let buttonsArry: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equal]
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.black)
                .ignoresSafeArea(.all)

            VStack(spacing: 12) {
                HStack {
                    Spacer()

                    Text("99")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }
                .padding()

                ForEach(buttonsArry, id: \.self) { buttons in
                    HStack(spacing: 12) {
                        ForEach(buttons, id: \.self) { button in
                            Text(button.title)
                                .foregroundColor(.white)
                                .font(.system(size: 32))
                                .frame(width: buttonWidth(button), height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                                .background(button.backgroundColor)
                                .cornerRadius(buttonWidth(button))
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }

    func buttonWidth(_ button : CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 3 * 12) / 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
