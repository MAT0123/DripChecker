////
////  AppleSignInManager.swift
////  DripCheck
////
////  Created by Matthew Tjoa on 2025-06-01.
////
//
//import Foundation
//import AuthenticationServices
//import FirebaseAuth
//import CryptoKit
//
//@MainActor
//class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return UIApplication.shared.connectedScenes
//                .compactMap { $0 as? UIWindowScene }
//                .flatMap { $0.windows }
//                .first { $0.isKeyWindow } ?? ASPresentationAnchor()
//    }
//    
//    static let shared = AppleSignInManager()
//    
//    private var currentNonce: String?
//    
//    func startSignInWithAppleFlow() {
//        let nonce = randomNonceString()
//        currentNonce = nonce
//        
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//        request.nonce = sha256(nonce)
//        
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            print("❌ AppleID credential missing")
//            return
//        }
//        
//        guard let nonce = currentNonce else {
//            print("❌ Invalid state: no login request was sent.")
//            return
//        }
//        
//        guard let appleIDToken = appleIDCredential.identityToken else {
//            print("❌ Unable to fetch identity token")
//            return
//        }
//        
//        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//            print("❌ Unable to serialize token string")
//            return
//        }
//        
//        let credential = OAuthProvider.credential(
//            withProviderID: "apple.com",
//            idToken: idTokenString,
//            rawNonce: nonce
//        )
//        
//        Task {
//            await FirebaseAuthManager().signInWithApple(credential: credential)
//        }
//    }
//}
