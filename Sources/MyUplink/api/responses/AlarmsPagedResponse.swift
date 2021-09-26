//
//  AlarmsPagedResponse.swift
//  MyUplink
//
//  Created by Thomas Kausch on 26.09.21.
//

import Foundation


public struct AlarmsPagedResponse: Decodable {
    
    let page: Int
    let itemsPerPage: Int
    let numItems: Int
    
    let notifications: [Alarm]?
}
