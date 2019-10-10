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
    
    let belogins_to_collection: [String:String]?
    
  
//       "belongs_to_collection":{
//          "id":556,
//          "name":"Homem-Aranha",
//          "poster_path":"/A39vPpNgZtQhe6sl0MUSyNKGLFS.jpg",
//          "backdrop_path":"/waZqriYTuBE3WqXI3SDGi3kfDQE.jpg"
//       },
//       "budget":200000000,
//       "genres":[
//          {
//             "id":28,
//             "name":"Ação"
//          },
//          {
//             "id":12,
//             "name":"Aventura"
//          },
//          {
//             "id":14,
//             "name":"Fantasia"
//          }
//       ],
//       "homepage":"http://www.sonypictures.com/movies/spider-man2/",
//       "id":558,
//       "imdb_id":"tt0316654",
//       "original_language":"en",
//       "original_title":"Spider-Man 2",
//       "overview":"Após derrotar o Duende Verde a vida de Peter Parker (Tobey Maguire) muda por completo. Temendo que Mary Jane (Kirsten Dunst) sofra algum risco por ser ele o Homem-Aranha, Peter continua escondendo o amor que sente e se mantém longe dela. Ao mesmo tempo precisa lidar com Harry (James Franco), seu melhor amigo, cuja raiva pelo Homem-Aranha aumenta cada vez mais por considerá-lo como sendo o assassino de seu pai. Além disso sua tia May (Rosemary Harris) passa por uma fase difícil após a morte de seu tio Ben, estranhando também o comportamento do sobrinho. Enquanto precisa lidar com seus problemas particulares Peter recebe ainda uma má notícia: o surgimento do Dr. Octopus (Alfred Molina), um homem que possui tentáculos presos ao corpo.",
//       "popularity":10.908,
//       "poster_path":"/41CX8g39cqdA83fAkoZ1SM6d4oG.jpg",
//       "production_companies":[
//          {
//             "id":5,
//             "logo_path":"/71BqEFAF4V3qjjMPCpLuyJFB9A.png",
//             "name":"Columbia Pictures",
//             "origin_country":"US"
//          },
//          {
//             "id":326,
//             "logo_path":null,
//             "name":"Laura Ziskin Productions",
//             "origin_country":""
//          },
//          {
//             "id":19551,
//             "logo_path":"/2WpWp9b108hizjHKdA107hFmvQ5.png",
//             "name":"Marvel Enterprises",
//             "origin_country":"US"
//          },
//          {
//             "id":34,
//             "logo_path":"/GagSvqWlyPdkFHMfQ3pNq6ix9P.png",
//             "name":"Sony Pictures",
//             "origin_country":"US"
//          }
//       ],
//       "production_countries":[
//          {
//             "iso_3166_1":"US",
//             "name":"United States of America"
//          }
//       ],
//       "release_date":"2004-06-25",
//       "revenue":783766341,
//       "runtime":127,
//       "spoken_languages":[
//          {
//             "iso_639_1":"en",
//             "name":"English"
//          },
//          {
//             "iso_639_1":"ru",
//             "name":"Pусский"
//          },
//          {
//             "iso_639_1":"zh",
//             "name":"普通话"
//          }
//       ],
//       "status":"Released",
//       "tagline":"Este é o meu presente . Esta é a minha maldição.",
//       "title":"Homem-Aranha 2",
//       "video":false,
//       "vote_average":7.0,
//       "vote_count":8557
//    }
    
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
