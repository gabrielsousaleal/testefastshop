//
//  FilmesViewController.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 03/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class FilmesViewController: UIViewController {
    
    //*****************************************************
    //MARK: - Storyboard Outlets
    //*****************************************************
    
    @IBOutlet weak var botaoLimpar: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var faixaVermelhaTvShow: UIView!
    @IBOutlet weak var faixaVermelhaFilmes: UIView!
    @IBOutlet weak var botaoFilme: UIButton!
    @IBOutlet weak var botaoTvShow: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var botaoFavoritos: UIButton!
    @IBOutlet weak var faixaVermelhaFavoritos: UIView!
    
    //*****************************************************
    //MARK: - Private Proprieties
    //*****************************************************
    
    private var viewModel: FilmeViewModel!
    private var timer: Timer!
    private var textoPesquisado = ""
    private var filtro = ""
    private let minimoDeCaracteres = 2
    private var botoes: [UIButton] = []
    private var faixas: [UIView] = []
    private var imagemFilmeNaoEncontrado: UIImageView?
    
    //*****************************************************
    //MARK: - Inits
    //*****************************************************
    
    func setup(viewModel: FilmeViewModel) {
        self.viewModel = viewModel
        registrarObservables()
    }
    
    //*****************************************************
    //MARK: - Life Cycle
    //*****************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FilmeCell2", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FilmeCell2")
        setarDelegates()
        esconderTeclado()
        setarTodosOsLayouts()
        popularBotoes()
        
        selecionarUmFiltro(filtro: "movie", botao: botaoFilme)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //RECARREGAR TELA, SE A TELA FOR A DE FAVORITOS, RECARREGAR OS FILMES NOVAMENTE, POIS PODE TER SIDO ATUALIZADA ( REMOVIDO UM FAVORITO, PELA TELA DE DETALHES)
        if filtro == "favoritos"{
            recarregarCollectionView()
        }
        else {
            //RECARREGAR APENAS A COLLECTION VIEW, PARA ATUALIZAR A IMAGEM DO BOTAO DE FAVORITO DA CELULA
            collectionView.reloadData()
        }
    }
    
    func registrarObservables() {
        viewModel.reload = {
            self.collectionView.reloadData()
        }        
    }
    
    //*****************************************************
    //MARK: - Storyboard Actions
    //*****************************************************
    
    @IBAction func filmesAction(_ sender: Any) {
        selecionarUmFiltro(filtro: "movie", botao: botaoFilme)
        
    }
    
    @IBAction func seriesAction(_ sender: Any) {
        selecionarUmFiltro(filtro: "tv", botao: botaoTvShow)
        
    }
    
    @IBAction func favoritosAction(_ sender: Any) {
        searchBar.text = ""
        textoPesquisado = ""
        selecionarUmFiltro(filtro: "favoritos", botao: botaoFavoritos)
    }
    
    @IBAction func limparAction(_ sender: Any) {
        botaoLimpar.isHidden = true
        textoPesquisado = ""
        searchBar.text = ""
        recarregarCollectionView()
    }
}

//*****************************************************
//MARK: Private Methods
//*****************************************************

extension FilmesViewController {
    
    private func mostrarImagemFilmeNaoEncontrado(){
        
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
    
    private func setarDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
    
    private func popularBotoes(){
        //BOTOES E FAIXAS EM LISTAS, PARA FACILITAR O "DESATIVAMENTO" DELES
        botoes.append(botaoFilme)
        botoes.append(botaoTvShow)
        botoes.append(botaoFavoritos)
        
        faixas.append(faixaVermelhaFilmes)
        faixas.append(faixaVermelhaTvShow)
        faixas.append(faixaVermelhaFavoritos)
    }
    
    private func desabilitarTodosOsFiltros(){
        filtro = ""
        
        for botao in botoes {
            botao.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal
            )
        }
        
        for faixa in faixas {
            faixa.isHidden = true
        }
    }
    
    private func selecionarUmFiltro(filtro: String, botao: UIButton){
        //ZERAR O FILTRO ESCOLHIDO ANTERIORMENTE
        if self.filtro == filtro { return }
        desabilitarTodosOsFiltros()
        self.filtro = filtro
        
        botao.setTitleColor(.white, for: .normal)
        recarregarCollectionView()
        
        //SE FOR MUDADO DE FILTRO, SUBIR A SCROLL PARA O TOPO
        if !viewModel.filmes.isEmpty {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            viewModel.filmes.removeAll()
        }
        
        switch filtro {
        case "movie":
            faixaVermelhaFilmes.isHidden = false
        case "tv":
            faixaVermelhaTvShow.isHidden = false
        case "favoritos":
            faixaVermelhaFavoritos.isHidden = false
        default:
            print("falha ao mudar faixa vermelha")
        }
    }
    
