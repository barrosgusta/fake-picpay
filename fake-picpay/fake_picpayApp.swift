//
//  fake_picpayApp.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import SwiftUI

@main
struct fake_picpayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1180, maxWidth: 1180, minHeight: 620, maxHeight: 620)
                .fixedSize()
                .preferredColorScheme(.dark)
                .background(.black)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
