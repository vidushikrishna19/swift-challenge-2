//
//  Today.swift
//  Challenge 1
//
//  Created by Sophie Lian on 25/5/25.
//

import SwiftUI
import PhotosUI

struct TodayView: View {
    @Binding var entries: [Date: [Entry]]
    @State private var showPicker = false
    @State private var selectedEntry: UUID?
    
    
    var todayEntries: [Entry]{
        entries[Calendar.current.startOfDay(for: Date())] ?? []
    }
    
    
    var body: some View {
       
        TabView (selection: $selectedEntry){
            ForEach(todayEntries) { todayEntry in
                VStack{
                    todayEntry.picture
                        .resizable()
                        .scaledToFit()
                    let bindingEntry = Binding {
                        todayEntry
                    } set: { newValue in
                        var copyTodayEntries = todayEntries
                        let entryIndex = copyTodayEntries.firstIndex { entry in
                            entry.id == todayEntry.id
                        }
                        copyTodayEntries[entryIndex!] = newValue
                        let entryDate = Calendar.current.startOfDay(for: Date())
                        entries[entryDate] = copyTodayEntries
                    }
                    PhotoPickerView(selectedItem: bindingEntry.picture)
                    TextEditor(text:bindingEntry.description)
                    
                }
                .tag(todayEntry.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
        Button {
            withAnimation {
                print("Button tapped!")
                let newEntry = Entry(picture: Image("Flying Hat"), description:"Flying Hat", date: Date())
                var copyTodayEntries = todayEntries
                copyTodayEntries.append(newEntry)
                let entryDate = Calendar.current.startOfDay(for: Date())
                entries[entryDate] = copyTodayEntries
                selectedEntry = newEntry.id
            }
            
            
            
        } label: {
            Image(systemName: "plus.app.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
        }
    }
}

struct PhotoPickerView: View{
    @State private var selectedImage: PhotosPickerItem?
    @Binding var selectedItem: Image
    
    
    var body: some View {
        VStack{
            PhotosPicker("Change Image", selection: $selectedImage, matching: .images)
            
           
        }
        .onChange (of: selectedImage){
            Task {
                if let loaded = try? await selectedImage?.loadTransferable(type: Image.self) {
                    selectedItem = loaded
                    print("Success!")
                } else {
                    print("Failed")
                }
            }
        }
    }
}
#Preview {
    @Previewable @State var entries = [Calendar.current.startOfDay(for: Date()): [Entry(picture: Image("Pigeon"),                                                          description: ("Pigeon"),                                                  date: Date()),
                                                                                  Entry(picture: Image("Party Hat"),
                                                                                        description: ("Party Hat"),
                                                                                        date: Date())]]
    TodayView(entries: $entries)
}

