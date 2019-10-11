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
    let created_by: [created_by]?
    let episode_run_time: [Int]?
    let in_production: Bool?
    let languages: [String]?
    let number_of_episodes: Int?
    let production_companies: [production_companies]?
    
    //FILME DETALHADO
    let budget: Float?
    let genres: [genres]?
    let homepage: String?
    let production_countries: [production_countries]?
    let runtime: Int?
    let spoken_languages: [spoken_languages]?
    let imdb_id: String?
    let revenue: Int?
    let status: String?
    let tagline: String?
    let origin_country: [String]?
    let original_name: String?
    let number_of_seasons: Int?
    let last_air_date: String?
    
}

//MARK: STRUCTS SERIE DETALHADA

struct created_by: Decodable {
    
    let id: Int?
    let credit_id: String?
    let name: String?
    let gender: Int?
    let profile_path: String?
    
}


//MARK: STRUCTS FILME DETALHADO

struct production_companies: Decodable {
    
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

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

//MARK: OBJETO

class FilmeObjeto {
    
    let filmeDecodable: FilmeDecodable?
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
    
    
    init(filmeDecodable: FilmeDecodable, completion: @escaping (FilmeObjeto) -> () ) {
        
        self.filmeDecodable = filmeDecodable
        self.overview = filmeDecodable.overview
        DAOFilme().baixarPoster(path: filmeDecodable.poster_path ?? "") { imagem in
            
            self.estrela = verificarEstrelas(nota: filmeDecodable.vote_average ?? 0)
            
            self.tipo = verificarTipo(filme: filmeDecodable)
            
            if self.tipo == "movie" {
                                
                self.idiomas = montarLabelIdiomas(filme: filmeDecodable)
                
                self.pais = montarLabelPais(filme: filmeDecodable)
                
                self.renda = montarLabelRenda(filme: filmeDecodable)
                
                self.custo = montarLabelCusto(filme: filmeDecodable)
                
            } else {
                
                self.criadores = montarLabelCriadoPor(filme: filmeDecodable)
                
                self.idiomasSerie = montarLabelIdiomasSerie(filme: filmeDecodable)
                
                self.statusSerie = montarLabelStatusSerie(filme: filmeDecodable)
                
            }
            
            self.generos = montarLabelGeneros(filme: filmeDecodable)
            
            self.producao = montarLabelProducao(filme: filmeDecodable)
            
            self.posterUIImage = imagem
            
            completion(self)
            
        }
        
    }
    
}


//MARK: FUNCOES OBJ

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

//MARK: MONTAR LABELS FILME

func montarLabelGeneros(filme: FilmeDecodable) -> String {
    
    if (filme.genres ?? []).count == 0 { return "" }
    
    var generos = ""
    
    for genero in filme.genres ?? [] {
    
       generos += "\(genero.name!), "
        
    }
    
    //REMOVER O ULTIMO ESPACO E VIRGULA
    generos.removeLast()
    generos.removeLast()
    
    return generos
}

func montarLabelIdiomas(filme: FilmeDecodable) -> String {
    
    if filme.spoken_languages?.count == 0 { return "" }
    
    var idiomas = ""
    
    for idioma in filme.spoken_languages ?? [] {
        
        idiomas += "\(idioma.name ?? "")\n"
        
    }
    
    return idiomas
    
}

func montarLabelPais(filme: FilmeDecodable) -> String {
    
    if filme.production_countries?.count == 0 { return "" }
    
    var paises = ""
    
    for pais in filme.production_countries ?? [] {
        
        paises += "\(pais.name ?? "")\n"
        
    }
    
    return paises

}

func montarLabelProducao(filme:FilmeDecodable) -> String {
    
    if filme.production_companies?.count == 0 { return "N/A" }
    
    var producao = ""
    
    for produtora in filme.production_companies ?? [] {
        
        producao += "\(produtora.name ?? "")\n"
        
    }
        
    return producao
    
}

func montarLabelRenda(filme: FilmeDecodable) -> String {
    
    if filme.revenue == nil { return "" }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    var renda = formatter.string(from: filme.revenue! as NSNumber) ?? "N/A"
    
    renda.removeFirst()
    
    renda = "$ \(renda)"
    
    
    
    return renda
    
}

func montarLabelCusto(filme: FilmeDecodable) -> String {
    
    if filme.budget == nil { return "" }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    var custo = formatter.string(from: filme.budget! as NSNumber) ?? "N/A"
    
    custo.removeFirst()
    
    custo = "$ \(custo)"
    
    
    
    return custo
    
}

//MARK: MONTAR LABELS SERIE

func montarLabelCriadoPor(filme: FilmeDecodable) -> String {
    
    if filme.created_by?.count == 0 { return "N/A" }
    
    var criadores = ""
    
    for criador in filme.created_by ?? [] {
        
        criadores += "\(criador.name ?? "")\n"
        
    }
    
    return criadores
    
}

func montarLabelIdiomasSerie(filme: FilmeDecodable) -> String {
    
    if filme.languages?.count == 0 { return "N/A" }
    
    var idiomas = ""
    
    for idioma in filme.languages ?? [] {
        
        idiomas += "\(idioma)\n"
        
    }
    
    return idiomas
    
}

func montarLabelStatusSerie(filme: FilmeDecodable) -> String {
    
    if filme.in_production == nil { return "N/A" }
    
    var status = ""
    
    status = filme.in_production! ? "Em produção" : "Finalizado"
    
    return status
    
}




//MARK: FAVORITO

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
