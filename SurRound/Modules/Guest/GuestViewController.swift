//
//  GuestViewController.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/2/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps

class GuestViewController: HomeViewController {

    private lazy var backToSignInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Back To Login")
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray
        btn.clipsToBounds = true
        btn.layer.cornerRadius = self.buttonHeight / 2
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let buttonHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backToSignInButton)
        backToSignInButton.anchorCenterXToSuperview()
        backToSignInButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16).isActive = true
        backToSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backToSignInButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    @objc private func back(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension GuestViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        return
    }
    
    override func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return false
    }
}
