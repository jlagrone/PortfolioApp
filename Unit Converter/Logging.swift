//
//  Logging.swift
//  Unit Converter
//
//  Created by James LaGrone on 11/16/21.
//

import Foundation
import os

// swiftlint:disable private_over_fileprivate
fileprivate let bundleIdentifier = Bundle.main.bundleIdentifier!

// swiftlint:disable identifier_name
let log_general = OSLog(subsystem: bundleIdentifier, category: "general")
// swiftlint:disable identifier_name
let log_settings = OSLog(subsystem: bundleIdentifier, category: "settings")
