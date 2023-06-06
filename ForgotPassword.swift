//
//  ForgotPassword.swift
//  I-H final
//
//  Created by mustafa farah on 17/05/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 300)
            
            Text("Reset Password")
                .font(.title)
                .fontWeight(.bold)
    
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250)

            Button(action: {
                // Handle reset password button tapped
                // You can perform password reset logic here
            }) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
