//
//  ModalView.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import SwiftUI

struct ModalView: View {
    @Binding var isModalPresented: Bool
    @Binding var fakeDest: String
    @Binding var transferValue: Decimal
    
    @State private var isLoading = true
    @State private var progress = 0.0
    @State private var progressText = ""

    var body: some View {
        Group {
            if isLoading {
                LoadingView(progress: $progress, progressText: $progressText)
                    .onAppear() {
                        progressText = "Enviando seu pagamento para \(fakeDest)..."
                        let timeInterval = Double.random(in: 0.2...1)
                        print(timeInterval)
                        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
                            progress += 0.1
                            if progress >= 1.0 {
                                isLoading = false
                                timer.invalidate()
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            switch progressText {
                            case "Enviando seu pagamento para \(fakeDest)...":
                                progressText = "Enviando seu pagamento para \(fakeDest)."
                            case "Enviando seu pagamento para \(fakeDest).":
                                progressText = "Enviando seu pagamento para \(fakeDest).."
                            default:
                                progressText = "Enviando seu pagamento para \(fakeDest)..."
                            }
                            if progress >= 1.0 {
                                isLoading = false
                                timer.invalidate()
                            }
                        }
                    }
                    
            } else {
                MainContentView(
                    isModalPresented: $isModalPresented,
                    fakeDest: $fakeDest,
                    transferValue: $transferValue
                )
            }
        }
            .frame(width: 720, height: 320)
    }
}

struct LoadingView: View {
    @Binding var progress: Double
    @Binding var progressText: String

    var body: some View {
        VStack {
            Text(progressText)
                .font(.title2)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
                
        }
    };
    
}

struct MainContentView: View {
    @Binding var isModalPresented: Bool
    @Binding var fakeDest: String
    @Binding var transferValue: Decimal
    
    var body: some View {
        let formattedTranferValue = CurrencyFormatter.shared.string(from: transferValue as NSNumber) ?? ""
        ZStack {
            Image("success")
                .opacity(0.2)
            VStack {
                HStack {
                    Text(formattedTranferValue)
                        .bold()
                    + Text(" enviado para ")
                    + Text("\(fakeDest)!")
                        .bold()
                }
                    .font(.largeTitle)
                
                Text("Processamento dentro de 24 horas")
                    .font(.title)
                    .padding()

                Button("Continuar") {
                    isModalPresented = false
                }
                    .padding()
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
            }
        }
    }
}
