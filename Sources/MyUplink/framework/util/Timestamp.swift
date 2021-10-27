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
//  Timestamp.swift
//  myuplink
//
//  Created by Thomas Kausch on 14.05.21.
//

import Foundation


///  Timestamps have the ISO-8601 format 'YYYY-MM-DDTHH:MM:SSZ' in UTC.
public typealias Timestamp = String

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    /// An Iso8601Formatter with internet Date and time in second precision.
    static let iso8601Timestamp = ISO8601DateFormatter([.withInternetDateTime])
}

extension Date {
    /// Return date  as timestamp string in ISO-8601 format.
    public var iso8601Timestamp: Timestamp { return Formatter.iso8601Timestamp.string(from: self) }
}

extension String {
    /// Return date from timestamp string in ISO-8601 fromat.
    public var iso8601Timestamp: Date? { return Formatter.iso8601Timestamp.date(from: self) }
}
