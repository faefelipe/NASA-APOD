//
//  String+Date.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//


import Foundation

extension String {
    /// Converte uma String no formato "yyyy-MM-dd" para um objeto Date.
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // Define o fuso horário para evitar problemas de um dia a mais/menos
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}
