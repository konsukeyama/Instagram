//
//  CommentViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/17.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    // 受け取り用のプロパティ
    var postData: PostData!
    
    @IBOutlet weak var commentTextField: UITextField!

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
    
    /// コメント投稿ボタン
    @IBAction func handlePostButton(_ sender: Any) {
        if let commentUser = FIRAuth.auth()?.currentUser?.displayName {
            // コメントをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!) // DB参照
            postData.comments.append(commentUser + " : " + commentTextField.text!) // 配列に追加
            let comments = ["comments": postData.comments]                         // 保存する値の準備
            postRef.updateChildValues(comments)                                    // DBを更新する
            
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
            
            // 全てのモーダルを閉じる（前面のViewControllerを取得して閉じる）
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
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
