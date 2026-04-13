//
//  UIStackView.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 7/4/26.
//
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
