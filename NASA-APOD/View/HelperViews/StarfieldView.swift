//
//  StarfieldView.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit

class StarfieldView: UIView {

    private var emitterLayer: CAEmitterLayer!
    var starColor: UIColor = .white

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmitter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if emitterLayer != nil {
            emitterLayer.frame = bounds
            emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
            emitterLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        }
    }

    private func setupEmitter() {
        emitterLayer = CAEmitterLayer()
        layer.addSublayer(emitterLayer)
        reconfigureEmitter()
    }
    
    func reconfigureEmitter() {
        emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        
        let starCell = makeStarEmitterCell()
        
        emitterLayer.emitterCells = [starCell]
    }
    
    private func makeStarEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = 10
        cell.lifetime = 20.0
        cell.velocity = 50
        cell.velocityRange = 25
        
        cell.emissionLongitude = CGFloat.pi
        
        cell.contents = createStarImage(color: starColor)?.cgImage
        
        cell.scale = 0.2
        cell.scaleRange = 0.2
        
        cell.alphaSpeed = -0.08
        
        return cell
    }
    
    private func createStarImage(color: UIColor) -> UIImage? {
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        let colors = [color.withAlphaComponent(1.0).cgColor, color.withAlphaComponent(0.0).cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: size.width / 2, options: .drawsAfterEndLocation)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
