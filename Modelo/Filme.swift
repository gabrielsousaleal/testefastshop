//
//  Filme.swift
//  testefastshop
//
//  Created by Gabriel Sousa on 09/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit


//MARK: DECODABLE

struct InformacoesPesquisa: Decodable {
    
    let total_pages: Int
    let total_results: Int
    let page: Int
    
}

struct Lista: Decodable {
    
    let results: [FilmeDecodable]
    
}

struct FilmeDecodable: Decodable {
    
    //FILME
    let title: String?
    let overview: String?
    let release_date: String?
    let original_language: String?
    let original_title: String?
    let genre_ids: [Int]?
    let backdrop_path: String?
    let adult: Bool?
    let poster_path: String?
    let id: Int?
    let popularity: Float?
    let vote_count: Int?
    let video: Bool?
    let vote_average: Float?
    
    //SERIE
    let name: String?
    let first_air_date: String?
    
}

class FilmeObjeto {
    
    let filmeDecodable: FilmeDecodable?
    let overview: String?
    var posterUIImage: UIImage?
    var estrela: UIImage?
    
    
    init(filmeDecodable: FilmeDecodable, completion: @escaping (FilmeObjeto) -> () ) {
        
        self.filmeDecodable = filmeDecodable
        self.overview = filmeDecodable.overview
        DAOFilme().baixarPoster(path: filmeDecodable.poster_path ?? "") { imagem in
            
            self.estrela = verificarEstrelas(nota: filmeDecodable.vote_average ?? 0)
            
            self.posterUIImage = imagem
            completion(self)
            
        }
        
    }
    
}


//FUNCOES

func verificarEstrelas(nota: Float) -> UIImage{
    
    var nomeImagem = ""
    
    let nota = nota.rounded()
        
    switch nota {
        case 0:
            nomeImagem = "0star"
        case 1:
            nomeImagem = "0Meiostar"
        case 2:
            nomeImagem = "1star"
        case 3:
            nomeImagem = "1Meiostar"
        case 4:
            nomeImagem = "2star"
        case 5:
            nomeImagem = "2Meiostar"
        case 6:
            nomeImagem = "3star"
        case 7:
            nomeImagem = "3Meiostar"
        case 8:
            nomeImagem = "4star"
        case 9:
            nomeImagem = "4Meiostar"
        case 10:
            nomeImagem = "5star"
        default:
            nomeImagem = "0star"
        }
    
    return UIImage(named: nomeImagem) ?? UIImage()
    
    
}
