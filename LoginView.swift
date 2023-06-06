import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 300)
                    .padding(.top, 32)
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 250)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 250)
                
                Button(action: {
                    logIn()
                }) {
                    Text("Log in")
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .fullScreenCover(isPresented: $isLoggedIn, content: {
                    DashboardView()
                })
                .padding(.top, 32)
                
                HStack {
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgotten account?")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func logIn() {
        AuthenticationManager.shared.signIn(email: email, password: password) { result in
            switch result {
            case .success(let userId):
                // Authentication successful, navigate to dashboard
                print("User logged in with ID: \(userId)")
                self.isLoggedIn = true
            case .failure(let error):
                // Authentication failed, show error message
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
