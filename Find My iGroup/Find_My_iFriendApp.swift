//
//  Find_My_iFriendApp.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 19/03/24.
//

import SwiftUI

@main
struct Find_My_iFriendApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
