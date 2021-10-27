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
//  Alarm.swift
//  MyUplink
//
//  Created by Thomas Kausch on 26.09.21.
//

import Foundation


public struct Alarm: Decodable {
    
    /// The id of the alarm stored in database
    let id: String
    /// The company´s id of the alarm.
    let alarmNumber: Int
    /// The device which the alarm belongs to.
    let deviceId: String
    /// Determines the severity of the alarm, 1 being the most severe
    let severity: AlarmSeverity
    // The Alarm status
    let status: AlarmState
    /// Date of the creation.    let status: AlarmStatusCode
    let createdDatetime: Date?
    /// Status history.
    let statusHistory: [AlarmStatus]?
    /// Localized alarm title.
    let header: String?
    /// Localized alarm description.
    let description: String?
    /// The name of the equipment.
    let equipName: String
}
