//
//  ViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/13.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import ESTabBarController // 外部Tabバー
import Firebase           // Firebase
import FirebaseAuth       // Firebaseのログイン認証

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Tabバー初期設定
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 画面が表示された直後に呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ログイン判定
        if FIRAuth.auth()?.currentUser == nil {  // currentUserがnilならログインしていない
            // ログインしていなければログインの画面を表示　
            // 注：「DispatchQueue.main.async」で viewDidAppear() 終了後に実行させる（viewDidAppear内で present() が実行できないため）
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") // ログイン画面取得
                self.present(loginViewController!, animated: true, completion: nil) // ログイン画面を表示
            }
        }
    }
    
    /// Tabバーの初期設定
    func setupTab() {
        // 画像のファイル名を指定して ESTabBarController を作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // 色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)           // 選択時の色
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1) // 背景色
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        self.addChildViewController(tabBarController)          // 追加先のViewControllerを指定
        view.addSubview(tabBarController.view)                 // 親ビューに tabBarController.view を追加
        tabBarController.view.frame = view.bounds              // tabBarControllerのフレーム（境界）を親ビューの境界に合わせる
        tabBarController.didMove(toParentViewController: self) // 追加完了
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
        }, at: 1)
    }

}

