//
//  LoginView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/23/22.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @EnvironmentObject var state: AppState
    
    @Binding var userID: String?
    
    @State private var email = ""
    @State private var password = ""
    @State private var newUser = false
    
    enum Field {
        case email, password
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Text("Carpool").font(.system(size: 35))
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit(logIn)
                .padding()
            NavigationLink(destination: SignUpView(userID: $userID)) {
                Text("New user? Sign up.")
            }
        }
    }
    
    func logIn() {
        state.error = nil
        state.shouldIndicateActivity = true
        Task {
            do {
                let user = try await app.login(credentials: .emailPassword(email: email, password: password))
                userID = user.id
                state.shouldIndicateActivity = false
            } catch {
                DispatchQueue.main.async {
                    state.error = error.localizedDescription
                    state.shouldIndicateActivity = false
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userID: .constant("1234554321")).environmentObject(AppState())
    }
}
