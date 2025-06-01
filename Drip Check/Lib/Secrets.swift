//
//  Secrets.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import Foundation

class Secrets{
    static var OPEN_AI_KEY  = Bundle.main.infoDictionary?["OPEN_AI_KEY"] as? String
}
