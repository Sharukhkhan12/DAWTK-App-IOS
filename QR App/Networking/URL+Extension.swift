//
//  File.swift
//  QR App
//
//  Created by Touheed khan on 04/08/2025.
//


import Foundation
extension URL {
    var isRemote: Bool {
        guard let scheme = self.scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }

    var isLocalFile: Bool {
        return self.isFileURL
    }
}
