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
    
    //FILME DETALHADO
    let budget: Float?
    let genres: [genres]?
    let homepage: String?
    let production_countries: [production_countries]?
    let run_time: Int?
    let spoken_languages: [spoken_languages]?
    let imdb_id: String?
}

//MARK: STRUCTS FILME DETALHADO
struct genres: Decodable {
    
    let id: Int?
    let name: String?
    
}

struct production_countries: Decodable {
    
    let iso_3166_1: String?
    let name: String?
    
}

struct spoken_languages: Decodable {
    
    let iso_639_1: String?
    let name: String?
    
}

class FilmeObjeto {
    
    let filmeDecodable: FilmeDecodable?
    let overview: String?
    var posterUIImage: UIImage?
    var estrela: UIImage?
    var tipo: String?
    
    
    init(filmeDecodable: FilmeDecodable, completion: @escaping (FilmeObjeto) -> () ) {
        
        self.filmeDecodable = filmeDecodable
        self.overview = filmeDecodable.overview
        DAOFilme().baixarPoster(path: filmeDecodable.poster_path ?? "") { imagem in
            
            self.estrela = verificarEstrelas(nota: filmeDecodable.vote_average ?? 0)
            
            self.tipo = verificarTipo(filme: filmeDecodable)
            
            self.posterUIImage = imagem
            completion(self)
            
        }
        
    }
    
}


//FUNCOES

func verificarTipo(filme: FilmeDecodable) -> String {
    
    var tipo = ""
    
    if filme.name != nil {
       tipo = "tv"
    }
    
    if filme.title != nil {
       tipo = "movie"
    }
    
    return tipo
}

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
