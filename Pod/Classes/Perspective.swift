//
//  Perspective.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

public final class Perspective {
    let vectors : [Vector3Type]

    public init(_ q: Quadrilateral) {
        vectors = q.corners.map{$0.homogeneous3dvector}
    }

    lazy var basisVectorsToPointsMap: Matrix3x3Type! = {
        let m = Matrix3x3Type([
            self.vectors[0],
            self.vectors[1],
            self.vectors[2]]
        )
        let solution = m.homogeneousInverse() * self.vectors[3]
        let scale = Matrix3x3Type(diagonal: solution)
        let basisToPoints = m * scale
        return basisToPoints.zNormalized()
    }()

    lazy var pointsToBasisVectorsMap: Matrix3x3Type! = {
        self.basisVectorsToPointsMap.homogeneousInverse()
    }()

    internal func projection(to:Perspective) -> Matrix3x3Type {
        return (to.basisVectorsToPointsMap * pointsToBasisVectorsMap).zNormalized()
    }
}