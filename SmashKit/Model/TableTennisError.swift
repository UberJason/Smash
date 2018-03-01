//
//  TableTennisError.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public enum TableTennisError: Error {
    case invalidHtml
    case missingName
    case missingDate
    case missingFinalRating
    case missingNetRatingChange
    case mismatchedWinsAndPointsMatrices
    case unrecognizedMatrixValue
}
