//
//  SIGSelectionScreen.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 01/04/24.
//

import SwiftUI

struct SIGSelectionScreen: View {
    @ObservedObject var authViewModel = AuthViewModel()
    
    @State private var sigs: [SIG] = [
        SIG(id: 1, name: "volleyball"),
        SIG(id: 2, name: "badminton"),
        SIG(id: 3, name: "basketball"),
        SIG(id: 4, name: "futsal"),
        SIG(id: 5, name: "billiard"),
        SIG(id: 6, name: "archery")
    ]
    @State private var selectedSIGs = Set<Int>();
    @State private var isLoading = false;
    
    @State private var successAlertIsShowing = false
    
    @Environment(\.editMode) private var editMode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView()
                } else {
                    ForEach(sigs) { sig in
                        Button(action: {
                            toggleSelectSIG(sigId: sig.id)
                        }, label: {
                            HStack {
                                Text(sig.name.capitalized(with: Locale(identifier: "id-ID")))
                                
                                Spacer()
                                
                                if selectedSIGs.contains(sig.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else {
                                    Image(systemName: "circle")
                                }
                            }
                        })
                        .foregroundStyle(.primary)
                    }
                }
            }
            .onAppear {
                Task {
                    isLoading = true
                    
                    try await authViewModel.getJoinedSigs()
                    selectedSIGs = Set(authViewModel.joinedSigs)
                    
                    isLoading = false
                }
            }
        }
        .toolbar {
            Button(action: {
                Task {
                    try await authViewModel.updateJoinedSigs(sigIds: Array(selectedSIGs))
                    successAlertIsShowing = true
                }
            }, label: {
                Text("Submit")
            })
            .alert("Updated Joined SIGs", isPresented: $successAlertIsShowing) {
                Button("OK", role: .cancel) {
                    dismiss.callAsFunction()
                }
            }
        }
        .navigationTitle("Select SIGs")
    }
    
    func toggleSelectSIG (sigId: Int) {
        if selectedSIGs.contains(sigId) {
            selectedSIGs.remove(sigId)
        } else {
            selectedSIGs.insert(sigId)
        }
    }
}

#Preview {
    SIGSelectionScreen()
}
