//
//  UserDefaults.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 03/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation

class UserDefaultsDAO {
    
    func salvarFilmeFavorito(filme: Favorito){
        
        var favoritos = pegarListaFavoritos()
        
        //SE JÁ ESTIVER NA LISTA DE FAVORITOS, SAIR DA FUNÇÃO
        for favorito in favoritos {
            if filme.id == favorito.id { return }
        }
        
        favoritos.append(filme)
        
        do {
            let encodedFilme: Data = try NSKeyedArchiver.archivedData(withRootObject: favoritos,  requiringSecureCoding: false)
            UserDefaults.standard.set(encodedFilme, forKey: "favoritos")
        } catch {
            print("erro ao salvar filme favorito")
        }
            
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
                
                do {
                    
                    let encodedFilme: Data = try NSKeyedArchiver.archivedData(withRootObject: favoritos,  requiringSecureCoding: false)
                    
                    UserDefaults.standard.set(encodedFilme, forKey: "favoritos")
                    
                } catch {
                    print("erro ao salvar filme favorito")
                }
                
            }
        }
        
        
        
    }
    
}
