//
//  Constants.swift
//  Example
//
//  Created by Aaron Welborn on 4/11/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import Foundation

// URL Builder
let http = "http://"
let host = "67.11.138.10"
let port = 8320
let getDomain = "\(http)\(host):\(String(port))"

// Resources
let associatedVehiclesURL = "/vehicleRepo"
let findByMemberId = "/search/findByMemberId?memberId="


// Segue Identifiers
let segueMemberVehicles = "MemberVehicles"
let segueVehicleDetailsViewController = "VehicleDetailsViewController"
let segueWebView = "WebView"
let segueAddMember = "AddMember"
let segueMemberVehiclesFromAddMember = "MemberVehiclesFromAddMember"


// Reuse Identifiers
let reuseVehicleTitleCell = "VehicleTitleCell"
let reuseActionableCard = "ActionableCard"


extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
