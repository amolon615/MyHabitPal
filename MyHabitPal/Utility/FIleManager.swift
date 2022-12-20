//
//  FIleManager.swift
//  MyHabitPal
//
//  Created by Artem on 20/12/2022.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
