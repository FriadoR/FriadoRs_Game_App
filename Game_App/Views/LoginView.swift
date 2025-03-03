//
//  LoginView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 19.02.2025.
//

import SwiftUI
import FirebaseAuth
import DotLottie

struct LoginView: View {
    @State private var activateTab: Tab = .login
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    @State private var navigateToContentView: Bool = false
    
    var background: Color = Color("AccentWoodColor")
    
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Email Address", text: $emailAddress)
                        .keyboardType(.emailAddress)
                        .customTextFieldStyle("person")
                    
                } header: {
                    Picker("", selection: $activateTab) {
                        ForEach(Tab.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                    .listRowSeparator(.hidden)
                    
                } footer: {
                    
                }
            }
            
            
            NavigationLink("", destination: ContentView())
                .navigationDestination(isPresented: $navigateToContentView) {
                    ContentView()
                }
                .hidden()
                .navigationTitle("Welcome")
                .navigationBarBackButtonHidden(true)
            
            
            
        }
        .padding(.bottom, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        //                .background(background)
        
        
    }
    enum Tab: String, CaseIterable {
        case login = "Login"
        case signUp = "Sing Up"
        
    }
}

fileprivate extension View {
    @ViewBuilder
    func customTextFieldStyle(_ icon: String? = nil, paddingTop: CGFloat = 0, _ paddingBottom: CGFloat = 0) -> some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            self
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 15)
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(Visibility.hidden)
        
    }
}


#Preview {
    LoginView()
}
