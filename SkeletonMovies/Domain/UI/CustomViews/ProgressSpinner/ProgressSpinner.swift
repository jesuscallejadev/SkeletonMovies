//
//  ProgressSpinner.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//


import UIKit

protocol ProgressSpinnerInput {
    func updateVisibility(show: Bool, autoDismiss: Bool)
    func createStructure(mainView: UIView)
}

class ProgressSpinner {

    // MARK: - Private properties

    private var containerSpinnerView: UIView?
    private var mainView: UIView?
}

// MARK: - ProgressSpinnerInput

extension ProgressSpinner: ProgressSpinnerInput {

    func updateVisibility(show: Bool, autoDismiss: Bool = false) {
        DispatchQueue.main.async {
            guard let insideView = self.containerSpinnerView?.subviews.first else { return print("Progress Spinner view is nil")}
            UIView.animate(withDuration: 1, animations: {
                self.containerSpinnerView?.alpha = show ? 1 : 0
            }) { _ in
                if show == false {
                    insideView.frame.origin.x = -170
                }
            }
            if show {
                UIView.animate(withDuration: 4, delay: 0, options: .repeat, animations: {
                    guard let width = self.mainView?.frame.width else { return }
                    insideView.frame.origin.x += width + 170
                }) { _ in }
            }

            if autoDismiss {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    self.updateVisibility(show: false)
                }
            }
        }
    }

    func createStructure(mainView: UIView) {
        self.mainView = mainView
        let containerView = UIView()
        containerView.backgroundColor = .appSecondaryColor
        containerView.alpha = 0
        let insideView = UIView(frame: CGRect(x: -170, y: 0, width: 168, height: 4))
        insideView.backgroundColor = .white

        // Add into views
        containerView.addSubview(insideView)
        mainView.addSubview(containerView)

        // Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["containerView": containerView, "insideView": insideView]

        let window = UIApplication.shared.keyWindow
        guard let topPadding = window?.safeAreaInsets.top else { return }

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[containerView]-(0)-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(topPadding+50))-[containerView(4)]", options: NSLayoutConstraint.FormatOptions.alignmentMask, metrics: nil, views: views)

        mainView.addConstraints(horizontalConstraints)
        mainView.addConstraints(verticalConstraints)
        self.containerSpinnerView = containerView
    }
}
