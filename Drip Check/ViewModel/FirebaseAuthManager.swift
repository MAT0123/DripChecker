////
////  FirebaseAuthManager.swift
////  DripCheck
////
////  Created by Matthew Tjoa on 2025-05-31.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseCore
//import GoogleSignIn
//import GoogleSignInSwift
//class FirebaseAuthManager: ObservableObject {
//    @Published var isAuthenticated = false
//    @Published var currentUser: User?
//    @Published var isLoading = false
//    @Published var errorMessage = ""
//    
//    private var auth = Auth.auth()
//    private var authStateListener: AuthStateDidChangeListenerHandle?
//    
//    init() {
//        setupAuthStateListener()
//
//    }
//    
//    deinit {
//        if let listener = authStateListener {
//            auth.removeStateDidChangeListener(listener)
//        }
//    }
//    
//    private func setupAuthStateListener() {
//        authStateListener = auth.addStateDidChangeListener { [weak self] _, firebaseUser in
//            DispatchQueue.main.async {
//                if let firebaseUser = firebaseUser {
//                    self?.currentUser = User(
//                        id: firebaseUser.uid,
//                        email: firebaseUser.email ?? "",
//                        name: firebaseUser.displayName ?? self?.extractNameFromEmail(firebaseUser.email ?? "") ?? "User"
//                    )
//                    self?.isAuthenticated = true
//                } else {
//                    self?.currentUser = nil
//                    self?.isAuthenticated = false
//                }
//            }
//        }
//    }
//    
//    // MARK: - Sign In
//    
//    func signIn(email: String, password: String) async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let result = try await auth.signIn(withEmail: email, password: password)
//            
//            await MainActor.run {
//                isLoading = false
//                // User will be set automatically by auth state listener
//            }
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//        }
//    }
//    
//    // MARK: - Sign Up
//    
//    func signUp(name: String, email: String, password: String) async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let result = try await auth.createUser(withEmail: email, password: password)
//            
//            // Update display name
//            let changeRequest = result.user.createProfileChangeRequest()
//            changeRequest.displayName = name
//            try await changeRequest.commitChanges()
//            
//            await MainActor.run {
//                isLoading = false
//                // User will be set automatically by auth state listener
//            }
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//        }
//    }
//    
//    // MARK: - Sign Out
//    
//    func signOut() {
//        do {
//            try auth.signOut()
//            // User will be cleared automatically by auth state listener
//        } catch {
//            errorMessage = "Failed to sign out: \(error.localizedDescription)"
//        }
//    }
//    
//    // MARK: - Password Reset
//    
//    func resetPassword(email: String) async -> Bool {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            try await auth.sendPasswordReset(withEmail: email)
//            await MainActor.run {
//                isLoading = false
//            }
//            return true
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Apple Sign In
//    
//    func signInWithApple(credential: AuthCredential) async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let result = try await auth.signIn(with: credential)
//            await MainActor.run {
//                isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//        }
//    }
//    
//    // MARK: - Google Sign In
//    func startGoogleSignIn() async {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        guard let rootViewController = await UIApplication.shared.windows.first?.rootViewController else { return }
//
//        do {
//            let user = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            guard let idToken = user.user.idToken?.tokenString else {
//                print("❌ Missing ID Token")
//                return
//            }
//
//            let accessToken = user.user.accessToken.tokenString
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//
//            await signInWithGoogle(credential: credential)
//
//        } catch {
//            print("❌ Google Sign-in failed:", error.localizedDescription)
//        }
//    }
//    
//    func signInWithGoogle(credential: AuthCredential) async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let result = try await auth.signIn(with: credential)
//            await MainActor.run {
//                isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func extractNameFromEmail(_ email: String) -> String {
//        return String(email.split(separator: "@").first ?? "User").capitalized
//    }
//    
//    private func handleFirebaseError(_ error: Error) -> String {
//        guard let authError = error as NSError? else {
//            return "An unknown error occurred"
//        }
//        
//        switch AuthErrorCode(rawValue: authError.code) {
//        case .emailAlreadyInUse:
//            return "This email is already registered. Please sign in instead."
//        case .invalidEmail:
//            return "Please enter a valid email address."
//        case .weakPassword:
//            return "Password should be at least 6 characters long."
//        case .userNotFound:
//            return "No account found with this email. Please sign up first."
//        case .wrongPassword:
//            return "Incorrect password. Please try again."
//        case .userDisabled:
//            return "This account has been disabled. Please contact support."
//        case .tooManyRequests:
//            return "Too many attempts. Please try again later."
//        case .networkError:
//            return "Network error. Please check your connection."
//        default:
//            return authError.localizedDescription
//        }
//    }
//}
//
//// MARK: - User Model
//
//struct User: Codable {
//    let id: String
//    let email: String
//    let name: String
//}
//
//extension FirebaseAuthManager {
//    
//    // MARK: - Update Profile
//    
//    func updateDisplayName(_ name: String) async {
//        guard let user = auth.currentUser else { return }
//        
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let changeRequest = user.createProfileChangeRequest()
//            changeRequest.displayName = name
//            try await changeRequest.commitChanges()
//            
//            await MainActor.run {
//                isLoading = false
//                // Update local user object
//                if let currentUser = currentUser {
//                    self.currentUser = User(
//                        id: currentUser.id,
//                        email: currentUser.email,
//                        name: name
//                    )
//                }
//            }
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//        }
//    }
//    
//    // MARK: - Email Verification
//    
//    func sendEmailVerification() async -> Bool {
//        guard let user = auth.currentUser else { return false }
//        
//        do {
//            try await user.sendEmailVerification()
//            return true
//        } catch {
//            await MainActor.run {
//                errorMessage = handleFirebaseError(error)
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Delete Account
//    
//    func deleteAccount() async -> Bool {
//        guard let user = auth.currentUser else { return false }
//        
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            try await user.delete()
//            await MainActor.run {
//                isLoading = false
//            }
//            return true
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Re-authenticate (for sensitive operations)
//    
//    func reauthenticate(password: String) async -> Bool {
//        guard let user = auth.currentUser,
//              let email = user.email else { return false }
//        
//        await MainActor.run {
//            isLoading = true
//            errorMessage = ""
//        }
//        
//        do {
//            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//            try await user.reauthenticate(with: credential)
//            
//            await MainActor.run {
//                isLoading = false
//            }
//            return true
//        } catch {
//            await MainActor.run {
//                isLoading = false
//                errorMessage = handleFirebaseError(error)
//            }
//            return false
//        }
//    }
//}
