//
//  ContentView.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var balance: Decimal = 14768532.24
    @State private var transferValue: Decimal = 0
    @State private var transferTextValue: String = ""
    @State private var fakeDest: String = ""
    @State private var isModalPresented = false
    @State private var showAlert = false
    @State private var alertTitleMessage: String = ""
    
    var body: some View {
        VStack {
            Image("picpay-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 620)
                .padding()
            
            if let Value = CurrencyFormatter.shared.string(from: balance as NSNumber) {
                Text("Saldo disponível: \(Value)")
                    .font(.title2)
                    .padding()
            }
            
            
            TextField("Destinatário", text: $fakeDest)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 300)

            TextField("Valor a ser pago", text: $transferTextValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 200)
                .onReceive(Just(transferTextValue)) { newText in
                    let filteredText = newText.filter { "0123456789.".contains($0) }
                    transferTextValue = filteredText
                    if let value = Decimal(string: transferTextValue) {
                        transferValue = value
                    }
                }

            HStack {
                Button("Voltar") {
                    print("back")
                }
                .controlSize(.large)
                
                Button("Realizar Pagamento") {
                    self.handleFakeTransfer()
                }
                .alert(isPresented: $showAlert) {
                    alert
                }
                .sheet(isPresented: $isModalPresented) {
                    ModalView(
                        isModalPresented: $isModalPresented,
                        fakeDest: $fakeDest,
                        transferValue: $transferValue
                    )
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                .onSubmit {
                    self.handleFakeTransfer()
                }
            }
        }
    }
    
    func handleFakeTransfer() {
        if fakeDest == "" {
            isModalPresented = false
            showAlert = true
            alertTitleMessage = "Informe um destinatário!"
        } else if transferValue > balance {
            isModalPresented = false
            showAlert = true
            alertTitleMessage = "Saldo insuficiente!"
        } else if transferValue <= 0 {
            isModalPresented = false
            showAlert = true
            alertTitleMessage = "Insira um valor válido!"
        } else {
            showAlert = false
            isModalPresented = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                balance -= transferValue
                timer.invalidate()
            }
        }
    }

    var alert: Alert {
        return Alert(
            title: Text(alertTitleMessage)
        )
    }
}
