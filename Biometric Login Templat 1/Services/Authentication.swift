//
//  Authentication.swift
//  Biometric Login Templat 1
//
//  Created by Joseph  DeWeese on 1/29/23.
//

import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case faceID
        case touchID
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deniedAccess //biometric
        case noFaceIDEnrolled
        case noFingerprintEnrolled
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again", comment: "")
                //MARK:  BIOMETRIC AUTHORIZATION
            case .deniedAccess://biometric
                return NSLocalizedString("You have denied access.  Please go to settings and allow Face ID.", comment: "")
            case .noFaceIDEnrolled://biometric
                return NSLocalizedString("You have not registered Face ID Biometrics.", comment: "")
            case .noFingerprintEnrolled://biometric
                return NSLocalizedString("You have not registered Finger Print Biometrics.", comment: "")
            case .biometricError://biometric
                return NSLocalizedString("You have not registered any authorized Biometrics. Your face nor fingerprints were recognized.", comment: "")
            case .credentialsNotSaved://biometric
                return NSLocalizedString("Your credentials have not been saved.  Do you want to save them after the next successful login?", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func biometricType( ) -> BiometricType  {
        let authContext = LAContext( )
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
  //      let credentials:Credentials? = Credentials(email: "anything", password: "password")
  //      let credentials:Credentials? = nil
        let credentials = KeychainStorage.getCredentials()
        guard let credentials = credentials  else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        let context = LAContext( )
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIDEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials" ) {
                    success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}

