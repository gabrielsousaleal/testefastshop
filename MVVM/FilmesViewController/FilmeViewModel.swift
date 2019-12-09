//
//  FilmeViewModel.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 03/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import UIKit

class FilmeViewModel {
    
    //*****************************************************
    //MARK:PROPRIEDADES PUBLICAS
    //*****************************************************
    
    var reload: (() -> Void)?
    
    var filmes: [FilmeObjeto] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reload?()
            }
        }
    }
    
    var pagina = 1
    
    //*****************************************************
    //MARK:PROPRIEDADES PRIVADAS
    //*****************************************************
    
    private var servicoFilmes: ServicosFilmeProtocol!
    
    private var listaFilmes: [FilmeObjeto] = []
    
    //*************************************************
    // MARK: - Inits
    //*************************************************
    
    init(servicoFilmes: ServicosFilmeProtocol) {
        self.servicoFilmes = servicoFilmes
    }
}

//*****************************************************
//MARK: METODOS PUBLICOS
//*****************************************************

extension FilmeViewModel {
    
    func pesquisarFilme(nome: String, filtro: String) {
        self.servicoFilmes.buscarFilmePorNome(nome: nome, pagina: self.pagina, filtro: filtro) { result in
            switch result {
            case .success(let filmes):
                self.filmes += filmes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func pesquisarFilmeFavorito(textoPesquisado: String) {
        DAOFilme().pegarFavoritos { listaFavoritos in
            self.filmes.removeAll()
            
            if textoPesquisado.isEmpty {
                self.filmes = listaFavoritos
                return
            }
            
            var listaPesquisa: [FilmeObjeto] = []
            
            //FOR PARA VERIFICAR SE EXISTE UM FILME NOS FAVORITOS COM O TITULO DIGITADO NA SEARCHBAR
            for filme in listaFavoritos {
                
                //SE FOR FILME PEGAR O title E SE FOR SERIE PEGAR O name
                let titulo = filme.filmeDecodable?.title ?? filme.filmeDecodable?.name ?? ""
                
                let textoPesquisadoFavorito = textoPesquisado.replacingOccurrences(of: "+", with: " ")
                
                if (titulo.lowercased().contains(textoPesquisadoFavorito.lowercased())){
                    listaPesquisa.append(filme)
                }
            }
            self.filmes = listaPesquisa
        }

    }
}

