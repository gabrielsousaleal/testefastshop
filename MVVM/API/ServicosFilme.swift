//
//  ServicosFilme.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 03/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import UIKit
import Alamofire

protocol ServicosFilmeProtocol: class {
    func buscarFilmePorNome(nome: String, pagina: Int, filtro: String, completion: @escaping(Swift.Result<[FilmeObjeto], Error>) -> ())
    func baixarPoster(path: String, tamanho: Int, completion: @escaping(UIImage) -> ())
    func pegarFilmeDetalhado(id: Int, tipo: String, completion: @escaping([FilmeObjeto]) -> ())
    func pegarFavoritos(completion: @escaping ([FilmeObjeto]) -> ())
}

class ServicosFilme: ServicosFilmeProtocol {
    
    func buscarFilmePorNome(nome: String, pagina: Int, filtro: String, completion: @escaping(Swift.Result<[FilmeObjeto], Error>) -> ()) {
        
        var listaFilmesObj: [FilmeObjeto] = []
        
        let url = "https://api.themoviedb.org/3/search/\(filtro)?api_key=dcf373a212e3fd454f97f09a273a42e2&query=\(nome)&language=pt-BR&page=\(pagina)"
        
        //TRATANDO CARACTERES ESPECIAIS NA URL
        let urlComespecial = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let request = NSMutableURLRequest(url: NSURL(string: urlComespecial)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let erro = error {
                completion(Swift.Result.failure(erro))
            }
            
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Lista.self, from: data)
                    let informacoesPesquisa = try JSONDecoder().decode(InformacoesPesquisa.self, from: data)
                    let semaforo = DispatchSemaphore(value: 1)
                    if informacoesPesquisa.total_pages < pagina {
                        semaforo.signal()
                        completion(Swift.Result.success(listaFilmesObj))
                    }
                    
                    for filme in json.results {
                        
                        let filme = FilmeObjeto(filmeDecodable: filme)
                        
                        listaFilmesObj.append(filme)
                        if listaFilmesObj.count == json.results.count{
                            semaforo.signal()
                            completion(Swift.Result.success(listaFilmesObj))
                        }
                }
                    //USO DE SEMAFORO PARA ESPERAR QUE O FOR SEJA TOTALMENTE EXECUTADO
                    semaforo.wait()
                } catch {
                    print(error)
                    completion(Swift.Result.success(listaFilmesObj))
                }
            }
        })
        dataTask.resume()
        
    }
    
    func baixarPoster(path: String, tamanho: Int = 300, completion: @escaping(UIImage) -> ()){
        
        var tamanho = tamanho
        
        //O TAMANHO MAXIMO É 500
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
    
    func pegarFilmeDetalhado(id: Int, tipo: String, completion: @escaping ([FilmeObjeto]) -> ()){
        
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
                    
                    let filme = FilmeObjeto(filmeDecodable: json)

                    listaFilmesObj.append(filme)
                    completion(listaFilmesObj)
                } catch {
                    print(error)
                    completion(listaFilmesObj)
                }
            }
        })
        
        dataTask.resume()
        
        
        
    }
    
    func pegarFavoritos(completion: @escaping ([FilmeObjeto]) -> ()){
        
        var listaFilmes: [FilmeObjeto] = []
        
        let listaFilmesId = UserDefaultsDAO().pegarListaFavoritos()
        
        if listaFilmesId.count == 0 {
            completion([])
        } else {
            let semaforo = DispatchSemaphore.init(value: 2)
            DispatchQueue.main.async {
                for filme in listaFilmesId {
                    self.pegarFilmeDetalhado(id: filme.id!,tipo: filme.tipo!) { filme in
                        
                        let filmeObj = FilmeObjeto(filmeDecodable: filme[0].filmeDecodable!)
                        
                        listaFilmes.append(filmeObj)
                        if listaFilmesId.count == listaFilmesId.count {
                            semaforo.signal()
                            completion(listaFilmes)
                        }
                    }
                }
                //USO DE SEMAFORO PARA ESPERAR QUE O FOR SEJA TOTALMENTE EXECUTADO
                semaforo.wait()
            }
        }
    }
    
}
