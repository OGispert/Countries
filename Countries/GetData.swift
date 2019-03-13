//
//  GetData.swift
//  Countries
//
//  Created by Gispert Pelaez, Othmar on 3/12/19.
//  Copyright © 2019 Gispert Pelaez, Othmar. All rights reserved.
//

import Foundation

struct GetData: Codable {
    let countries: [Countries]
}

struct Countries: Codable {
    let country: String
    let states: [String]
}
