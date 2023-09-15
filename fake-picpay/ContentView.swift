//
//  ContentView.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var balance: Decimal = 15045610
    @State private var transferValue: Decimal = 0
    @State private var transferTextValue: String = ""
    @State private var fakeDest: String = ""
    @State private var isModalPresented = false
    @State private var showAlert = false
    @State private var alertTitleMessage: String = ""
    let test: NSNumber = 10000
    
    
    var body: some View {
        VStack {
            Image("picpay-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 620)
                .padding()
            
            if let Value = CurrencyFormatter.shared.string(from: balance as NSNumber) {
                Text("Saldo disponível = \(Value)")
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

            Button("Realizar Pagamento") {
                if fakeDest == "" {
                    isModalPresented = false
                    showAlert = true
                    alertTitleMessage = "Informe um destinatário!"
                } else if transferValue > balance {
                    isModalPresented = false
                    showAlert = true
                    alertTitleMessage = "Saldo insuficiente!"
                } else {
                    showAlert = false
                    isModalPresented = true
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                        print(transferValue)
                        balance -= transferValue
                        timer.invalidate()
                    }
                }
                
                
                fakeDest = ""
                transferTextValue = ""
            }
            .alert(isPresented: $showAlert) {
                alert
            }
            .padding(10)
            
            .sheet(isPresented: $isModalPresented) {
                ModalView(isModalPresented: $isModalPresented)
            }
        }
        .frame(minWidth: 1180, maxWidth: 1180, minHeight: 620, maxHeight: 620)
    }

    var alert: Alert {
        return Alert(
            title: Text(alertTitleMessage)
        )
    }
}
