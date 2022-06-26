//
//  ContentView.swift
//  BetterRest
//
//  Created by Milosz Tabaka on 24/06/2022.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var bedtime = "10:38 PM"
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Spacer()
                    }
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section {
                    Picker(coffeeAmount == 1 ? "1 cup": "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text($0, format: .number)
                        }
                    }
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text(bedtime)
                            .font(.largeTitle)
                        Spacer()
                    }
                } header: {
                    Text("Recommended bedtime")
                        .font(.headline)
                }
            }
            .navigationTitle("BetterRest")
            .onChange(of: wakeUp) { newValue in
                calculateBedtime()
            }
            .onChange(of: sleepAmount) { newValue in
                calculateBedtime()
            }
            .onChange(of: coffeeAmount) { newValue in
                calculateBedtime()
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            bedtime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            bedtime = "Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
