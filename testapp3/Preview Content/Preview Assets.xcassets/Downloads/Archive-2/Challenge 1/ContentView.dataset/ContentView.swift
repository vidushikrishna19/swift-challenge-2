//
//  ContentView.swift
//  Challenge 1
//
//  Created by Sophie Lian on 25/5/25.
//

import SwiftUI

struct ContentView: View {
    @State var entries: [Date: [Entry]] = [:]
    
    var body: some View {
        TabView{
            Tab("Today",systemImage: "face.smiling"){
                TodayView(entries: $entries)
            }
            Tab("History",systemImage: "calendar"){
                History(entries: $entries)
            }
        }
    }
}
struct Entry: Identifiable{
    let id = UUID()
    var picture: Image
    var description: String
    var date: Date
}

#Preview {
    ContentView()
}
