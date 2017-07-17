//
//  Gettable.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import SwiftNetworking

/// Describes the behavior of an object which retrieves a singular instance of generic type `Data` and a collection of generic type `Data`.
protocol Gettable {
    associatedtype Data

    func get(completion: @escaping (Result<Data>) -> Void)
    
    func getArray(completion: @escaping (Result<[Data]>) -> Void)
}
