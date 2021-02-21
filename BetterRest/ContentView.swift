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
    @State private var coffee = 1
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessege = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("When do you want to wake up?")
                    .font(.largeTitle)
                
                DatePicker("Select time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(DefaultDatePickerStyle())
                
                Text("How much sleep do you want to get?")
                    .font(.largeTitle)
                
                Stepper(value: $sleepTime, in: 4...12, step: 0.25) {
                    Text("\(sleepTime, specifier: "%g") hours")
                }
                
                Text("How much coffe did you drink?")
                    .font(.largeTitle)
                
                Stepper(value: $coffee, in: 1...20, step: 1) {
                    Text("\(coffee) cup\(coffee == 1 ? "" : "s")")
                }
                
                Spacer()
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing: Button("Calculate", action: calculateBedTime))
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessege), dismissButton: .default(Text("Ok")))
            })
        }
    }
    
    func calculateBedTime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeTime)
        let hours = (components.hour ?? 0) * 3600
        let minutes = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepTime, coffee: Double(coffee))
            let sleepTime = wakeTime - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertTitle = "Your ideal bedtime is..."
            alertMessege = "\(formatter.string(from: sleepTime))"
        } catch {
            alertTitle = "Oopsie"
            alertMessege = "Error occured while calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
