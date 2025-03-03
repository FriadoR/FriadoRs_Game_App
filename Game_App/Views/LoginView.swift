//
//  LoginView.swift
//  Wood Game
//
//  Created by Сергей Саченко on 19.02.2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var activeTab: Tab = .login
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
                    
                    SecureField("Password", text: $password)
                        .customTextFieldStyle("person", 0, activeTab == .login ? 10 : 0)
                    
                    if activeTab == .signUp {
                        SecureField("Re-enter Password", text: $reEnterPassword)
                            .customTextFieldStyle("person", 0, activeTab != .login ? 10 : 0)
                    }
                    
                } header: {
                    Picker("", selection: $activeTab) {
                        ForEach(Tab.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .listRowSeparator(.hidden)
                    
                } footer: {
                    VStack(alignment: .trailing, spacing: 12, content: {
                        if activeTab == .login {
                            Button("Forgot Password?") {
                                
                            }
                            .font(.caption)
                            .tint(Color("AccentWoodColor"))
                            
                        }
                        Button(action: {}, label: {
                            HStack(spacing: 12) {
                                Text(activeTab == .login ? "Login" : "Create Account")
                                
                                Image(systemName: "arrow.right")
                                    .font(.callout)
                            }
                            .padding(.horizontal, 10)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                }
            }
            .animation(.snappy, value: activeTab)
            .listStyle(.insetGrouped)
            .navigationBarTitle("Welcome")
            
            
//            NavigationLink("", destination: ContentView())
//                .navigationDestination(isPresented: $navigateToContentView) {
//                    ContentView()
//                }
//                .hidden()
//                .navigationTitle("Welcome")
//                .navigationBarBackButtonHidden(true)
//            
            
            
        }
//        .padding(.bottom, 50)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .ignoresSafeArea(.all)
//        .background(background)
        
        
    }
    enum Tab: String, CaseIterable {
        case login = "Login"
        case signUp = "Sing Up"
        
    }


fileprivate extension View {
    @ViewBuilder
    func customTextFieldStyle(_ icon: String? = nil, _ paddingTop: CGFloat = 0, _ paddingBottom: CGFloat = 0) -> some View {
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
