//
//  Coordinator.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
