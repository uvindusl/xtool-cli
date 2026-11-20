//
//  ContentView.swift
//  {{APP_NAME}}
//
//  Created by {{AUTHOR}} on {{DATE}}.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, {{APP_NAME}}!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}