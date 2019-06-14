import UIKit

class DetalhesViagensViewController: UIViewController {

    @IBOutlet weak var imagemPacoteViagem: UIImageView!
    @IBOutlet weak var labelTituloPacoteViagem: UILabel!
    @IBOutlet weak var labelDescricaoPacoteViagem: UILabel!
    @IBOutlet weak var labelDataViagem: UILabel!
    @IBOutlet weak var labelPrecoPacoteViagem: UILabel!
    @IBOutlet weak var scrollPrincipal: UIScrollView!
    @IBOutlet weak var textFieldData: UITextField!
    
    var pacoteSelecionado:PacoteViagem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(aumentarScroll(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        if let pacote = pacoteSelecionado{
            self.imagemPacoteViagem.image = UIImage.init(named: pacote.viagem.caminhoDaImagem)
            self.labelTituloPacoteViagem.text = pacote.viagem.titulo
            self.labelDescricaoPacoteViagem.text = pacote.descricao
            self.labelDataViagem.text = pacote.dataViagem
            self.labelPrecoPacoteViagem.text = pacote.viagem.preco
        }
    }
    
    @objc
    func aumentarScroll (notification: Notification){
        
        self.scrollPrincipal.contentSize = CGSize(width: self.scrollPrincipal.frame.width , height: self.scrollPrincipal.frame.height + 320)
        
        self.scrollPrincipal.contentOffset.y = 200
    }
    
    @objc
    func exbirDataTextField(sender: UIDatePicker){
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        self.textFieldData.text = formatador.string(from: sender.date)
    }
    
    @IBAction func textFieldEntrouFoco(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(exbirDataTextField(sender:)), for: .valueChanged)
        
    }
    
    @IBAction
    func botaoVoltar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func botaoFinalizarCompra(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "confirmacaoPagamento") as! ConfirmacaoPagamentoViewController
        controller.pacoteComprado =  pacoteSelecionado
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
