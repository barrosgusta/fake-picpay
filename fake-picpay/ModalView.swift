//
//  ModalView.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import SwiftUI

struct ModalView: View {
    @Binding var isModalPresented: Bool
    @State private var isLoading = true
    @State private var progress = 0.0
    @State private var progressText = "Enviando seu pagamento..."

    var body: some View {
        Group {
            if isLoading {
                LoadingView(progress: $progress, progressText: $progressText)
                    .onAppear() {
                        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
                            progress += 0.1
                            if progress >= 1.0 {
                                isLoading = false
                                timer.invalidate()
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            switch progressText {
                            case "Enviando seu pagamento...":
                                progressText = "Enviando seu pagamento."
                            case "Enviando seu pagamento.":
                                progressText = "Enviando seu pagamento.."
                            default:
                                progressText = "Enviando seu pagamento..."
                            }
                            if progress >= 1.0 {
                                isLoading = false
                                timer.invalidate()
                            }
                        }
                    }
                    
            } else {
                MainContentView(isModalPresented: $isModalPresented)
            }
        }.frame(width: 500, height: 200)
    }
}

struct LoadingView: View {
    @Binding var progress: Double
    @Binding var progressText: String

    var body: some View {
        VStack {
            Text(progressText)
                .font(.headline)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
        }
    };
    
}

struct MainContentView: View {
    @Binding var isModalPresented: Bool
    
    
    var body: some View {
        ZStack {
            Image("success")
                .opacity(0.5)
            VStack {
                Text("Pagamento enviado!")
                    .font(.title)
                    .padding()
                Text("Efetividade dentro de 24 horas")
                    .font(.subheadline)
                    .padding()

                Button("Continuar") {
                    isModalPresented = false
                }
                    .padding()
            }
        }
    }
}
