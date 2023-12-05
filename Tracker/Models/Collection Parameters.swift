//
//  Collection Parametres.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation

struct CollectionParameters {
    let cellsNumber: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let interCellSpacing: CGFloat

    var widthInsets: CGFloat {
        return interCellSpacing * CGFloat(cellsNumber - 1) + leftInset + rightInset
    }
}
