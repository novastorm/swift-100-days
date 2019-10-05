//
//  ContentView.swift
//  Bullseye HSL
//
//  Created by Adland Lee on 10/4/19.
//  Copyright © 2019 Adland Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var hTarget = Double.random(in: 0..<1)
    @State var sTarget = Double.random(in: 0.15..<1)
    @State var bTarget = Double.random(in: 0.15..<1)
    
    @State var hGuess: Double
    @State var sGuess: Double
    @State var bGuess: Double
    
    @State var showAlert = false
    
    func computeScore() -> Int {
        let hDiff = hGuess - hTarget
        let sDiff = sGuess - sTarget
        let bDiff = bGuess - bTarget
        let diff = sqrt(hDiff * hDiff + sDiff * sDiff + bDiff * bDiff)
        return Int((1.0 - diff) * 100.0 + 0.5)
    }
    
    func resetGame() {
        hTarget = Double.random(in: 0..<1)
        sTarget = Double.random(in: 0.15..<1)
        bTarget = Double.random(in: 0.15..<1)
    }
    
    var body: some View {
        VStack {
            HStack {
                // Target color block
                VStack {
                    Rectangle()
                        .foregroundColor(
                            Color(
                                hue: hTarget,
                                saturation: sTarget,
                                brightness: bTarget,
                                opacity: 1.0
                            )
                        )
                    Text("Match this color")
                }.onAppear {
                    self.resetGame()
                }
                // Guess color block
                VStack {
                    Rectangle()
                        .foregroundColor(
                            Color(
                                hue: hGuess,
                                saturation: sGuess,
                                brightness: bGuess,
                                opacity: 1.0
                            )
                        )
                    HStack {
                        Text("H: \(Int(hGuess * 255.0))")
                        Text("S: \(Int(sGuess * 255.0))")
                        Text("B: \(Int(bGuess * 255.0))")
                    }
                }
            }
            Button(action: {
                self.showAlert = true
            }) {
                Text("Hit Me!")
            }
            .alert(isPresented: $showAlert) {
                let message = """
                    \(computeScore()) / 100
                    H: \(Int(hTarget * 255.0)) S: \(Int(sTarget * 255.0)) B: \(Int(bTarget * 255.0))
                    """
                return Alert(
                    title: Text("Your Score"),
                    message: Text(message),
                    primaryButton: .default(Text("New Game")) {
                        self.resetGame()
                    },
                    secondaryButton: .cancel()
                )
            }
            VStack {
                ColorSlider(label: "H", value: $hGuess, textColor: .white)
                ColorSlider(label: "S", value: $sGuess, textColor: .white)
                ColorSlider(label: "B", value: $bGuess, textColor: .white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(hGuess: 0.5, sGuess: 0.5, bGuess: 0.5)
    }
}

struct ColorSlider: View {
    var label: String
    @Binding var value: Double
    var textColor: Color
    
    var body: some View {
        HStack {
            Button(action: {
                self.value -= 1.0/255
            }) {
                Text("\(label) 0")
                    .foregroundColor(textColor)
                Text("<")
            }
            Slider(value: $value)
            Button(action: {
                self.value += 1.0/255
            }) {
                Text(">")
                Text("255")
                    .foregroundColor(textColor)
            }
        }
    }
}
