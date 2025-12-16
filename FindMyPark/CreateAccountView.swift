//
//  CreateAccountView.swift
//  FindMyPark
//
//  Created by Gary Clemente on 12/5/25.
//
import SwiftUI
import SwiftUI
import PhotosUI

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var profileImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?

    @State private var showError = false
    @State private var errorMessage = ""

    @State private var accountCreated = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {

                    // MARK: - Profile Picture Picker
                    VStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "camera")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                )
                        }

                        PhotosPicker("Choose Profile Picture", selection: $selectedPhoto)
                            .onChange(of: selectedPhoto) { newItem in
                                if let newItem {
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self),
                                           let uiImage = UIImage(data: data) {
                                            profileImage = uiImage
                                        }
                                    }
                                }
                            }
                    }
                    .padding(.top, 30)

                    // MARK: - Title
                    Text("Create Account")
                        .font(.largeTitle)
                        .bold()

                    // MARK: - Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name").font(.callout)
                        TextField("Enter your name", text: $name)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }

                    // MARK: - Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email").font(.callout)
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }

                    // MARK: - Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password").font(.callout)
                        SecureField("Create a password", text: $password)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }

                    // MARK: - Confirm Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password").font(.callout)
                        SecureField("Re-enter password", text: $confirmPassword)
                            .padding(.bottom, 6)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    }

                    // MARK: - Error Message
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // MARK: - Create Account Button
                    Button(action: createAccount) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1, green: 0.6, blue: 0.6))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $accountCreated) {
                DashboardView()   // Go here after account creation
            }
        }
    }

    // MARK: - Create Account Logic
    func createAccount() {

        // Validate fields
        guard !name.isEmpty else {
            showError("Please enter your name.")
            return
        }

        guard UserManager.shared.isEmailValid(email) else {
            showError("Please enter a valid email.")
            return
        }

        guard password.count >= 6 else {
            showError("Password must be at least 6 characters.")
            return
        }

        guard password == confirmPassword else {
            showError("Passwords do not match.")
            return
        }

        // Convert image to Data
        let imageData = profileImage?.jpegData(compressionQuality: 0.8)

        // Save user
        let newUser = StoredUser(
            name: name,
            email: email,
            password: password,
            profileImageData: imageData
        )

        UserManager.shared.saveUser(newUser)

        // Auto-login
        accountCreated = true
    }

    func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
}
