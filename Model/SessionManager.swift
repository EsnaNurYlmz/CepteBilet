//
//  SessionManager.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 12.04.2025.
//

import Foundation

final class SessionManager {
    static let shared = SessionManager()

    private init() {} // dışarıdan init edilmesini engeller

    var userId: String?
    var userName: String?
    var email: String?

    func clearSession() {
        userId = nil
        userName = nil
        email = nil
    }
}
