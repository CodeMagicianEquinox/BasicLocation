//
//  LocationReadyView.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//

import SwiftUI

struct LocationReadyView: View {
    
    let latText: String
    let longText: String
    let onRefresh: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                Text("Longitude: " + longText)
                Text("Latitude: " + latText)
                
                HStack {
                    Button("Refresh") {
                        self.onRefresh()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Save check-in") {
                        self.onSave()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
