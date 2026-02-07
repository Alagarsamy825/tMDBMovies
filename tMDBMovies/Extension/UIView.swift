//
//  UIView.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
