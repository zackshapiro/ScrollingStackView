//
//  ScrollingStackView.swift
//
//  Created by Zack Shapiro.
//

import UIKit
import Cartography

/// A ScrollingStackView is a ScrollView with an embedded vertical UIStackView
/// that you can add things to
///
/// If you need additional features of UIScrollView or UIStackView, add them
/// as properties of ScrollingStackView and reference the class you're pulling the property from
/// inside the closure.

enum ScrollingStackViewOrientation {
    case horizontal, vertical
}

class ScrollingStackView: UIView {
    private let scrollView: UIScrollView = UIScrollView()
    private let stackView: UIStackView = UIStackView()
    
    private let orientation: ScrollingStackViewOrientation
    
    weak var delegate: UIScrollViewDelegate?
    
    var showScrollViewIndicator = true {
        didSet {
            switch orientation {
            case .horizontal:
                scrollView.showsHorizontalScrollIndicator = showScrollViewIndicator
            case .vertical:
                scrollView.showsVerticalScrollIndicator = showScrollViewIndicator
            }
        }
    }
    
    var arrangedSubviews: [UIView] {
        return stackView.arrangedSubviews
    }
    
    
    private var padding: CGFloat
    
    init(orientation: ScrollingStackViewOrientation, spacing: CGFloat = 0, padding: CGFloat = 0) {
        self.orientation = orientation
        self.scrollView.delegate = delegate
        self.padding = padding
        
        switch orientation {
        case .horizontal: stackView.axis = .horizontal
        case .vertical:stackView.axis = .vertical
        }

        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = spacing
        
        super.init(frame: .zero)
        
        addSubview(scrollView)
        constrain(scrollView) { $0.edges == $0.superview!.edges }
        
        scrollView.addSubview(stackView)
        setStackViewConstraints(orientation: orientation)
    }
    
    private func setStackViewConstraints(orientation: ScrollingStackViewOrientation) {
        switch orientation {
        case .vertical:
            constrain(stackView) { stackView in
                stackView.top == stackView.superview!.top
                stackView.left == stackView.superview!.superview!.left
                stackView.right == stackView.superview!.superview!.right
                stackView.bottom == stackView.superview!.bottom
            }
        case .horizontal:
            constrain(stackView) { stackView in
                stackView.top == stackView.superview!.superview!.top
                stackView.left == stackView.superview!.left
                stackView.right == stackView.superview!.right
                stackView.bottom == stackView.superview!.superview!.bottom - self.padding
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangedSubviews(views: [UIView]) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    func addArrangedSubview(view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    func removeArrangedSubview(view: UIView) {
        stackView.removeArrangedSubview(view)
    }
    
    func removeAllArrangedSubviews() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
    }
    
    func removeSelectArrangedSubviews(in indexes: CountableRange<Int>) {
        for (subviewIndex, subview) in stackView.arrangedSubviews.enumerated() {
            guard indexes.contains(subviewIndex) else { continue }
            
            subview.removeFromSuperview()
        }
    }
    
    func insertArrangedSubview(view: UIView, atIndex index: Int) {
        stackView.insertArrangedSubview(view, at: index)
    }
    
    func removeArrangedSubview(view: UIView, atIndex index: Int) {
        for (subviewIndex, subview) in stackView.arrangedSubviews.enumerated() {
            guard subviewIndex == index else { continue }
            
            subview.removeFromSuperview()
        }
    }
}
