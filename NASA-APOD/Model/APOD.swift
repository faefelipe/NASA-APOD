//
//  APOD.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation

struct APOD: Codable, Identifiable, Hashable {
    let title: String
    let explanation: String
    let date: String
    let url: String
    let hdurl: String?
    let mediaType: String
    let serviceVersion: String
    let copyright: String?

    enum CodingKeys: String, CodingKey {
        case title, explanation, date, url, hdurl, copyright
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }

    var id: String {
        return date
    }
}
