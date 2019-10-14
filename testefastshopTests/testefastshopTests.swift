//
//  testefastshopTests.swift
//  testefastshopTests
//
//  Created by Gabriel Sousa on 09/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import XCTest
import Foundation
import UIKit


@testable import testefastshop

class testefastshopTests: XCTestCase {
    
    var dao: DAOFilme!
    
    var pesquisaVC: PesquisaViewController!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dao = DAOFilme()
        
        pesquisaVC = UIStoryboard(name: "PesquisaStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "PesquisaViewController") as? PesquisaViewController
        
        pesquisaVC.preload()
              
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: TESTES DAO API
    func testarDAObuscarFilme(){
                
        let pesquisa = "Homem-aranha"
        
        let pagina = 1
        
        let filtro = "movie"
        
        var listaFilmes: [FilmeObjeto] = []
        
        let exp = expectation(description: "Pegar lista filmes")

        dao.buscarFilmePorNome(nome: pesquisa, pagina: pagina, filtro: filtro) { filmes in
            
            listaFilmes = filmes
            exp.fulfill()
            
        }
            
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            print("Total de resultados -> ", listaFilmes.count)
            XCTAssertLessThan(0, listaFilmes.count)
        }
        
        
    }
    
    func testarDAOpegarFilmeDetalhado(){
        
        let id = 34588
        
        let tipo = "movie"
        
        var filme: FilmeObjeto?
        
        let exp = expectation(description: "Pegar filme")
        
        dao.pegarFilmeDetalhado(id: id, tipo: tipo) { result in
            
            print(result.count)
            filme = result.first
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            print("Nome do filme -> ", filme?.filmeDecodable?.title ?? "")
            print("Nome da serie -> ", filme?.filmeDecodable?.name ?? "")
            XCTAssert(filme?.filmeDecodable?.id != nil, "Falha ao baixar filme")
        }
        
    }
    
    func testarDAObaixarPoster(){
        
        let path: String  = "/pC9oT3flvYS0foCEqugkBJ6E2yE.jpg"
        
        var poster: UIImage?
        
        let exp = expectation(description: "Pegar filme")
        
        dao.baixarPoster(path: path) { imagem in
            
            poster = imagem
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            print("tamanho da imagem -> ", poster?.size ?? 0)
            XCTAssert(poster != nil, "Falha ao baixar poster")
        }
        
        
    }
    
    
    //MARK: TESTES PESQUISA
    func testarPesquisaPorNome(){
        
        let nomePesquisa = "Homem-aranha"
        
        let pagina = 1
        
        let filtro = "movie"
        
        var listaFilmes: [FilmeObjeto] = []
        
        let exp = expectation(description: "Buscar Filmes")
        
        dao.buscarFilmePorNome(nome: nomePesquisa, pagina: pagina, filtro: filtro) { filmes in
            
            listaFilmes = filmes
            self.pesquisaVC.listaFilmes = listaFilmes
            self.pesquisaVC.collectionView.reloadData()
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
              XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertEqual(self.pesquisaVC.collectionView.numberOfItems(inSection: 0), listaFilmes.count, "Numero de itens da collection view deve ser igual ao numero de resultados da pesquisa por \(nomePesquisa)")
            
               }
        
       
        
        
        
    }
    
}


extension UIViewController {
   
    func preload() {
        _ = self.view
    }
   
}
