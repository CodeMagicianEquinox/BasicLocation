//
//  PermissionView.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//


import SwiftUI

struct PermissionView:View {
    
    let message: String
    let onEnable: () -> Void
    
    var body: some View {
        VStack(spacing:12){
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("Enable location"){
                self.onEnable()
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    PermissionView(message: "Location access is needed for current weather.", onEnable: {})
}
