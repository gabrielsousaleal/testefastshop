//
//  FilmeObjeto.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 05/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import UIKit

class FilmeObjeto {
    
    var filmeDecodable: FilmeDecodable! 
    let overview: String?
    var posterUIImage: UIImage?
    var estrela: UIImage?
    var tipo: String?
    
    //FILME
    var generos: String?
    var idiomas: String?
    var pais: String?
    var producao: String?
    var renda: String?
    var custo: String?
    
    //SERIE
    var criadores: String?
    var idiomasSerie: String?
    var statusSerie: String?
    
    
    init(filmeDecodable: FilmeDecodable) {
                
        self.filmeDecodable = filmeDecodable
        
        self.overview = filmeDecodable.overview
        
    }
    
}

