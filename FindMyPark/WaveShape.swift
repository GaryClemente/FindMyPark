import SwiftUI
struct AccountView: View {
    var body: some View {
        WelcomeView()
        }
}
struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 550) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                    Text("By offering real time park updates, crowd levels, distance tracking, and creating personalized visit records, the park going experiences will be significantly improved.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                Spacer()
                NavigationLink(destination: SignInView()) {
                    HStack {
                        Text("Continue")
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}
struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var isLoggedIn = false   // NEW
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ZStack(alignment: .bottom) {
                    Image("pattern")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 280)
                        .clipped()
                }
                VStack(alignment: .leading, spacing: 25) {
                    Text("Sign in")
                        .font(.largeTitle)
                        .bold()
                    // EMAIL
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.callout)
                        TextField("demo@email.com", text: $email)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }
                    // PASSWORD
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.callout)
                        SecureField("Enter your password", text: $password)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }
                    HStack {
                        Toggle("", isOn: $rememberMe)
                            .labelsHidden()
                        Text("Remember Me")
                            .font(.footnote)
                        Spacer()
                        Button("Forgot Password?") {}
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    // ✅ LOGIN BUTTON
                    Button(action: handleLogin) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    HStack {
                        Text("Don't have an Account?")
                            .foregroundColor(.gray)
                        NavigationLink("Create Account") {
                            CreateAccountView()
                        }
                        .foregroundColor(.red)
                    }
                    .font(.footnote)
                    .padding(.top, 10)
                    // Hidden NavigationLink triggered after login
                    NavigationLink("", destination: DashboardView(), isActive: $isLoggedIn)
                        .hidden()
                }
                .padding(.horizontal)
                Spacer()
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    // MARK: - LOGIN LOGIC
    func handleLogin() {
        let correctEmail = "test@example.com"
        let correctPassword = "123456"
        if email.lowercased() == correctEmail && password == correctPassword {
            isLoggedIn = true   // 🚀 GO TO THE NEXT PAGE
        } else {
            alertMessage = "Incorrect Email or Password."
            showAlert = true
        }
    }
}
#Preview {
    ContentView()
}
