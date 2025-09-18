//
//  NetworkError+UserFriendly.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation

extension NetworkError {
    var userFriendlyMessage: String {
        switch self {
            case .invalidURL:
                return "extensions.network.incorrect".localized
            case .requestFailed:
                return "extensions.network.failed".localized
            case .invalidResponse:
                return "extensions.network.serverNotRespond".localized
            case .decodingError:
                return "extensions.network.dataNotReceived".localized
        }
    }
}
