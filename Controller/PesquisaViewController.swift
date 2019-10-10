//
//  PesquisaViewController.swift
//  testefastshop
//
//  Created by Gabriel Sousa on 10/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class PesquisaViewController: UIViewController {
    
    //STORYBOARD
    @IBOutlet var botaoFilme: UIButton!
    @IBOutlet var botaoTvShow: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var botaolimpar: UIButton!
    @IBOutlet var searchbarView: UIView!
    @IBOutlet var faixavermelhaFilmes: UIView!
    @IBOutlet var faixavermelhaTvShow: UIView!
    @IBOutlet var botaoFavoritos: UIButton!
    @IBOutlet var faixavermelhaFavoritos: UIView!
    
    //VARIÁVEIS
    var filtro = ""
    var botoes: [UIButton] = []
    var faixas: [UIView] = []
    var timer: Timer!
    var listaFilmes: [FilmeObjeto] = []
    var textoPesquisado = ""
    var minimoDeCaracteres = 4
    var imagemFilmeNaoEncontrado: UIImageView?
    
    
    //MARK: FUNCOES DA VIEW
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        popularBotoes()
        
        esconderTeclado()
        
        setarTodosOsLayouts()
        
        setarDelegates()
        
        selecionarUmFiltro(filtro: "movie", botao: botaoFilme)
           
    }
    
    
    
    //MARK: FUNÇÃO COLLECTION VIEW
       
