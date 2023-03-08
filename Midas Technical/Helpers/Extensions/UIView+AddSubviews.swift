//
//  UIView+AddSubviews.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
}
