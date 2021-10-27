//
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
//  ParameterData.swift
//  MyUplink
//
//  Created by Thomas Kausch on 13.10.21.
//

import Foundation


public struct ParameterData: Decodable {
 
    let category: String?
    
    let parameterId: String?
    
    let parameterName: String?
    
    let parameterUnit: String?
    
    let writable: Bool
    
    let timestamp: Date
    
    let value: Double?
    
    let strValue: String?
    
    let smartHomeCategories: [String]?
    
    let minValue: Int?
    
    let maxValue: Int?
    
    let enumValues: [EnumValue]?
    
}
