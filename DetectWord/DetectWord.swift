//
//  DetectWord.swift
//  DetectWord
//
//  Created by Confident Macbook on 2021/2/19.
//

import SwiftUI
struct DetailView: View {
    var model: MyModel
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Graphs").tabItem{Text("Graphs")}
               .tag(1)
            Text("Days").tabItem{Text("Days")}
               .tag(2)
            Text("Summary").tabItem{Text("Summary")}
               .tag(3)
        }
        .onChange(of: selectedTab) { newValue in
                   model.myFunc(item: newValue)
        }
    }
}
