//
//  DAOFilme.swift
//  testefastshop
//
//  Created by Gabriel Sousa on 09/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

class DAOFilme {
    
    func buscarFilmePorNome(nome: String, pagina: Int, filtro: String, completion: @escaping([FilmeObjeto]) -> () ) {
        
        var listaFilmesObj: [FilmeObjeto] = []
               
        let url = "https://api.themoviedb.org/3/search/\(filtro)?api_key=dcf373a212e3fd454f97f09a273a42e2&query=\(nome)&language=pt-BR&page=\(pagina)"
               
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                                   timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
            if let erro = error {
                    print(erro.localizedDescription)
                    completion(listaFilmesObj)
                }
                
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Lista.self, from: data)
                    
                    let informacoesPesquisa = try JSONDecoder().decode(InformacoesPesquisa.self, from: data)
                    
                    print(informacoesPesquisa.total_pages)
                        
                    let semaforo = DispatchSemaphore(value: 1)
                    
                    if informacoesPesquisa.total_pages < pagina {
                        semaforo.signal()
                        completion(listaFilmesObj)
                    }
                    
                        for filme in json.results {
                            
                            _ = FilmeObjeto(filmeDecodable: filme) { result in
                                
                                listaFilmesObj.append(result)
                                
                                if listaFilmesObj.count == json.results.count{
                                    semaforo.signal()
                                    completion(listaFilmesObj)
                                    
                                }
                        
                      }
                    }
                        
                        //USO DE SEMAFORO PARA ESPERAR QUE O FOR SEJA TOTALMENTE EXECUTADO
                        semaforo.wait()
                        
                    } catch {
                       
                        print(error)
                        
                        completion(listaFilmesObj)
                    }
                }
                
                 
               })

               dataTask.resume()
 
    }
    
    func baixarPoster(path: String, tamanho: Int = 300, completion: @escaping(UIImage) -> () ){
        
        var tamanho = tamanho
        
        if tamanho > 500 { tamanho = 500 }
        
        let url = "http://image.tmdb.org/t/p/w\(tamanho)\(path)"
                
       Alamofire.request(url).responseImage { (response) in
           if let result = response.result.value {
               completion(result)
           } else {
               completion(UIImage(named: "posterNaoEncontrado") ?? UIImage())
           }
       }

    }
    
    func pegarFilmeDetalhado(id: Int, tipo: String, completion: @escaping ([FilmeObjeto]) -> () ){
        
        var listaFilmesObj: [FilmeObjeto] = []
                
        let url = "https://api.themoviedb.org/3/\(tipo)/\(id)?api_key=dcf373a212e3fd454f97f09a273a42e2&language=pt-BR"
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                                   timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
            if let erro = error {
                    print(erro.localizedDescription)
                    completion([])
                }
                
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(FilmeDecodable.self, from: data)
                                                    
                    _ = FilmeObjeto(filmeDecodable: json) { result in
                                                        
                        listaFilmesObj.append(result)
                                
                        completion(listaFilmesObj)

                      }
                        
                    } catch {
                       
                        print(error)
                        
                        completion(listaFilmesObj)
                    }
                }
                
                 
               })

               dataTask.resume()
        
        
   
    }
    
    func pegarFavoritos(completion: @escaping ([FilmeObjeto]) -> () ){
        
        var listaFilmes: [FilmeObjeto] = []
        
        let listaFilmesId = DAOFilme().pegarListaFavoritos()
        
        if listaFilmesId.count == 0 {
            completion([])
        } else {
            
            let semaforo = DispatchSemaphore.init(value: 2)
            
            
            DispatchQueue.main.async {
                
                for filme in listaFilmesId {
                    
                    DAOFilme().pegarFilmeDetalhado(id: filme.id!,tipo: filme.tipo!) { filme in
                        _ = FilmeObjeto(filmeDecodable: filme[0].filmeDecodable!, completion: { filmeObj in
                            
                                listaFilmes.append(filmeObj)
                                if listaFilmesId.count == listaFilmesId.count {
                                    semaforo.signal()
                                    completion(listaFilmes)
                                }
                            
                        })

                    }
                }
                
                //USO DE SEMAFORO PARA ESPERAR QUE O FOR SEJA TOTALMENTE EXECUTADO
                semaforo.wait()
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    //MARK: USERDEFAULTS
    
    func salvarFilmeFavorito(filme: Favorito){
        
        var favoritos = pegarListaFavoritos()
        
        //SE JÁ ESTIVER NA LISTA DE FAVORITOS, SAIR DA FUNÇÃO
        for favorito in favoritos {
            if filme.id == favorito.id { return }
        }
        
        favoritos.append(filme)
        
        let encodedFilme: Data = NSKeyedArchiver.archivedData(withRootObject: favoritos)
    
        UserDefaults.standard.set(encodedFilme, forKey: "favoritos")
        
        
    }
    
    func pegarListaFavoritos() -> [Favorito]{
        
        let decoded  = UserDefaults.standard.data(forKey: "favoritos")
        
        if decoded == nil {
            return []
        }
        
        let decodedFilmes = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? [Favorito] ?? []
                        
        return decodedFilmes
        
    }
    
    func desfavoritar(filme: Int){
        
        var favoritos = pegarListaFavoritos()
                        
        for (i,favorito) in favoritos.enumerated() {
            if favorito.id == filme {
                favoritos.remove(at: i)
                let encodedFilme: Data = NSKeyedArchiver.archivedData(withRootObject: favoritos)
                UserDefaults.standard.set(encodedFilme, forKey: "favoritos")
            }
        }
        
        
        
    }
    
}
