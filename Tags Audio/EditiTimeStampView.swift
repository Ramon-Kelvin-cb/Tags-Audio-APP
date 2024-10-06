//
//  EditiTimeStampView.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//
import SwiftUI

struct EditiTimeStampView: View {
    @Binding var timestamp: TimeStamp
    @Binding var isEditing: Bool
    @ObservedObject var manager: AudioController
    @State private var newName: String = ""
    
    var body: some View {
        VStack{
            TextField("Enter new name", text: $newName)
                .padding()
                .textFieldStyle(.roundedBorder)
            Button("Save") {
                manager.updateTimeStamp(timeStamp: timestamp, newname: newName)
                isEditing.toggle()
            }.padding()
        }.onAppear {
            newName = timestamp.name
        }
        
    }
}
