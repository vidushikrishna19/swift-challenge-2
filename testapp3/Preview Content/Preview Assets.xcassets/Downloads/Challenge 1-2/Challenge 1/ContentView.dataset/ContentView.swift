//
//  ContentView.swift
//  Challenge 1
//
//  Created by Shivani shri on 25/5/25.
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
                HistoryView(entries: $entries, body: <#some View#>)
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
