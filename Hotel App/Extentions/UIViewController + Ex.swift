//
//  UIViewController + Ex.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
//        DispatchQueue.main.async {
//            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
//            alertVC.modalPresentationStyle  = .overFullScreen
//            alertVC.modalTransitionStyle    = .crossDissolve
//            self.present(alertVC, animated: true)
//        }
    }
    
    func showLoadingIndicator() {
        containerView = UIView(frame: self.view.bounds)
        self.view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
    }
    
    func dismissLoadingIndicator() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}
