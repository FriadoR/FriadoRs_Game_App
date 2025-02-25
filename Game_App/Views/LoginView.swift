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
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    @State private var navigateToContentView = false
    @State private var showAlertError = false
    
    var background: Color = Color("AccentWoodColor")
    private var isButtonEnabled: Bool { !email.isEmpty && !password.isEmpty }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("LoginViewImage")
                
                VStack(spacing: 10) {
                    
                    Text("Welcome")
                        .customTitle()
                        .padding(.bottom, 10)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .disableAutocorrection(true)
                        .frame(width: 270)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .disableAutocorrection(true)
                        .frame(width: 270)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Button(action: login) {
                        Text("Enter")
                            .padding()
                            .frame(width: 260)
                            .foregroundColor(Color(.textWood))
                            .background(isButtonEnabled ? background : Color(.gray.opacity(0.3)))
                            .cornerRadius(30)
                            .shadow(radius: 15)
                    }
                    Button(action: register) {
                        Text("Registration")
                            .foregroundColor(Color(.textWood))
                            .padding(.bottom)
                    }
                    NavigationLink("", destination: ContentView())
                        .navigationDestination(isPresented: $navigateToContentView) {
                            ContentView()
                        }
                        .hidden()
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("Ошибка входа: \(error.localizedDescription)")
            } else {
                self.errorMessage = ""
                self.isLoggedIn = true
                self.navigateToContentView = true
                print("Успешный вход")
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("Ошибка регистрации: \(error.localizedDescription)")
            } else {
                self.errorMessage = ""
                self.isLoggedIn = true
                print("Регистрация прошла успешно")
            }
        }
    }
}


#Preview {
    LoginView()
}
