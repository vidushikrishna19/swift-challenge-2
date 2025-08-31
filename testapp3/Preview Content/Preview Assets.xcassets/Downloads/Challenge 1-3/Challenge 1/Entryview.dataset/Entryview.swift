//
//  Entryview.swift
//  Challenge 1
//
//  Created by Shivanishri on 3/6/25.
//

import SwiftUI

struct Entryview: View {
    @State var entriesToShow: [Entry]
    var body: some View {
        VStack {
            TabView {
                
                ForEach(entriesToShow) { entry in
                    VStack {   Text(entry.description)
                            .padding()
                        entry.picture
                            .resizable()
                            .scaledToFit()}
                        
                    }
                    
            }  .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

#Preview {
    Entryview(entriesToShow:  [
        Entry(picture: Image("Party Hat"), description: "tdy was a wonderful day ,i made friend and i did many things in school ,i went to the library and i read a lot", date: Date()),
        Entry(picture: Image("Party Hat"), description: "SECOND ENTRY", date: Date())
    ])
}
