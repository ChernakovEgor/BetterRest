//
//  ContentView.swift
//  BetterRest
//
//  Created by Egor Chernakov on 19.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var sleepTime = 8.0
    @State private var wakeTime = defaultWakeTime
    @State private var coffee = 1
    //@State private var idealWakeTime = calculateBedTime()
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessege = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading) {
                Text("Perfect bedtime: ")
                    .font(.largeTitle).bold()
                Text("\(calculateBedTime())")
                    .font(.largeTitle).bold()
            }
            .padding(.top, 25)
            .padding(.leading, 20)

                Form {
                    Section() {
                        Text("When do you want to wake up?")
                            .font(.largeTitle)
                        
                        DatePicker("Select time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section {
                        Text("How much sleep do you want to get?")
                            .font(.largeTitle)
                        
                        Stepper(value: $sleepTime, in: 4...12, step: 0.25) {
                            Text("\(sleepTime, specifier: "%g") hours")
                        }
                    }
                    
                    Picker(selection: $coffee, label: Text("How much coffee did you drink?").font(.largeTitle)) {
                        ForEach(0..<21) { cups in
                            Text("\(cups) cup\(cups == 1 ? "" : "s")")
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
    
    func calculateBedTime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeTime)
        let hours = (components.hour ?? 0) * 3600
        let minutes = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepTime, coffee: Double(coffee))
            let sleepTime = wakeTime - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
        
            return "\(formatter.string(from: sleepTime))"
        } catch {
            return "Oopsie"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
