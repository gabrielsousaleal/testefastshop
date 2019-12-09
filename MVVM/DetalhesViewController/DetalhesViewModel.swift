//
//  DetalhesViewModel.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 05/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation

class DetalhesViewModel {
    
    var filme: FilmeObjeto
    var servico: ServicosFilme
    
    init(filme: FilmeObjeto, servico: ServicosFilme) {
        self.filme = filme
        self.servico = servico
    }
    
    //*****************************************************
    //MARK: - Public Methods
    //*****************************************************
    
    func baixarDetalhesDoFilme(completion: @escaping(DetalhesViewModel) -> () ){
        let id = filme.filmeDecodable.id ?? 0
        let tipo = filme.tipo ?? ""
        servico.pegarFilmeDetalhado(id: id, tipo: tipo) { filmeObj in
            let filmeDecodable = filmeObj.first?.filmeDecodable
            self.filme.filmeDecodable = filmeDecodable
            self.formatLabels()
            completion(self)
        }
    }
    
    //*****************************************************
    //MARK: - Private Methods
    //*****************************************************
    
    private func formatLabels(){
        montarLabelPais()
        montarLabelCusto()
        montarLabelRenda()
        montarLabelGeneros()
        montarLabelIdiomas()
        montarLabelProducao()
        montarLabelCriadoPor()
        montarLabelStatusSerie()
        montarLabelIdiomasSerie()
    }
    
    private func montarLabelGeneros() {
        
        if (filme.filmeDecodable.genres ?? []).count == 0 { return }
        
        var generos = ""
        
        for genero in filme.filmeDecodable.genres ?? [] {
        
           generos += "\(genero.name!), "
            
        }
        
        //REMOVER O ULTIMO ESPACO E VIRGULA
        generos.removeLast()
        generos.removeLast()
        
        self.filme.generos = generos
    }

    private func montarLabelIdiomas() {
        
        if filme.filmeDecodable.spoken_languages?.count == 0 { return }
        
        var idiomas = ""
        
        for idioma in filme.filmeDecodable.spoken_languages ?? [] {
            
            idiomas += "\(idioma.name ?? "")\n"
            
        }
        
        self.filme.idiomas = idiomas
    }

    private func montarLabelPais() {
        
        if filme.filmeDecodable.production_countries?.count == 0 { return }
        
        var paises = ""
        
        for pais in filme.filmeDecodable.production_countries ?? [] {
            
            paises += "\(pais.name ?? "")\n"
            
        }
        
        self.filme.pais = paises
    }

    private func montarLabelProducao() {
        
        if filme.filmeDecodable.production_companies!.isEmpty { return }
        
        var producao = ""
        
        for produtora in filme.filmeDecodable.production_companies ?? [] {
            
            producao += "\(produtora.name ?? "")\n"
            
        }
        self.filme.producao = producao
    }

    private func montarLabelRenda() {
        
        if filme.filmeDecodable.revenue == nil { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        var renda = formatter.string(from: filme.filmeDecodable.revenue! as NSNumber) ?? "N/A"
        
        renda.removeFirst()
        
        renda = "\(renda)"
        
        self.filme.renda = renda
    }

    private func montarLabelCusto() {
        
        if filme.filmeDecodable.budget == nil { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        var custo = formatter.string(from: filme.filmeDecodable.budget! as NSNumber) ?? "N/A"
        
        custo.removeFirst()
        
        custo = "\(custo)"
        
        self.filme.custo = custo
    }

    private func montarLabelCriadoPor() {
        
        if filme.filmeDecodable.created_by?.count == 0 { return }
        
        var criadores = ""
        
        for criador in filme.filmeDecodable.created_by ?? [] {
            
            criadores += "\(criador.name ?? "")\n"
            
        }
        self.filme.criadores = criadores
    }

    private func montarLabelIdiomasSerie() {
        
        if filme.filmeDecodable.languages?.count == 0 { return }
        
        var idiomas = ""
        
        for idioma in filme.filmeDecodable.languages ?? [] {
            
            idiomas += "\(idioma)\n"
            
        }
        self.filme.idiomasSerie = idiomas
    }

    private func montarLabelStatusSerie() {
        
        if filme.filmeDecodable.in_production == nil { return }
        
        var status = ""
        
        status = filme.filmeDecodable.in_production! ? "Em produção" : "Finalizado"
        
        self.filme.statusSerie = status
    }
}
