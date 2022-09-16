//
//  SignUpView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/24/22.
//

import SwiftUI
import RealmSwift

struct SignUpView: View {
    let realm = try! Realm()
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
                .onSubmit(signUp)
                .padding()
            NavigationLink(destination: LoginView(userID: $userID)) {
                Text("Returning user? Log in.")
            }
        }
    }
    
    func signUp() {
        state.error = nil
        state.shouldIndicateActivity = true
        Task {
            do {
                try await app.emailPasswordAuth.registerUser(email: email, password: password)
                let user = try await app.login(credentials: .emailPassword(email: email, password: password))
                userID = user.id
                let newUser = User()
                newUser._id = user.id
                newUser.partition = "user=\(userID!)"
                newUser.email = email
                try! realm.write {
                    realm.add(newUser)
                }
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(userID: .constant("1234554321")).environmentObject(AppState())
    }
}
