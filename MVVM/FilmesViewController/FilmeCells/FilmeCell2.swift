//
//  FilmeCell2.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 03/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class FilmeCell2: UICollectionViewCell{
    
    //*****************************************************
    //MARK: Storyboard Outlets
    //*****************************************************
    var viewModel: FilmesCellViewModel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var lancamentoLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var notaImagem: UIImageView!
    @IBOutlet weak var favorito: UIButton!
    @IBOutlet weak var degradeView: UIImageView!
    
    func config(viewModel: FilmesCellViewModel) {
        self.viewModel = viewModel
        
        baixarPoster()
        
        notaImagem.image = viewModel.filme.estrela
        
        var titulo: String?
        
        if let nome = viewModel.filme.filmeDecodable?.title {
            titulo = nome
        } else {
            titulo = viewModel.filme.filmeDecodable?.name
        }
        
        tituloLabel.text = titulo ?? ""
        
        var lancamento: String?
        
        if let data = viewModel.filme.filmeDecodable?.release_date {
            lancamento = data
        } else {
            lancamento = viewModel.filme.filmeDecodable?.first_air_date
        }
        
        lancamentoLabel.text = "\(lancamento ?? "")"
        
        posterView.image = viewModel.filme.posterUIImage
        favorito.isHidden = false
        
        //VERIFICAR SE O FILME ESTÁ NA SUA LISTA DE FAVORITOS
        let id = viewModel.filme.filmeDecodable?.id ?? 0
        
        let favorito = verificarFavorito(filmeID: id)
        
        //ADICIONANDO ACOES PARA O BOTAO FAVORITO E DANDO UMA IMAGEM PARA ELE DE ACORDO COM O RESULTADO
        if favorito {
            self.favorito.addTarget(self, action: #selector(removerFavoritoPesquisa), for: UIControl.Event.touchUpInside)
            self.favorito.setImage(UIImage(named: "favoritoSelecionado"), for: .normal)
        } else {
            self.favorito.setImage(UIImage(named: "favorito"), for: .normal)
            self.favorito.addTarget(self, action: #selector(adicionarFavorito), for: UIControl.Event.touchUpInside)
        }
    }
    
    func baixarPoster() {
        viewModel.baixarPoster { imagem in
            self.posterView.image = imagem
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterView.image = nil
    }
    
}

//*****************************************************
//MARK: FUNCOES FAVORITOS
//*****************************************************

extension FilmeCell2 {

    func verificarFavorito(filmeID: Int) -> Bool {
        let dao = UserDefaultsDAO()
        //FUNCAO PARA VERIFICAR SE UM FILME ESTÁ NA SUA LISTA DE FAVORITOS
        
        let favoritos = dao.pegarListaFavoritos()
        
        for favorito in favoritos {
            if favorito.id == filmeID {
                return true
            }
        }
        return false
    }
    
    @objc func removerFavoritoPesquisa() {
        let dao = UserDefaultsDAO()
        guard let id = viewModel!.filme.filmeDecodable?.id else { return }
        dao.desfavoritar(filme: id)
        
        //SE ESTIVER NA ABA DE FAVORITOS, REMOVER O FILME DA LISTA DE PESQUISA TAMBEM
//        if filtro == "favoritos" {
//            for (i,filme) in listaFilmes.enumerated() {
//                if filme.filmeDecodable?.id ?? 0 == id {
//                    listaFilmes.remove(at: i)
//                }
//            }
//        }
        self.favorito.setImage(UIImage(named: "favorito"), for: .normal)
    }

    @objc func adicionarFavorito() {
        let dao = UserDefaultsDAO()
        guard let id = viewModel.filme.filmeDecodable?.id, let tipo = viewModel.filme.tipo else { return }
        let favorito = Favorito(id: id, tipo: tipo)
        dao.salvarFilmeFavorito(filme: favorito)
        self.favorito.setImage(UIImage(named: "favoritoSelecionado"), for: .normal)
    }
}
