import SwiftUI


struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var appState: AppState
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@")
    }
    
    private var passwordValid: Bool { password.count >= 8 }
    
    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }
    
    private var namesValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var dobValid: Bool {
        dob <= Date()
    }
    
    private var canCreate: Bool {
        namesValid && dobValid && isValidEmail && passwordValid && passwordsMatch
    }
    
    var body: some View {
        ZStack {
            DottedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.85))
                            .padding(10)
                            .background(Circle().fill(Color.black.opacity(0.06)))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 6)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "graduationcap.fill")
                            .foregroundStyle(Color.blue.opacity(0.85))
                        Text("CREATE ACCOUNT")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.blue.opacity(0.85))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.10)))
                    
                    Text("Create Your\nAccount")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(.black.opacity(0.88))
                    
                    Text("Enter your details to get started.")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.top, 4)
                
                ScrollView {
                    VStack(spacing: 14) {
                        
                        // First Name
                        LabeledField(title: "First Name") {
                            TextField("John", text: $firstName)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                        }
                        
                        // Last Name
                        LabeledField(title: "Last Name") {
                            TextField("Doe", text: $lastName)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                        }
                        
                        // DoB
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date of Birth")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.black.opacity(0.65))
                            
                            DatePicker(
                                "Date of Birth",
                                selection: $dob,
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                    )
                            )
                            .labelsHidden()
                        }
                        
                        // Email
                        LabeledField(title: "Email Address") {
                            TextField("alex.smith@example.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.black)
                        }
                        
                        
                        // Password
                        LabeledField(title: "Choose Password") {
                            SecureField("Min. 8 characters", text: $password)
                        }
                        
                        // Confirm Password
                        LabeledField(title: "Confirm Password") {
                            SecureField("Repeat password", text: $confirmPassword)
                        }
                        
                        if showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Create Account
                        Button {
                            validateAndCreate()
                        } label: {
                            HStack {
                                Text("Create Account")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundStyle(canCreate ? Color.white : Color.black.opacity(0.35))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(canCreate ? Color.blue : Color.black.opacity(0.10))
                            )
                        }
                        .padding(.top, 6)
                        
                        HStack(spacing: 6) {
                            Text("Already have an account?")
                                .foregroundStyle(.black.opacity(0.55))
                            NavigationLink {
                                SignInView()
                                    .navigationBarHidden(true)
                            } label: {
                                Text("Log In")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.blue)
                            }
                        }
                        .font(.footnote)
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 24)
                }
            }
        }
        .onChange(of: email) {
            if showError { showError = false }
        }
        .onChange(of: password) {
            if showError { showError = false }
        }
        .onChange(of: confirmPassword) {
            if showError { showError = false }
        }
        .onChange(of: firstName) {
            if showError { showError = false }
        }
        .onChange(of: lastName) {
            if showError { showError = false }
        }
    }
    
    private func validateAndCreate() {
        showError = false
        errorMessage = ""
        
        if !namesValid {
            showError = true
            errorMessage = "Please enter your first and last name."
            return
        }
        
        if !dobValid {
            showError = true
            errorMessage = "Please choose a valid date of birth."
            return
        }
        
        if !isValidEmail {
            showError = true
            errorMessage = "Please enter a valid email address (must include @)."
            return
        }
        
        if !passwordValid {
            showError = true
            errorMessage = "Password must be at least 8 characters."
            return
        }
        
        if !passwordsMatch {
            showError = true
            errorMessage = "Passwords do not match."
            return
        }
        
        let newUser = StoredUser(
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            dob: dob,
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
        
        userStore.save(newUser)
        appState.path.append(Route.verifyEmail(email.trimmingCharacters(in: .whitespacesAndNewlines)))

    }
    
    // Reusable labeled input container
    private struct LabeledField<Content: View>: View {
        let title: String
        @ViewBuilder var content: Content
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.black.opacity(0.65))
                
                HStack {
                    content
                        .foregroundStyle(Color.black.opacity(0.85))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    struct CreateAccountView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                CreateAccountView()
                    .environmentObject(UserStore())
                    .environmentObject(AppState())
            }
        }
    }
}
