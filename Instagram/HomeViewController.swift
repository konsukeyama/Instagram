//
//  HomeViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/13.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // Firebaseのクラスを保存するプロパティ（PostDataクラスの配列）
    var postArray: [PostData] = []
    
    // FIRDatabaseのobserveEventの登録状態（true：登録済み、false：未登録）
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // テーブルをデリゲート
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        // セルの初期化
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil) // nibオブジェクトのインスタンス作成
        tableView.register(nib, forCellReuseIdentifier: "Cell")    // セルにnibオブジェクトを設定
        tableView.rowHeight = UITableViewAutomaticDimension        // セルの高さをAuto Layoutに任せる
    }
    
    
    /// 画面が表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if FIRAuth.auth()?.currentUser != nil {
            // ログインしている場合
            if self.observing == false {
                // FIRDatabaseのobserveEventが未登録の場合は、下記監視処理（クロージャー）を登録する
                let postsRef = FIRDatabase.database().reference().child(Const.PostPath) // DBを参照（インスタンス作成）
                
                // 要素が追加された場合に呼び出される（バックグラウンドでも実行される）
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        // ログインユーザのID取得に成功した場合
                        let postData = PostData(snapshot: snapshot, myId: uid) // PostDataを作成（いいねボタン処理のため自分のIDを渡す）
                        self.postArray.insert(postData, at: 0) // テーブルの先頭にデータを挿入
                        self.tableView.reloadData()            // テーブルを更新する
                    }
                })

                // 要素が変更された場合に呼び出される（バックグラウンドでも実行される）
                // 該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        // ログインユーザのID取得に成功した場合
                        let postData = PostData(snapshot: snapshot, myId: uid) // PostDataを作成（いいねボタン処理のため自分のIDを渡す）
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                // 更新データのIDがテーブル配列の中に存在した場合
                                index = self.postArray.index(of: post)! // IDを index に保持する
                                break
                            }
                        }
                        
                        // テーブルのデータをデリート＆インサートする
                        self.postArray.remove(at: index)           // データ削除
                        self.postArray.insert(postData, at: index) // データ挿入
                        
                        self.tableView.reloadData() // テーブルを更新する
                    }
                })
                
                // FIRDatabaseのobserveEventが上記クロージャーにより登録されたため、監視フラグを true（登録済み） にする
                // （本画面の再度開く際でも、監視処理が重複登録されない）
                observing = true
            }
        } else {
            // ログインしていない場合
            if observing == true {
                // FIRDatabaseのobserveEventが登録済みの場合
                postArray = []                                          // テーブルをクリアする
                tableView.reloadData()                                  // テーブルを更新する
                FIRDatabase.database().reference().removeAllObservers() // 登録済み observeEvent を削除する
                
                // FIRDatabaseのobserveEventが削除されたため、監視フラグを false（未登録） にする
                observing = false
            }
        }
    }

    
    /// データの数（セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count // テーブル配列の数
    }
    
    /// 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してPostDataを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        // セル内のいいねボタンのアクションをコードで実装する（handleButton()メソッドを呼ぶ）
        cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        return cell
    }
    
    /// 各セルの高さを Auto Layout を使って動的に変更する
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /// 各セルを選択した時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true) // 何もせず選択状態を解除する
    }
    
    /// セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first                  // タッチイベントを取得
        let point = touch!.location(in: self.tableView)      // タップした座標を取得
        let indexPath = tableView.indexPathForRow(at: point) // タップしたセルのインデックスを返却

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            // ログインユーザーのID取得に成功した場合
            if postData.isLiked {
                // 「いいね」をしていた場合
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // タップしたデータの「いいね」に自分のIDが存在した場合
                        index = postData.likes.index(of: likeId)! // 自分のIDが存在した配列のインデックスを保持
                        break
                    }
                }
                postData.likes.remove(at: index) // 自分のIDを削除する
            } else {
                // 「いいね」をしていない場合
                postData.likes.append(uid)       // 自分のIDを追加する
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!) // DB参照
            let likes = ["likes": postData.likes] // 保存する値の準備
            postRef.updateChildValues(likes)      // DBを更新する
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
