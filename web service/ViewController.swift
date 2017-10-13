//
//  ViewController.swift
//  web service
//
//  Created by Jhonatan Garcia on 11/10/17.
//  Copyright © 2017 Jhonatan Garcia. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var precoBitCoin: UILabel!
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitCoin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recuperarPrecoBitCoin()
    }
    
    func formatarPreco(preco: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")

        if let precoFinal = nf.string(from: preco) {
            return precoFinal
        }
        
        return "0,00"
    }
    
    func recuperarPrecoBitCoin(){
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dadosRetorno = dados {
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno,  options: []) as? [String: Any] {
                                
                                if let brl = objetoJson["BRL"] as? [String: Any] {
                                    if let preco = brl["buy"] as? Double {
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value:preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitCoin.text = "R$ " + precoFormatado
                                            self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                        })
                                     }
                                }
                            }
                        } catch {
                            print("Erro na formatação do JSON")
                        }
                    }
                } else {
                    print("Erro ao fazer a consulta do preço")
                }
            }
            tarefa.resume()
        }
    }
}

