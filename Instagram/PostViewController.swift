//
//  PostViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/13.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    
    // 受け取り用のプロパティ
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    /// 投稿ボタン
    @IBAction func handlePostButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5) // UIImageをJPG変換（第2引数は圧縮率）
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters) // JPGをBase64文字列に変換
        
        // postDataに必要な情報を取得しておく
        let time = NSDate.timeIntervalSinceReferenceDate    // 時間（文字列で保存するため timeIntervalSinceReferenceDate で取得）
        let name = FIRAuth.auth()?.currentUser?.displayName
        
        // 辞書（連想配列）を作成してFirebaseに保存する
        let postRef = FIRDatabase.database().reference().child(Const.PostPath) // 保存用のインスタンス作成
        let postData = [
            "caption": textField.text!,
            "image"  : imageString,
            "time"   : String(time),
            "name"   : name!
        ]
        postRef.childByAutoId().setValue(postData) // IDを自動生成しながら保存する
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる（前面のViewControllerを取得して閉じる）
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    /// キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 背景タップでキーボード閉じる
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // ライブラリ/カメラから受け取った画像をImageViewに設定する
        imageView.image = image
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
