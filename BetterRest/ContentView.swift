//
//  ContentView.swift
//  BetterRest
//
//  Created by Egor Chernakov on 19.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepTime = 8.0
    @State private var wakeTime = Date()
    
    var body: some View {
        VStack {
            Stepper(value: $sleepTime, in: 4...12, step: 0.25) {
                Text("\(sleepTime, specifier: "%g") hours")
            } .padding()
            
            DatePicker("Select date", selection: $wakeTime, in: Date()..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
