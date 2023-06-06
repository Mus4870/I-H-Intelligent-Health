//
//  SignUpView.swift
//  I-H final
//
//  Created by mustafa farah on 16/05/2023
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 200)
                .padding(.top, 32)
                
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 250)
                
            Button(action: {
                if self.password == self.confirmPassword {
                    AuthenticationManager.shared.signUp(email: self.email, username: self.username, password: self.password) { (result) in
                        switch result {
                        case .success(let userId):
                            print("Successfully registered user with id: \(userId)")
                        case .failure(let error):
                            print("Failed to register user: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Passwords do not match")
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 32)
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
