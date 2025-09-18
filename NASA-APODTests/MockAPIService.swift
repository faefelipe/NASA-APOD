//
//  MockAPIService.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//
import Foundation
@testable import NASA_APOD // Substitua "NASA-APOD" pelo nome real do seu projeto, se for diferente

class MockAPIService: APIService {
    
    var shouldReturnError = false
    
    let mockFeaturedAPOD = APOD(title: "Featured Mock",
                                explanation: "Featured Explanation",
                                date: "2024-09-15",
                                url: "url_featured",
                                hdurl: nil,
                                mediaType: "image",
                                serviceVersion: "v1",
                                copyright: "NASA/Test")
    
    let mockPreviousAPOD = APOD(title: "Previous Mock",
                                explanation: "Previous Explanation",
                                date: "2024-09-14",
                                url: "url_previous",
                                hdurl: nil,
                                mediaType: "image",
                                serviceVersion: "v1",
                                copyright: "NASA/Test")
    
    let mockNextAPOD = APOD(title: "Next Mock",
                            explanation: "Next Explanation",
                            date: "2024-09-16",
                            url: "url_next",
                            hdurl: nil,
                            mediaType: "image",
                            serviceVersion: "v1",
                            copyright: "NASA/Test")
    
    let mockRecentList = [
        APOD(title: "Recent Mock 1",
             explanation: "Recent Explanation",
             date: "2024-09-10",
             url: "url_recent1",
             hdurl: nil,
             mediaType: "image",
             serviceVersion: "v1",
             copyright: "NASA/Test")
    ]
    
    override func fetchAPOD(for date: String) async throws -> APOD {
        if shouldReturnError {
            throw NetworkError.requestFailed(NSError(domain: "TestError", code: 1))
        }
        
        switch date {
        case "2024-09-15": return mockFeaturedAPOD
        case "2024-09-14": return mockPreviousAPOD
        case "2024-09-16": return mockNextAPOD
        default: return mockFeaturedAPOD
        }
    }
    
    override func fetchAPODs(count: Int) async throws -> [APOD] {
        if shouldReturnError {
            throw NetworkError.requestFailed(NSError(domain: "TestError", code: 1))
        }
        return mockRecentList
    }
}
