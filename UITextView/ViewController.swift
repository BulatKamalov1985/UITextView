//
//  ViewController.swift
//  UITextView
//
//  Created by Bulat Kamalov on 08.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countLlabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        textView.isHidden = true
        
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.layer.cornerRadius = 10
        textView.backgroundColor = self.view.backgroundColor
        
        stepper.value = 17
        stepper.maximumValue = 25
        stepper.minimumValue = 4
        
        stepper.tintColor = .white
        stepper.backgroundColor = .red
        stepper.layer.cornerRadius = 10
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        activityIndicator.startAnimating()
        
        progressView.setProgress(0, animated: true)
       
        
        //Отслеживаем появление клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        //Отслеживаем скрытие клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
  
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.1
            } else {
                self.activityIndicator.stopAnimating()
                self.textView.isHidden = false
                self.progressView.isHidden = true
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @objc func updateTextView(notification: Notification) {
        
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - 164,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
        
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLlabel.text = "\(textView.text.count)"
        return true
    }
}
