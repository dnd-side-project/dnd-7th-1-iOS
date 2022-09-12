//
//  Block.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import MapKit

class Block: MKPolygon {
    var owner: BlocksType?
    var color: UIColor?
    
    convenience init(coordinate: UnsafePointer<CLLocationCoordinate2D>, count: Int, owner: BlocksType, color: UIColor) {
        self.init(coordinates: coordinate, count: count)
        self.owner = owner
        self.color = color
    }
}
