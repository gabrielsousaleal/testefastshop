//
//  DetalhesViewController.swift
//  testefastshop
//
//  Created by Gabriel Sousa on 10/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class DetalhesViewController: UIViewController {
    
    //STORYBOARD
    
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var notaIMDBLabel: UILabel!
    @IBOutlet var duracaoLabel: UILabel!
    @IBOutlet var paisLabel: UILabel!
    @IBOutlet var lancamentoLabel: UILabel!
    @IBOutlet var lingueLabel: UILabel!
    @IBOutlet var sinopseLabel: UILabel!
    @IBOutlet var tituloOriginalLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var popularidadeLabel: UILabel!
    @IBOutlet var generosLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var idiomaOriginalLabel: UILabel!
    @IBOutlet var sobreBotao: UIButton!
    @IBOutlet var informacoesBotao: UIButton!
    @IBOutlet var faixavermelhaSobre: UIView!
    @IBOutlet var faixavermelhaInformacoes: UIView!
    @IBOutlet var sobreView: UIView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var rendaFixo: UILabel!
    @IBOutlet var producaoFixo: UILabel!
    @IBOutlet var botaoSite: UIButton!
    @IBOutlet var scrollviewContainer: UIView!
    @IBOutlet var custoLabel: UILabel!
    @IBOutlet var prodocaoLabel: UILabel!
    @IBOutlet var imagemNota: UIImageView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var botaoFavorito: UIButton!
    
    //STORYBOARD TITULOS
    
    @IBOutlet var tagline: UILabel!
    @IBOutlet var popularidade: UILabel!
    @IBOutlet var renda: UILabel!
    @IBOutlet var custo: UILabel!
    
    
    //VARIÁVEIS
    
    var filme: FilmeObjeto!
    var listaFaixas: [UIView] = []
    var listaBotoes: [UIButton] = []
    var viewsScrollView: [UIView] = []
    var constraints: [NSLayoutConstraint] = []
    var opcao = ""
    var favorito = false
    
    
    //MARK: FUNCOES DA VIEW
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        verificarFavorito()
               
        //FUNCOES DE POPULAR SAO PARA COLOCAR OS ELEMENTOS EM LISTAS, PARA FACILITAR O DESLIGAMENTO/ATIVAMENTO DE TODAS
        popularListaDeFaixas()
               
        popularListaDeBotoes()
               
        popularListaDeViewsDaScroll()
               
        //INICIAR COM A ABA DE SOBRE DA SCROLL VIEW ACIONADA POR PADRÃO
        acionarBotaoSobre(sobreBotao)
        
        DAOFilme().pegarFilmeDetalhado(id: filme.filmeDecodable?.id ?? 0, tipo: filme.tipo ?? "") { filme in
            DispatchQueue.main.async {
                self.filme = filme.first
                
                self.preencherLabelsGenericas()
                
                if self.filme.tipo == "movie" {
                    self.preencherLabelsFilme()
                } else {
                    self.preencherLabelsSerie()
                }
                
            }
        }
                
    }
    
    
    //MARK: FUNCOES CONTROLLER
    
    func acionarBotao(botao: UIButton, opcao: String){
        
        //DESATIVAR O BOTAO ACIONADO ANTERIORMENTE
        desativarTodosOsBotoes()
        
        botao.setTitleColor(.white, for: .normal)
        
        self.opcao = opcao
        
        if opcao == "informacoes" {
            faixavermelhaInformacoes.isHidden = false
        } else {
            faixavermelhaSobre.isHidden = false
        }
        
    }
    
    func desativarTodosOsBotoes(){
        
        //SEMPRE QUE DESATIVAR ALGUM BOTAO, VOLTAR A SCROLL PARA O INICIO
        scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        for botao in listaBotoes {
            botao.setTitleColor(.lightGray, for: .normal)
        }
        
        for faixa in listaFaixas {
            faixa.isHidden = true
        }
        
        //ESCONDER AS VIEWS DA SCROLL VIEW. UMA SCROLL VIEW SERÁ MOSTRADA AO ACIONAR UM BOTAO
        for view in viewsScrollView {
            view.isHidden = true
        }
    }
    
    func preencherLabelsFilme(){
        
        tituloLabel.text = filme.filmeDecodable?.title ?? "N/A"
        paisLabel.text = filme.pais ?? "N/A"
        lingueLabel.text = filme.idiomas ?? "N/A"
        rendaFixo.text = filme.renda ?? "N/A"
        generosLabel.text = filme.generos ?? "N/A"
        lancamentoLabel.text = filme.filmeDecodable?.release_date ?? "N/A"
        tituloOriginalLabel.text = filme.filmeDecodable?.original_title ?? "N/A"
        duracaoLabel.text = "\(filme.filmeDecodable?.runtime ?? 0) min"
        idiomaOriginalLabel.text = filme.filmeDecodable?.original_language ?? "N/A"
        statusLabel.text = filme.filmeDecodable?.status ?? "N/A"
        custoLabel.text = filme.custo ?? "N/A"
        popularidadeLabel.text = String(filme.filmeDecodable?.popularity ?? 0)
        taglineLabel.text = filme.filmeDecodable?.tagline ?? "N/A"
        
    }
    
    func preencherLabelsGenericas() {
        
        DAOFilme().baixarPoster(path: filme?.filmeDecodable?.poster_path ?? "", tamanho: 600) { poster in
                   
                   DispatchQueue.main.async {
                       self.posterView.image = poster
                   }
                   
               }
        
        let imagem = filme.estrela
               
        imagemNota.image = imagem
        
        if filme.filmeDecodable?.vote_average != nil {
            notaIMDBLabel.text = "\(filme.filmeDecodable?.vote_average ?? 0)/10"
        } else {
            notaIMDBLabel.text = "filme sem nota"
        }
        
        sinopseLabel.text = filme.filmeDecodable?.overview ?? ""
        
        prodocaoLabel.text = filme.producao ?? "N/A"
        
    }
    
    func preencherLabelsSerie(){
        
        tituloLabel.text = filme.filmeDecodable?.name ?? "N/A"
        lancamentoLabel.text = filme.filmeDecodable?.first_air_date ?? "N/A"
        duracaoLabel.text = "\(filme.filmeDecodable?.episode_run_time?.first ?? 0) min"
        
        popularidade.text = "Criadores"
        popularidadeLabel.text = filme.criadores ?? "N/A"
        lingueLabel.text = filme.idiomasSerie ?? "N/A"
        paisLabel.text = filme.filmeDecodable?.origin_country?.first ?? "N/A"
        tituloOriginalLabel.text = filme.filmeDecodable?.original_name ?? "N/A"
        idiomaOriginalLabel.text = filme.filmeDecodable?.original_language ?? "N/A"
        generosLabel.text = filme.generos
        statusLabel.text = filme.statusSerie ?? "N/A"
        
        tagline.text = "Episodios"
        taglineLabel.text = "\(filme.filmeDecodable?.number_of_episodes ?? 0)"
        
        custo.text = "Temporadas"
        custoLabel.text = "\(filme.filmeDecodable?.number_of_seasons ?? 0)"
        
        renda.text = "Última estréia"
        rendaFixo.text = filme.filmeDecodable?.last_air_date ?? "N/A"
        
    }
    
    func verificarFavorito(){
        
        //VERIFICAR SE O FILME ESTÁ NA LISTA DE FAVORITOS
        let favoritos = DAOFilme().pegarListaFavoritos()
        
        for favorito in favoritos {
            if favorito.id ?? 0 == filme?.filmeDecodable?.id ?? 0 {
                self.favorito = true
                botaoFavorito.setImage(UIImage(named:"favoritoSelecionado"), for: .normal)
            }
        }
    }
    
    func popularListaDeFaixas(){
        listaFaixas.append(faixavermelhaSobre)
        listaFaixas.append(faixavermelhaInformacoes)
    }
    
    func popularListaDeBotoes(){
        listaBotoes.append(sobreBotao)
        listaBotoes.append(informacoesBotao)
    }
    
    func popularListaDeViewsDaScroll(){
        viewsScrollView.append(sobreView)
        viewsScrollView.append(infoView)
    }
    
    
    
    //MARK: FUNCOES STORYBOARD
    
    @IBAction func acionarBotaoSobre(_ sender: UIButton) {
        
        acionarBotao(botao: sender, opcao: "sobre")
        
        // FAZENDO O CONSTRAINT DA VIEW SOBRE(SCROLLVIEW), PARA QUE O TAMANHO DA VIEW ACOMPANHE A POSICAO DO ULTIMO ELEMENTO
        for constraint in constraints {
            scrollviewContainer.removeConstraint(constraint)
        }
        
        let botContainer = NSLayoutConstraint(item: scrollviewContainer!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: idiomaOriginalLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 15)
        
         let sobreBot = NSLayoutConstraint(item: sobreView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: idiomaOriginalLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 15)
        
        constraints.append(botContainer)
        
        scrollviewContainer.addConstraint(botContainer)
        
        sobreView.addConstraint(sobreBot)
        
        sobreView.isHidden = false
        
    }
    
    @IBAction func acionarBotaoInformacoes(_ sender: UIButton) {
        
        acionarBotao(botao: sender, opcao: "informacoes")
        
        // FAZENDO O CONSTRAINT DA VIEW INFORMACOES(SCROLLVIEW), PARA QUE O TAMANHO DA VIEW ACOMPANHE A POSICAO DO ULTIMO ELEMENTO
        let botContainer = NSLayoutConstraint(item: scrollviewContainer!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: botaoSite, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 15)
        
        constraints.append(botContainer)
        
        scrollviewContainer.addConstraint(botContainer)
        
        infoView.isHidden = false
        
    }
    
    @IBAction func botaoVoltar(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func irParaOSite(_ sender: Any) {
        
        //SE NAO HOUVER SITE, MOSTRAR UM ALERT COMO FEEDBACK
        if filme?.filmeDecodable?.homepage == nil{
            
            let alert = UIAlertController(title: "Ops!", message: "Esse filme não tem um site", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            
        }
        
        if let url = URL(string: filme?.filmeDecodable?.homepage ?? ""){
            UIApplication.shared.open(url)
        } else {
            
            let alert = UIAlertController(title: "Ops!", message: "Esse filme não tem um site", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            
        }
        
    }
    
    @IBAction func favoritar(_ sender: UIButton) {
        
        //SE JÁ FOR FAVORITO, DESFAVORITAR E MUDAR A IMAGEM DO CORAÇÃO(BOTAO FAVORITO)
        if favorito{
            
            DAOFilme().desfavoritar(filme: filme?.filmeDecodable?.id ?? 0 )
            
            sender.setImage(UIImage(named: "favorito"), for: .normal)
            
            favorito = false
            
        } else {
            
            let fav = Favorito(id: filme?.filmeDecodable?.id ?? 0, tipo: filme?.tipo ?? "")
            
            DAOFilme().salvarFilmeFavorito(filme: fav)
            
            sender.setImage(UIImage(named: "favoritoSelecionado"), for: .normal)
            
            favorito = true
            
        }
        
        
        
        
        
    }
    
    
    
}


extension DetalhesViewController {
     override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
