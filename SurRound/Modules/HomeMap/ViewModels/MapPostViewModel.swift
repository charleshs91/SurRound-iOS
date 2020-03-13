//
//  MapPostViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps

struct MapPostViewModel {
    
    var post: Post
    var mapMarker: GMSMarker
    
    init(post: Post) {
        
        self.post = post
        let position = CLLocationCoordinate2D(latitude: post.place.coordinate.latitude,
                                              longitude: post.place.coordinate.longitude)
        mapMarker = GMSMarker(position: position)
        styleMapMarker()
    }
    
    func displayMarker(onMap map: GMSMapView) {
        
        mapMarker.map = map
    }
    
    private func styleMapMarker() {
        
        let imgView = SRMapMarker(avatar: post.author.avatar,
                                  text: post.text,
                                  category: nil,
                                  placeholder: UIImage.asset(.Icons_Avatar))
        
        mapMarker.iconView = imgView
        mapMarker.iconView?.frame = CGRect(x: 0, y: 0, width: 120, height: 48)
    }
}
