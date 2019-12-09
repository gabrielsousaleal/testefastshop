//
//  Favorito.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 05/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation

class Favorito: NSObject, NSCoding {
    
    var id: Int?
    var tipo: String?

    init(id: Int, tipo: String) {
        self.id = id
        self.tipo = tipo
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let tipo = aDecoder.decodeObject(forKey: "tipo") as! String
        self.init(id: id, tipo: tipo)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(tipo, forKey: "tipo")
    }
}
