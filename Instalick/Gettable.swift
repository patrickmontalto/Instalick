//
//  Gettable.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import SwiftNetworking

protocol Gettable {
    associatedtype Data

    func get(completion: @escaping (Result<Data>) -> Void)
    
    func getArray(completion: @escaping (Result<[Data]>) -> Void)
}
