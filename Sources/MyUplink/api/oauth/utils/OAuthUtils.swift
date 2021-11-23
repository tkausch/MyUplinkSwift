//
//  Copyright (C) 2021 Thomas Kausch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//  OAuthUtils.swift
//  MyUplink
//
//  Created by Thomas Kausch on 19.11.21.
//
import Foundation

#if os(Linux)
import Crypto
#else
import CommonCrypto
#endif

public func generateState(withLength len: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let length = UInt32(letters.count)

    var randomString = ""
    for _ in 0..<len {
        let rand = arc4random_uniform(length)
        let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
        let letter = letters[idx]
        randomString += String(letter)
    }
    return randomString
}

/// Generating a code verifier for PKCE
public func generateCodeVerifier() -> String? {
    var buffer = [UInt8](repeating: 0, count: 32)
    _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
   let codeVerifier = Data(buffer).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
        .trimmingCharacters(in: .whitespaces)

    return codeVerifier
}

/// Generating a code challenge for PKCE
public func generateCodeChallenge(codeVerifier: String?) -> String? {
    guard let verifier = codeVerifier, let data = verifier.data(using: .utf8) else { return nil }

    #if !os(Linux)
    var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
    }
    let hash = Data(buffer)
    #else
    let buffer = [UInt8](repeating: 0, count: SHA256.byteCount)
    let sha = Array(HMAC<SHA256>.authenticationCode(for: buffer, using: SymmetricKey(size: .bits256)))
    let hash = Data(sha)
    #endif

    let challenge = hash.base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
        .trimmingCharacters(in: .whitespaces)

    return challenge
}
