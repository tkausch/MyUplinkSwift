//
//  Copyright (C) 2021 Thomas Kausch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//
//
//  PremiumFeatureSubscription.swift
//  MyUplink
//
//  Created by Thomas Kausch on 20.10.21.
//

import Foundation


public struct PremiumFeatureResponseModel {
    let validUntil: Date?
    let type: PremiumFeature
    
    enum CodingKeys: String, CodingKey {
          case validUntil
          case type
    }
}

extension PremiumFeatureResponseModel: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validUntil = try container.decode(String.self, forKey: .validUntil).iso8601WithFractionalSeconds
        type = try container.decode(PremiumFeature.self, forKey: .type)
    }
}
