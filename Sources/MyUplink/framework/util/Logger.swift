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
//  Logger.swift
//  myuplink
//
//  Created by Thomas Kausch on 06.09.21.
//

import Foundation
import os.log


class Log {
    
    private var logger: Logger
    private static var _shared = Log()
    
    static var shared: Logger {
        get {
            return _shared.logger
        }
    }
    
    private init() {
        self.logger = Logger(subsystem: "com.nibe.myuplink.client", category: "main")
    }
    
}
