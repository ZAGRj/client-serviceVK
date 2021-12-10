//
//  LoginFormController.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 30.10.2021.
//

import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var LoginInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!

    var logoView: UIView?
    var visualEffectScreen: UIView?
    
// MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        ScrollView?.addGestureRecognizer(hideKeyboardGesture)
        screenLogo()
        }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserData()
            
        if !checkResult {
                showLoginError()
        }
        return checkResult
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

// MARK: FUNCTIONS
    
    func checkUserData() -> Bool {
    guard let login = LoginInput.text,
          let password = PasswordInput.text else { return false }
            
        if login == "admin" && password == "123456" {
                return true
            } else {
                return false
            }
        }
        
    func showLoginError() {
        
        let alter = UIAlertController(title: "Неверный логин или пароль", message: "Проверьте правильность введённых данных", preferredStyle: .alert)
            
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
        }
 
//     MARK: View for Logo Animation Start Screen
    
    func screenLogo() {
        blurMotion()
        registerLoadView()
        UIView.animate(withDuration: 2,
            delay: 4.5,
            options: [.transitionCrossDissolve],
            animations: {[weak self] in
        self?.visualEffectScreen?.alpha = 0},
            completion: nil)
        UIView.animate(withDuration: 1.5,
            delay: 4.5,
            options: [.transitionCrossDissolve],
            animations: {[weak self] in
        self?.logoView?.alpha = 0
        self?.logoView?.transform = CGAffineTransform(scaleX: 10, y: 10)},
            completion: nil)
        }

    func blurMotion() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectScreen = UIVisualEffectView(effect: blurEffect)
        visualEffectScreen.frame = self.view.frame
        self.view.addSubview(visualEffectScreen)
        self.visualEffectScreen?.alpha = 0.8
        self.visualEffectScreen = visualEffectScreen
        UIView.transition(with: self.view,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {[weak self] in
        self?.view.addSubview(visualEffectScreen)},
            completion: nil)
    }
    
// MARK: PRIVATE FUNCTIONS
    
    private func registerLoadView() {
        guard let viewLogoVK = UINib(nibName: "LoadView", bundle: .main).instantiate(withOwner: nil, options: nil).first as? UIView else { return }
        self.logoView = viewLogoVK
        viewLogoVK.center.x = self.view.center.x
        viewLogoVK.center.y = self.view.center.y
        self.view.addSubview(viewLogoVK)
    }

//    MARK: @IBACTIONS

    @IBAction func loginButtonPressed(_ sender: Any) {
            
        let login = LoginInput.text!
        let password = PasswordInput.text!
        if login == "admin" && password == "123456" {
                print("Успешная авторизация")
        } else {
                print("Введён неверный логин или пароль")
            }
        }
    
    @IBAction func logOut (segue: UIStoryboardSegue) {
        LoginInput.text = nil
        PasswordInput.text = nil
        }
    
// MARK: @OBJC FUNCTIONS
    
    @objc func hideKeyboard() {
        self.ScrollView?.endEditing(true)
        }
    
    @objc func keyboardWasShown(notification: Notification) {
            
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            
        self.ScrollView?.contentInset = contentInsets
        ScrollView?.scrollIndicatorInsets = contentInsets
        }
        
     
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        ScrollView?.contentInset = contentInsets
    }
}
