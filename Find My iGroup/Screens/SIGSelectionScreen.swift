//
//  SIGSelectionScreen.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 01/04/24.
//

import SwiftUI

struct SIG: Identifiable, Hashable {
    var id = UUID()
    let name: String
}

struct SIGSelectionScreen: View {
    @State private var sigs: [SIG] = [
        SIG(name: "volleyball"),
        SIG(name: "badminton"),
        SIG(name: "basketball"),
        SIG(name: "futsal"),
    ]
    @State private var selectedSIGs = Set<UUID>();
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sigs) { sig in
                    Button(action: {
                        toggleSelectSIG(sigId: sig.id)
                    }, label: {
                        HStack {
                            Text(sig.name)
                                .textCase(.uppercase)
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
        .toolbar {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Submit")
            })
        }
        .navigationTitle("Select SIGs")
    }
    
    func toggleSelectSIG (sigId: UUID) {
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
