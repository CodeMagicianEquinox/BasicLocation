//
//  PermissionView.swift
//  BasicLocationTT
//
//  Created by Timothy Terrance on 5/11/26.
//


import SwiftUI

struct PermissionView:View {
    
    let onEnable: () -> Void
    
    var body: some View {
        VStack(spacing:12){
            Text("We need to access your location to save check-ins")
                .multilineTextAlignment(.center)
            
            Button("Enable location"){
                self.onEnable()
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    PermissionView(onEnable: {})
}
