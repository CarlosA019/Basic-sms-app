//
//  ContentView.swift
//  Twilio-Test
//
//  Created by Carlos Alcala on 7/20/24.
//

import SwiftUI

struct ContentView: View {
    @State private var messlog: [String] = [] // State variable to store log messages

    // Variables
    let lastTextTime = "10:00 PM" // Placeholder for the last text time
    let lastLocation = "Chicago Pub Alley" // Placeholder for the location

    var body: some View {
        VStack {
            Button(action: {
                sendSMS()
            }) {
                Text("Send SMS")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            List {
                ForEach(messlog, id: \.self) { message in
                    Text(message)
                    //for loop to display the messages
                }
                .onDelete(perform: deleteMessage) //swipe to delete functionality
            }
            .padding()
        }
        .onAppear(perform: loadLogMessages) // Load log messages whe open
    }

    func sendSMS() {
        let message = "Carlos might need help. He texted you last at \(lastTextTime). Carlos's location is \(lastLocation)." // message that will be sent
        let twilioService = TwilioService() // starting code on TwilioService
        twilioService.sendSMS(to: "num", message: message) { _ in
            //specific number for twilio to sennd to
            DispatchQueue.main.async {
                messlog.append("Sent message: \(message)")
                saveLogMessages() // code to show and save theeee messg
            }
        }
    }

    func saveLogMessages() {
        // Converting sms to data
        if let encoded = try? JSONEncoder().encode(messlog) {
            UserDefaults.standard.set(encoded, forKey: "logMessages") // Encoding and saving the data
        }
    }

    //saving (userdefaults)
    func loadLogMessages() {
        if let savedLogMessages = UserDefaults.standard.object(forKey: "logMessages") as? Data { // getting back info from user defaults
            if let decodedLogMessages = try? JSONDecoder().decode([String].self, from: savedLogMessages) {
                messlog = decodedLogMessages // Update the logMessages var
            }
        }
    }

    func deleteMessage(at offsets: IndexSet) {
        messlog.remove(atOffsets: offsets)
        saveLogMessages() // this code is for wen the user deletes the message the message will delete from the LogMessages
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
