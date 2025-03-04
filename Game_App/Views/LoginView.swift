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
    @State private var activeTab: Tab = .login
    @State private var isLoading: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    @State private var navigateToContentView: Bool = false
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var showEmailVerificationView: Bool = false
    // forgot password
    @State private var showResetAlert: Bool = false
    @State private var resetEmailAddress: String = ""
    
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Email Address", text: $emailAddress)
                        .keyboardType(.emailAddress)
                        .customTextFieldStyle("envelope")
                    
                    SecureField("Password", text: $password)
                        .customTextFieldStyle("key", 0, activeTab == .login ? 10 : 0)
                    
                    if activeTab == .signUp {
                        SecureField("Re-enter Password", text: $reEnterPassword)
                            .customTextFieldStyle("key", 0, activeTab != .login ? 10 : 0)
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
                                showResetAlert = true
                            }
                            .font(.caption)
                            .tint(Color("AccentWoodColor"))
                        }
                        Button(action: loginAndSignUp, label: {
                            HStack(spacing: 12) {
                                Text(activeTab == .login ? "Login" : "Create Account")
                                Image(systemName: "arrow.right")
                                    .font(.callout)
                            }
                            .padding(.horizontal, 10)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .showLoadingIndicator(isLoading)
                        .disabled(ButtonStatus)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                }
                .disabled(isLoading)
            }
            .padding(.top, 230)
            .animation(.snappy, value: activeTab)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .padding(.all, 20)
            .background(LinearGradient.mainLoginCutomGradient())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $showEmailVerificationView, content: {
            emailVarificationView()
                .presentationDetents([.height(350)])
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
        })
        .alert(alertMessage, isPresented: $isShowingAlert) { }
        .alert("Reset Password", isPresented: $showResetAlert, actions: {
            TextField("Email", text: $resetEmailAddress)
                .padding()
            Button("Send Reset Link", role: .destructive, action: sendResetLink)
            Button("Cancel", role: .cancel) {
                resetEmailAddress = ""
            }
        }, message: {
            Text("Please enter your email address to reset your password.")
        })
        .onChange(of: activeTab, initial: false) { oldValue, newValue in
            password = ""
            reEnterPassword = ""
        }
    }
    
    @ViewBuilder
    func emailVarificationView() -> some View {
        VStack(spacing: 6) {
            GeometryReader { _ in
                DotLottieAnimation(fileName: "email", config: AnimationConfig(autoplay: true, loop: true)).view()
            }
            
            Text("Verification")
                .font(.title.bold())
            
            Text("We have sent a verification email to \(emailAddress). Please check your inbox and verify your email address before proceeding.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
        }
        .overlay(alignment: .topTrailing, content: {
            Button("Cancel"){
                showEmailVerificationView = false
                resetEmailAddress = ""
                // later we turn on delete account on firebase
                // if let user = Auth.auth().currentUser {
                // user.delete { in
                // }
                // }
            }
            .padding(15)
        })
        .padding(.bottom, 15)
        .onReceive(Timer.publish(every: 2, on: .main, in: .default).autoconnect(), perform: { _ in
            if let user = Auth.auth().currentUser {
                user.reload()
                if user.isEmailVerified {
                    showEmailVerificationView = false
                    logStatus = true
                }
            }
        })
    }
    
    func sendResetLink() {
        Task {
            do {
                if resetEmailAddress.isEmpty {
                    await presentAlert("Please enter your email address.")
                    return
                }
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetEmailAddress)
                await presentAlert("Password reset link has been sent to your email address.")
                
                resetEmailAddress = ""
                isLoading = false
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    func loginAndSignUp() {
        Task {
            isLoading = true
            do {
                if activeTab == .login {
                    // Logging in
                    let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                    if result.user.isEmailVerified {
                        // Verified user
                        // Redirect to Content View
                        logStatus = true
                        
                    } else {
                        // Send verification Email and presenting verification view
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                } else {
                    // Creating new account
                    if password == reEnterPassword {
                        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
                        // Sending verification email
                        try await result.user.sendEmailVerification()
                        // Showing email verification view
                        showEmailVerificationView = true
                        isLoading = false
                    } else {
                        await presentAlert("Passwords do not match")
                    }
                    
                }
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            isShowingAlert = true
            isLoading = false
            resetEmailAddress = ""
        }
    }
    
    enum Tab: String, CaseIterable {
        case login = "Login"
        case signUp = "Sing Up"
        
    }
    
    var ButtonStatus: Bool {
        if activeTab == .login {
            return emailAddress.isEmpty || password.isEmpty
        }
        return emailAddress.isEmpty || password.isEmpty || reEnterPassword.isEmpty
    }
}

fileprivate extension View {
    @ViewBuilder
    func showLoadingIndicator(_ status: Bool) -> some View {
        self
            .animation(.snappy) {
                content in content
                    .opacity(status ? 0 : 1)
            }
            .overlay {
                if status {
                    ZStack {
                        Capsule()
                            .fill(.bar)
                        
                        ProgressView()
                    }
                }
            }
    }
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
