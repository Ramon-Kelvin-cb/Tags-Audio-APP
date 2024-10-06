//
//  Tags.swift
//  Tags Audio
//
//  Created by Ramon Kelvin on 01/10/24.
//

import SwiftUI
import SwiftData

@Model
class TimeStamp: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var time: Double
    var timeMark: String
    
    init(name: String, time: Double, timeMark: String) {
        self.name = name
        self.time = time
        self.timeMark = timeMark
    }
}

@Model
class Music: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var path: String
    var timeStamps: [TimeStamp]
    
    init(name: String, path: String, timeStamps: [TimeStamp] = []) {
        self.name = name
        self.path = path
        self.timeStamps = timeStamps
    }
}

struct TimeStampRow: View {
    var timeStamp: TimeStamp
    var body: some View {
        HStack{
            Text(self.timeStamp.name)
            Spacer()
            Text(self.timeStamp.timeMark)
        }
    }
}

