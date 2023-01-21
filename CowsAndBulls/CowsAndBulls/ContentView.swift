//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Alexander on 2023-01-20.
//

import SwiftUI

struct ContentView: View {
  @State private var guess = ""
  @State private var guesses = [String]()
  @State private var answer = ""
  @State private var playerWon = false
  @State private var playerLost = false
  
  @AppStorage("maximumGuesses") var maximumGuesses = 100
  @AppStorage("answerLength") var answerLength = 4
  @AppStorage("enableHardMode") var enableHardMode = false
  @AppStorage("showGuessCount") var showGuessCount = false
  
  func startNewGame() {
    guess = ""
    guesses.removeAll()
    answer = ""
    
    let numbers = (0...9).shuffled()
    for i in 0..<answerLength {
      answer.append(String(numbers[i]))
    }
  }
  
  func submitGuess() {
    guard answerLength >= 3 && answerLength <= 8 else { return }
    guard Set(guess).count == answerLength else {return}
    guard guess.count == answerLength else {return}
    guard !guesses.contains(guess) else {return}
    
    // chars that are not digits
    let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
    guard guess.rangeOfCharacter(from: badCharacters) == nil else {return}
      
    guesses.insert(guess, at: 0)
    if result(for: guess).contains("\(answerLength)b") {
      playerWon = true
    } else if maximumGuesses == guesses.count {
      playerLost = true
    }
    
    guess = ""
  }
  
  func result(for guess: String) -> String {
    var bulls = 0
    var cows = 0
    let guessLetters = Array(guess)
    let answerLetters = Array(answer)
    for (index, letter) in guessLetters.enumerated() {
      if letter == answerLetters[index] {
        bulls += 1
      } else if answerLetters.contains(letter) {
        cows += 1
      }
    }
    
    return "\(bulls)b \(cows)c"
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Enter a guess...", text: $guess).onSubmit(submitGuess) // two-way binding
        Button("Go", action: submitGuess)
      }
      .padding()
      
      List(0..<guesses.count, id: \.self) { index in
        let guess = guesses[index]
        let shouldShowResult = (enableHardMode == false) || (enableHardMode && index == 0)
        
        HStack {
          Text(guess)
          Spacer()
          if shouldShowResult {
            Text(result(for: guess))
          }
        }
      }
      .listStyle(.sidebar)
      
      if showGuessCount {
        Text("Guesses: \(guesses.count)/\(maximumGuesses)")
          .padding()
      }
    }
    .frame(width: 250)
    .frame(minHeight: 300)
    .onAppear(perform: startNewGame)
    .onChange(of: answerLength) { _ in
      startNewGame()
    }
    .alert("You win!", isPresented: $playerWon) {
      Button("OK", action: startNewGame)
    } message: {
      Text("Congratulations, you won in \(guesses.count) tries! Click OK to play again.")
    }
    .alert("You lose!", isPresented: $playerLost) {
      Button("OK", action: startNewGame)
    } message: {
      Text("I'm sorry! Click OK to play again.")
    }
    .navigationTitle("Cows and Bulls")
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
