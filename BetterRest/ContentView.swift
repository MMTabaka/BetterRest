//
//  ContentView.swift
//  BetterRest
//
//  Created by Milosz Tabaka on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Text(Date.now.formatted(date: .long, time: .standard))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