//       @objc func recarregarFavoritos(){
//
//           DAOFilme().pegarFavoritos { listaFavoritos in
//
//               DispatchQueue.main.async {
//                   // REMOVER A LISTA DE FILMES ANTERIOR
//                   self.listaFilmes.removeAll()
//
//                   //SE NAO TIVER NADA DIGITADO NA SEARCHBAR, MOSTRAR TODOS OS SEUS FAVORITOS COMO PADRÃO
//                   if self.textoPesquisado.count == 0 {
//                       self.listaFilmes = listaFavoritos
//                       self.collectionView.reloadData()
//                       return
//                   }
//
//                   var listaPesquisa: [FilmeObjeto] = []
//
//                   //FOR PARA VERIFICAR SE EXISTE UM FILME NOS FAVORITOS COM O TITULO DIGITADO NA SEARCHBAR
//                   for filme in listaFavoritos {
//
//                       let titulo = filme.filmeDecodable?.Title ?? ""
//
//                       let textoPesquisadoFavorito = self.textoPesquisado.replacingOccurrences(of: "_", with: " ")
//
//                       if (titulo.lowercased().contains(textoPesquisadoFavorito.lowercased())){
//                           listaPesquisa.append(filme)
//                       }
//
//                   }
//
//                   self.listaFilmes = listaPesquisa
//
//                   self.collectionView.reloadData()
//
//               }
//           }
//
       //}

       @objc func recarregarCollectionView(){
           
           //SE ESTIVER NO FILTRO DE FAVORITOS, FAZER OUTRO TIPO DE PESQUISA

           if filtro == "favoritos" {
               
              // recarregarFavoritos()
               
           } else {
               
           // SE NAO ATINGIR O MÍNIMO DE CARACTERES PARA PESQUISA, NÃO MOSTRAR RESULTADOS
           if textoPesquisado.count < minimoDeCaracteres && filtro != "favoritos"{
               listaFilmes.removeAll()
               collectionView.reloadData()
               return
           }
           
           //FUNCAO PARA BAIXAR OS FILMES, PASSANDO NOME E FILTRO (TYPE)
           DAOFilme().buscarFilmePorNome(nome: textoPesquisado, pagina: 1, filtro: filtro){ filmes in
               
               DispatchQueue.main.async {
                
                   self.listaFilmes.removeAll()
                   self.listaFilmes = filmes
                   self.collectionView.reloadData()
                
               }
               
           }
           
           }
       }
    
    
    
    //MARK: FUNCOES DE FILTRO
       
    func selecionarUmFiltro(filtro: String, botao: UIButton){
        
        //ZERAR O FILTRO ESCOLHIDO ANTERIORMENTE

        if self.filtro == filtro { return }
        
        desabilitarTodosOsFiltros()
        
        botao.setTitleColor(.white, for: .normal)
        
        self.filtro = filtro
        
        recarregarCollectionView()
        
        //SE FOR MUDADO DE FILTRO, SUBIR A SCROLL PARA O TOPO
        
        if listaFilmes.count > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        
        switch filtro {
        case "movie":
            faixavermelhaFilmes.isHidden = false
        case "tv":
            faixavermelhaTvShow.isHidden = false
        case "favoritos":
            faixavermelhaFavoritos.isHidden = false
        default:
            print("falha ao mudar faixa vermelha")
        }
        
        
    }
       
    func desabilitarTodosOsFiltros(){
        
        filtro = ""
        
        for botao in botoes {
            botao.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal
            )
        }
        for faixa in faixas {
            faixa.isHidden = true
        }
    }
       
    func popularBotoes(){
        
        //BOTOES E FAIXAS EM LISTAS, PARA FACILITAR O "DESATIVAMENTO" DELES
        
        botoes.append(botaoFilme)
        botoes.append(botaoTvShow)
        botoes.append(botaoFavoritos)
        
        faixas.append(faixavermelhaFilmes)
        faixas.append(faixavermelhaTvShow)
        faixas.append(faixavermelhaFavoritos)
    }
    
    
    //MARK: LAYOUT
    
    func setarLayoutCells(){
        
        let screen = UIScreen.main.bounds
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screen.width/2.15, height: screen.height/2.65)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func setarLayoutBotaoLimpar(){
        
        botaolimpar.backgroundColor = .red
        
        botaolimpar.layer.borderColor = UIColor.red.cgColor
        
        botaolimpar.layer.borderWidth = 1
        
        botaolimpar.isHidden = true
    }
    
    func setarLayoutSearchbar(){
        searchbarView.layer.borderColor = UIColor.white.cgColor
        searchbarView.layer.borderWidth = 1
    }
    
    func setarLayoutTextField(){
        let textFieldDaSearchbar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldDaSearchbar.clearButtonMode = .never
        textFieldDaSearchbar.tintColor = .white
        textFieldDaSearchbar.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    func setarTodosOsLayouts(){
        
        setarLayoutBotaoLimpar()
        
        setarLayoutSearchbar()
        
        setarLayoutTextField()
        
        setarLayoutCells()
        
    }
    
    
    
    //MARK: FUNCOES DE IMAGENS
    
    func mostrarImagemFilmeNaoEncontrado(){
        
        imagemFilmeNaoEncontrado = UIImageView(frame: collectionView.frame)
        
        imagemFilmeNaoEncontrado?.frame.size.height = collectionView.frame.size.height / 2.5
        
        imagemFilmeNaoEncontrado?.frame.size.width = collectionView.frame.size.width / 2.5
        
        imagemFilmeNaoEncontrado?.center = collectionView.center
        
        imagemFilmeNaoEncontrado?.contentMode = .scaleAspectFill
        
        //SE NÃO HOUVER INTERNET, SEMPRE MOSTRAR A IMAGEM DE SEM INTERNET.
        if !Internet.isConnectedToNetwork() {
            imagemFilmeNaoEncontrado?.image = UIImage(named: "semInternet")
        }else{
            imagemFilmeNaoEncontrado?.image = UIImage(named: "notfound")
        }
        
        self.view.addSubview(imagemFilmeNaoEncontrado ?? UIImageView())
        
    }
    
    func verificarFavorito(filmeID: String) -> Bool{
        
        //FUNCAO PARA VERIFICAR SE UM FILME ESTÁ NA SUA LISTA DE FAVORITOS
        
        let favoritos = DAOFilme().pegarListaFavoritos()
        
        for favorito in favoritos {
            if favorito == filmeID {
               return true
            }
        }
        
        return false
    }
    
    
    
    
    //MARK: FUNCOES STORYBOARD
    
    @IBAction func botaoLimparTexto(_ sender: Any) {
        
        botaolimpar.isHidden = true
        
        textoPesquisado = ""
        
        searchBar.text = ""
        
        recarregarCollectionView()
        
    }
    
    @IBAction func filtrarPorFilme(_ botao: UIButton) {
        
        selecionarUmFiltro(filtro: "movie", botao: botao)
        
    }
    
    @IBAction func filtrarPorTvShow(_ botao: UIButton) {
        
        selecionarUmFiltro(filtro: "tv", botao: botao)
        
    }
        
    @IBAction func filtrarPorFavoritos(_ sender: UIButton) {
        
        searchBar.text = ""
        
        textoPesquisado = ""
        
        selecionarUmFiltro(filtro: "favoritos", botao: sender)
        
    }
    
    @objc func removerFavoritoPesquisa(sender: UIButton){
        
//        //PEGAR POSICAO DO FILME NO ARRAY
//        guard let index = (sender.layer.value(forKey: "index")) as? Int else {
//            return
//        }
//
//        let filme = self.listaFilmes[index]
//
//        let id =  filme.filmeDecodable?.imdbID
//
//        DAOFilmes().removerFavorito(id: id ?? "")
//
//        //SE ESTIVER NA ABA DE FAVORITOS, REMOVER O FILME DA LISTA DE PESQUISA TAMBEM
//        if filtro == "favoritos" {
//
//            for (i,filme) in listaFilmes.enumerated() {
//
//                if filme.filmeDecodable?.imdbID == id {
//                    listaFilmes.remove(at: i)
//                }
//
//            }
//
//        }
//
//        collectionView.reloadData()
        
    }
    
    @objc func adicionarFavorito(sender: UIButton){
        
//        //PENGANDO A POSICAO DO FILME NO ARRAY
//        guard let index = (sender.layer.value(forKey: "index")) as? Int else {
//            return
//        }
//
//        let filme = self.listaFilmes[index]
//
//        let id =  filme.filmeDecodable?.imdbID
//
//        DAOFilmes().salvarFilmeFavorito(filme: id ?? "")
//
//        collectionView.reloadData()
        
    }

    func setarDelegates(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
    
    
    
}

//MARK: COLLECTIONVIEW DELEGATE

extension PesquisaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //SE NAO HOUVER RESULTADO, MOSTRAR FEEDBACK VISUAL
        if listaFilmes.count == 0 {
            imagemFilmeNaoEncontrado?.removeFromSuperview()
            mostrarImagemFilmeNaoEncontrado()
        }
                
        return listaFilmes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //SEMPRE QUE A COLLECTION VIEW FOR ATUALIZADA, SIGNIFICA QUE HOUVE ALGUM RESULTADO DE FILME, ENTÃO O FEEDBACK É REMOVIDO
        imagemFilmeNaoEncontrado?.removeFromSuperview()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PesquisaCell", for: indexPath) as! PesquisaCell
        
        let filme = listaFilmes[indexPath.row]
        
        print(filme)
        
        cell.notaImagem.image = filme.estrela
        
        var titulo: String?
        
        if let nome = filme.filmeDecodable?.title {
            titulo = nome
        } else {
            titulo = filme.filmeDecodable?.name
        }
        
        cell.tituloLabel.text = titulo ?? ""
        
        var lancamento: String?
        
        if let data = filme.filmeDecodable?.release_date {
            lancamento = data
        } else {
            lancamento = filme.filmeDecodable?.first_air_date
        }
        
        cell.lancamentoLabel.text = "\(lancamento ?? "")"
        
        cell.posterView.image = filme.posterUIImage
        cell.favorito.isHidden = false
        cell.favorito.layer.setValue(indexPath.row, forKey: "index")
        
        //VERIFICAR SE O FILME ESTÁ NA SUA LISTA DE FAVORITOS
        let id = String(filme.filmeDecodable?.id ?? 0)
        let favorito = verificarFavorito(filmeID: id)
        
        //ADICIONANDO ACOES PARA O BOTAO FAVORITO E DANDO UMA IMAGEM PARA ELE DE ACORDO COM O RESULTADO
        if favorito {

            cell.favorito.addTarget(self, action: #selector(removerFavoritoPesquisa), for: UIControl.Event.touchUpInside)
            cell.favorito.setImage(UIImage(named: "favoritoSelecionado"), for: .normal)

        } else {
            
            cell.favorito.setImage(UIImage(named: "favorito"), for: .normal)
            cell.favorito.addTarget(self, action: #selector(adicionarFavorito), for: UIControl.Event.touchUpInside)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let filme = listaFilmes[indexPath.row]
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "DetalhesStoryBoard", bundle:nil)
//
//        let detalhesViewController = storyBoard.instantiateViewController(withIdentifier: "DetalhesViewController") as! DetalhesViewController
//
//        detalhesViewController.filmeID = filme.filmeDecodable?.imdbID
//
//        navigationController?.pushViewController(detalhesViewController, animated: true)
        
    }
}

//MARK: ESCONDER TECLADO

extension PesquisaViewController {
    
    func esconderTeclado() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dispensarTeclado))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dispensarTeclado() {
        view.endEditing(true)
    }
}

//MARK: SEARCHBAR DELEGATE

extension PesquisaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        let textoDigitado = searchBar.text ?? " "
        
        //A API REGISTRA OS ESPAÇOS COM _ ENTÃO OS ESPAÇOS DIGITADOS DEVEM SER SUBSTITUIDOS
        textoPesquisado = textoDigitado.replacingOccurrences(of: " ", with: "+")
        
        //SE NÃO HOUVER TEXTO DIGITADO, ESCONDER O BOTAO LIMPAR
        if textoPesquisado.count > 0 {
            botaolimpar.isHidden = false
        }
        
        //CHAMANDO A FUNCAO QUE BAIXA OS FILMES SEMPRE QUE HOUVER UMA DIGITAÇÃO NOVA
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(recarregarCollectionView), userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dispensarTeclado()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dispensarTeclado()
    }
    
}

extension PesquisaViewController {
     override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
