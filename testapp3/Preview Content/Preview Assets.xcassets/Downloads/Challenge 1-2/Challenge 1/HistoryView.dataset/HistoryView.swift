//
//  History.swift
//  Challenge 1
//
//  Created by Sophie Lian on 25/5/25.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var entries: [Date: [Entry]]
    
    var body: some View{
     NavigationStack(){
            
            ScrollView{
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()],alignment: .center, spacing: 32){
                    Section{
                        ForEach(Array(entries.keys), id: \.self){ i in
                            
                            
                            
                                    }
                                }
                            }

                            //                        NavigationStack {
                            //                            VStack {
                            //                                NavigationLink {
                            //                                    entries[i]![0].picture
                            //                                        .resizable()
                            //                                        .scaledToFit()
                            //                                    TabView {
                            //                                        entries[i]![0]
                            //                                    }
                            //                                    .tabViewStyle(.page)
                            //
                            //                                } label: {
                            //                                    Text((i, format: .dateTime.day().month())
                            //                                        .bold())
                            //                                }
                            //                            }
                            //
                            //                        }
                            
                            
                            
                NavigationLink(<#LocalizedStringKey#>) {
                    entries[<#Date#>]![0].picture
                                    .resizable()
                                    .scaledToFit()
                                Spacer()
                    
                                Text("tdy was a wonderful day ,i made friend and i did many things in school ,i went to the library and i read a lot")
                                Spacer()
                        
                                
                                label: do {
                                VStack{
                                    entries[<#Date#>]![0].picture
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Text(i format: .dateTime.day().month())
                                        .bold()
                                    
                                }
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(.rect(cornerRadius: 10))
                                
                            }
                            
                            
                            
                        }
                    }
                }
            }
            .navigationTitle("History")
        
        
    

struct ContentView_Previews: PreviewProvider{
    static var previews: some View {
        HistoryView(entries: .constant([.now : [Entry(picture: Image("Party Hat"), description: "Party Hat", date: Date.now)]]), body: <#some View#>)
    }
}
   
