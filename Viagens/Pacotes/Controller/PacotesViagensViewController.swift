import UIKit

class PacotesViagensViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var colecaoPacoteViagens: UICollectionView!
    
    @IBOutlet weak var pesquisarViagens: UISearchBar!
    
    @IBOutlet weak var labelContadorDePacotes: UILabel!
    
    let listaComTodasViagens: Array<PacoteViagem> = PacoteViagemDAO().retornaTodasAsViagens()
    var listaViagens: Array<PacoteViagem> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaViagens = listaComTodasViagens
        colecaoPacoteViagens.dataSource = self
        colecaoPacoteViagens.delegate = self
        pesquisarViagens.delegate = self
        self.labelContadorDePacotes.text = self.atualizaContadorLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listaViagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celulaPacote = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPacote", for: indexPath) as! PacoteViagemCollectionViewCell
        
        let pacoteAtual = listaViagens[indexPath.item]
        celulaPacote.configurarCelula(pacoteViagem: pacoteAtual)
        return celulaPacote
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone ? CGSize (width: collectionView.bounds.width/2-20, height: 160) : CGSize (width: collectionView.bounds.width/3-20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pacote = listaViagens[indexPath.item]
        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "detalhes") as! DetalhesViagensViewController
        controller.pacoteSelecionado = pacote
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        listaViagens = listaComTodasViagens
        
        if (searchText != "") {
            let filtroListaViagem = NSPredicate(format: "viagem.titulo CONTAINS[cd] %@", searchText)
//            let filtroListaViagem = NSPredicate(format: "viagem.titulo contains %@", searchText)
            let listaFiltrada:Array<PacoteViagem> = (listaViagens as NSArray).filtered(using: filtroListaViagem) as! Array
            listaViagens = listaFiltrada
            print(listaFiltrada)
        }

        self.labelContadorDePacotes.text = self.atualizaContadorLabel()
        colecaoPacoteViagens.reloadData()
    }
    
    func atualizaContadorLabel() -> String{
        return listaViagens.count == 1 ? "1 pacote" : "\(listaViagens.count) pacotes encontrados"
    }
}
