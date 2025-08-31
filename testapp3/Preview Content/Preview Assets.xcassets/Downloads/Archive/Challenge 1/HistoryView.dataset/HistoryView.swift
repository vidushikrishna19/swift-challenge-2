//
//  History.swift
//  Challenge 1
//
//  Created by Sophie Lian on 25/5/25.
//

import SwiftUI

struct History: View {
    @State private var gotonextview = false
    
    @Binding var entries: [Date: [Entry]]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Text("gratitude journal📓")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.mint)
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()],alignment: .center, spacing: 32){
                    Section {
                        ForEach(Array(entries.keys), id: \.self){ i in
                            
                    
                            NavigationLink {
                                
                                Entryview(entriesToShow:entries[i]! )
                            } label: {
                                VStack{
                                    entries[i]![0].picture
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Text(i, format: .dateTime.day().month())
                                        .bold()
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            } }
    }
}
struct ContentView_Previews: PreviewProvider{
    static var previews: some View {
        History(entries: .constant(
            [.now : [
                Entry(picture: Image("Pigeon"), description: "Pigeon", date: Date.now),
                ]
            ]
        ))
    }
}
