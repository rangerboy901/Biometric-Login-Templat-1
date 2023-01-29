//
//  APIService.swift
//  Biometric Login Templat 1
//
//  Created by Joseph  DeWeese on 1/29/23.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if credentials.password == "password" {
                completion(.success(true))
            } else {
                completion(.failure(.invalidCredentials))
            }
        }
    }
}
//    func login( ) async {
//        self.loginRight = LARight(requirement: .biometry(fallback: .devicePasscode))
//        do {
//            try await loginRight.checkCanAuthorize( )
//        } catch {
//            navigateTo(section: .public)
//            return
//        }
//        do {
//            try await self.loginRight.authorize(localizedReason: self.localizedReason)
//            navigateTo(section: .protected)
//        } catch {
//            showError(.authenticationRequired)
//        }
//    }
//}

