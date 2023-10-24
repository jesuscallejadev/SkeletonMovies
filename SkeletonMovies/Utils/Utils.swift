//
//  Utils.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 14/10/23.
//

import Foundation
import UIKit

class Utils {
    
    
    static func styleFilledButton(_ button: UIButton) {
        button.tintColor = .appPrimaryColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 20.0
        button.setTitleColor(.appPrimaryColor, for: .normal)
    }
    
    static func addCircleOutline(_ button: UIButton) {
        let circlePath = UIBezierPath(ovalIn: button.bounds.insetBy(dx: -2.0, dy: -2.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.appSecondaryColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        button.layer.addSublayer(shapeLayer)
    }
}
