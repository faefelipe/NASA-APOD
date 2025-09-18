//
//  String+Ext.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//


import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
