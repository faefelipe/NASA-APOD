//
//  APIService.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

class APIService {
    private let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "NASA_API_KEY") as? String else {
            fatalError("NASA_API_KEY não encontrada no Info.plist. Verifique a configuração do xcconfig.")
        }
        return key
    }()
    private let baseURL = "https://api.nasa.gov/planetary/apod"

    func fetchAPODs(count: Int) async throws -> [APOD] {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "count", value: String(count))
        ]

        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        let decoder = JSONDecoder()
        let apods = try decoder.decode([APOD].self, from: data)
        return apods.filter { $0.mediaType == "image" }.sorted { $0.date > $1.date }
    }
    
    func fetchAPOD(for date: String) async throws -> APOD {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "date", value: date)
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        let decoder = JSONDecoder()
        return try decoder.decode(APOD.self, from: data)
    }
}
