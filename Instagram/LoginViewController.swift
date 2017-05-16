//
//  LoginViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/13.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!

    /// ログインボタン
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            // アドレスとパスワードの値を変数へセット（セット失敗の場合はfalse＝何もしない）
            
            //--- バリデート
            if address.characters.isEmpty || password.characters.isEmpty {
                // アドレス、パスワードのいずれかでも未入力の場合、HUDでアラート表示
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()
            
            //--- ログイン処理
            // アドレスとパスワードでログイン実行。
            FIRAuth.auth()?.signIn(withEmail: address, password: password) { user, error in
                if let error = error {
                    // ログイン失敗の場合
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                } else {
                    // ログイン成功の場合
                    print("DEBUG_PRINT: ログインに成功しました。")
                    
                    // HUDを消す
                    SVProgressHUD.dismiss()
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    /// アカウント作成ボタン
    @IBAction func handleCreateAcountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // 各TextFieldの値を変数へセット（セット失敗の場合はfalse＝何もしない）
            
            //--- バリデート
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                // アドレス、パスワード、表示名が未入力の場合
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()
            
            //--- 登録処理
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると自動的にログインする
            FIRAuth.auth()?.createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    // ユーザー作成エラーの場合
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                // ユーザー作成成功の場合
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名（displayName）を登録する
                let user = FIRAuth.auth()?.currentUser // ログインユーザー情報を取得（未ログインの場合は nil を返却）
                if let user = user {
                    // 取得した user が nil でなければログイン成功と判定
                    let changeRequest = user.profileChangeRequest() // ユーザープロファイル変更リクエストのインスタンスを作成
                    changeRequest.displayName = displayName         // インスタンスに表示名をセット
                    changeRequest.commitChanges { error in          // ユーザープロファイル変更を実行
                        if let error = error {
                            // 登録エラーの場合
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "ユーザー作成時にエラーが発生しました。")
                        }
                        // 登録成功の場合
                        print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
                        
                        // HUDを消す
                        SVProgressHUD.dismiss()
                        
                        // 画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("DEBUG_PRINT: 表示名の登録に失敗しました。")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 背景タップでキーボード閉じる
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// キーボードを閉じる
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