    private func setarLayoutCells() {
        let screen = UIScreen.main.bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screen.width/2.15, height: screen.height/2.65)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
    }
    
    private func setarLayoutBotaoLimpar() {
        botaoLimpar.backgroundColor = .red
        botaoLimpar.layer.borderColor = UIColor.red.cgColor
        botaoLimpar.layer.borderWidth = 1
        botaoLimpar.isHidden = true
    }
    
    private func setarLayoutSearchbar() {
        searchBarView.layer.borderColor = UIColor.white.cgColor
        searchBarView.layer.borderWidth = 1
    }
    
    private func setarLayoutTextField() {
        let textFieldDaSearchbar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldDaSearchbar.clearButtonMode = .never
        textFieldDaSearchbar.tintColor = .white
        textFieldDaSearchbar.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    private func setarTodosOsLayouts(){
        setarLayoutBotaoLimpar()
        setarLayoutSearchbar()
        setarLayoutTextField()
        setarLayoutCells()
    }
    
}

//*****************************************************
//MARK: Collection View Functions
//*****************************************************

extension FilmesViewController {
    
    //MARK: FUNÇÃO COLLECTION VIEW
    
    @objc func recarregarFavoritos(){
        viewModel.pesquisarFilmeFavorito(textoPesquisado: textoPesquisado)
    }
    
    @objc func puxarProximaPagina(){
        //IR PARA PROXIMA PAGINA
        viewModel.pagina += 1
        //FILTRO FAVORITOS NAO  TEM PAGINAÇAO
        if filtro == "favoritos" {
            return
        } else {
            //FUNCAO PARA BAIXAR OS FILMES, PASSANDO NOME E FILTRO (TYPE)
            viewModel.pesquisarFilme(nome: textoPesquisado, filtro: filtro)
        }
    }
    
    @objc func recarregarCollectionView(){
        
        viewModel.pagina = 1
        
        //SE ESTIVER NO FILTRO DE FAVORITOS, FAZER OUTRO TIPO DE PESQUISA
        
        if filtro == "favoritos" {
            recarregarFavoritos()
        } else {
            // SE NAO ATINGIR O MÍNIMO DE CARACTERES PARA PESQUISA, NÃO MOSTRAR RESULTADOS
            if textoPesquisado.count < minimoDeCaracteres && filtro != "favoritos"{
                viewModel.filmes.removeAll()
                return
            }
            viewModel.pesquisarFilme(nome: textoPesquisado, filtro: filtro)
        }
    }
}

//*****************************************************
//MARK: Collection View Data Source/Delegate
//*****************************************************

extension FilmesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.filmes.isEmpty {
            imagemFilmeNaoEncontrado?.removeFromSuperview()
            mostrarImagemFilmeNaoEncontrado()
        }
        return viewModel.filmes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //SEMPRE QUE A COLLECTION VIEW FOR ATUALIZADA, SIGNIFICA QUE HOUVE ALGUM RESULTADO DE FILME, ENTÃO O FEEDBACK É REMOVIDO
        imagemFilmeNaoEncontrado?.removeFromSuperview()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmeCell2", for: indexPath) as! FilmeCell2
        let filme =  viewModel.filmes[indexPath.row]
        let servico = ServicosFilme()
        let viewModel = FilmesCellViewModel(filme: filme, servico: servico)
        cell.config(viewModel: viewModel)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //SE O ULTIMO FILME DA LISTA FOR MOSTRADO, CHAMAR A PROXIMA PAGINA
        if indexPath.row == viewModel.filmes.count - 1 {
            puxarProximaPagina()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let filme = viewModel.filmes[row]
        let viewModel = DetalhesViewModel(filme: filme, servico: ServicosFilme())
        
        let storyboard = UIStoryboard(name: "DetalhesStoryBoard", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? DetalhesViewController else { return }
        
        viewController.setup(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//*****************************************************
//MARK: SearchBar Delegate
//*****************************************************

extension FilmesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        let textoDigitado = searchBar.text ?? " "
        
        //A API REGISTRA OS ESPAÇOS COM + ENTÃO OS ESPAÇOS DIGITADOS DEVEM SER SUBSTITUIDOS
        textoPesquisado = textoDigitado.replacingOccurrences(of: " ", with: "+")
        
        //SE NÃO HOUVER TEXTO DIGITADO, ESCONDER O BOTAO LIMPAR
        if textoPesquisado.count > 0 {
            botaoLimpar.isHidden = false
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

//*****************************************************
//MARK: ESCONDER TECLADO
//*****************************************************

extension FilmesViewController {
    
    func esconderTeclado() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dispensarTeclado))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dispensarTeclado() {
        view.endEditing(true)
    }
}
