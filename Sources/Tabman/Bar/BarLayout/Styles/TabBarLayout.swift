//
//  TabBarLayout.swift
//  Tabman
//
//  Created by Merrick Sapsford on 26/06/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

public final class TabBarLayout: BarLayout {
    
    // MARK: Properties
    
    private let stackView = UIStackView()

    @available(*, unavailable)
    public override var contentMode: BarLayout.ContentMode {
        set {
            fatalError("\(type(of: self)) does not support updating contentMode")
        } get {
            return super.contentMode
        }
    }
    @available(*, unavailable)
    public override var isPagingEnabled: Bool {
        set {
            fatalError("\(type(of: self)) does not support updating isPagingEnabled")
        } get {
            return super.isPagingEnabled
        }
    }
   
    private var viewWidthConstraints: [NSLayoutConstraint]?
    /// The number of buttons that can be fitted onto a single page of the layout.
    public var maximumButtonCount: Int = 5 {
        didSet {
            guard oldValue != maximumButtonCount else {
                return
            }
            constrain(views: stackView.arrangedSubviews, for: maximumButtonCount)
        }
    }
    
    // MARK: Lifecycle
    
    public override func performLayout(in view: UIView) {
        super.performLayout(in: view)
    
        stackView.distribution = .fill
        super.isPagingEnabled = true
        
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    public override func insert(buttons: [BarButton], at index: Int) {
        var currentIndex = index
        
        for button in buttons {
            if index >= stackView.arrangedSubviews.count { // just add
                stackView.addArrangedSubview(button)
            } else {
                stackView.insertArrangedSubview(button, at: currentIndex)
            }
            currentIndex += 1
        }
        constrain(views: buttons, for: maximumButtonCount)
    }
    
    public override func remove(buttons: [BarButton]) {
        for button in buttons {
            stackView.removeArrangedSubview(button)
        }
    }
    
    public override func barFocusRect(for position: CGFloat, capacity: Int) -> CGRect {
        return .zero
    }
}

private extension TabBarLayout {
    
    func constrain(views: [UIView], for maximumCount: Int) {
        if let oldConstraints = viewWidthConstraints {
            NSLayoutConstraint.deactivate(oldConstraints)
        }
        
        var constraints = [NSLayoutConstraint]()
        let multiplier = 1.0 / CGFloat(maximumCount)
        for view in views {
            constraints.append(view.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor,
                                                           multiplier: multiplier))
        }
        NSLayoutConstraint.activate(constraints)
        self.viewWidthConstraints = constraints
    }
}
