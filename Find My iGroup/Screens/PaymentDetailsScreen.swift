//
//  PaymentDetailsScreen.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 01/04/24.
//

import SwiftUI
import PhotosUI

struct PaymentDetailsScreen: View {
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var eventViewModel = EventViewModel()
    
    @State private var paymentProofItem: PhotosPickerItem?
    @State private var paymentProofImage: Image?
    @State private var paymentProofUIImage: UIImage? = nil
    
    @State private var paymentSuccessAlertIsShowing: Bool = false
    
    @Binding var isShowing: Bool
    
    var paymentAccountNumber: String
    var paymentAccountName: String
    var paymentAccountBank: String
    var price: Int
    var eventId: Int
    
    var paymentProofImageUrl: String?
    
    var body: some View {
        NavigationStack {
            List {
                if paymentProofImageUrl == nil {
                    Section(header: Text("Payment Information")) {
                        HStack {
                            Text("Amount")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(price, format: .currency(code: "IDR"))
                                .font(.headline)
                        }
                    }
                    
                    Section(header: Text("Recipient Information")) {
                        HStack {
                            Text("Account number")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(paymentAccountNumber)
                                .font(.headline)
                        }
                        
                        HStack {
                            Text("Bank")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(paymentAccountBank)
                                .font(.headline)
                        }
                        
                        HStack {
                            Text("Name")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(paymentAccountName)
                                .font(.headline)
                        }
                    }
                    
                    
                    Section {
                        VStack {
                            PhotosPicker("Select payment proof", selection: $paymentProofItem, matching: .images)
                            
                            paymentProofImage?
                                .resizable()
                                .scaledToFit()
                            
                        }
                        .onChange(of: paymentProofItem) {
                            Task {
                                if let loadedImage = try? await paymentProofItem?.loadTransferable(type: Image.self) {
                                    paymentProofImage = loadedImage
                                } else {
                                    print("Failed")
                                }
                            }
                            
                            Task { @MainActor in
                                if let data = try? await paymentProofItem?.loadTransferable(type: Data.self) {
                                    paymentProofUIImage = UIImage(data: data)
                                    return
                                }
                            }
                        }
                    }
                } else {
                    Section {
                        AsyncImage(url: URL(string: paymentProofImageUrl!)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                        .frame(maxHeight: 420)
                    }
                }
                
                if paymentProofImage != nil {
                    Button(action: {
                        Task {
                            do {
                                try await eventViewModel.uploadPaymentAndJoinEvent(eventId: eventId, image: paymentProofUIImage!)
                                
                                paymentSuccessAlertIsShowing = true
                            } catch {
                                print(error)
                            }
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Upload Payment Proof")
                            Spacer()
                        }
                    })
                    .alert("Upload Success!", isPresented: $paymentSuccessAlertIsShowing) {
                        Button("OK", role: .cancel) {
                            isShowing = false
//                            dismiss.callAsFunction()
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(((paymentProofImageUrl?.isEmpty) != nil) ? "Close" : "Cancel") {
                        dismiss.callAsFunction()
                    }
                    .foregroundStyle(.red)
                }
            })
            .navigationTitle(paymentProofImageUrl != nil ? "Your Payment" : "Payment Details")
        }
        
    }
}
//
//#Preview {
//    PaymentDetailsScreen()
//}
