//
//  PostData.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/14.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


/// 投稿データ用のクラス
class PostData: NSObject {
    var id: String?             // 投稿データID
    var image: UIImage?         // 画像データ
    var imageString: String?    // 画像データ（Base64文字列）
    var name: String?           // 投稿者
    var caption: String?        // キャプション
    var date: NSDate?           // 投稿日時
    var likes: [String] = []    // 「いいね」をしたユーザーID
    var isLiked: Bool = false   // 自分が「いいね」したか
    var comments: [String] = [] // コメント
    
    
    /// 初期化処理（インスタンス生成時に実行される）
    init(snapshot: FIRDataSnapshot, myId: String) { // データ更新時に FIRDataSnapshot クラスとして渡される
        // snapshot.key（＝データのID）
        self.id = snapshot.key
        
        // snapshot.value（＝データの値）
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        // Base64文字列をUIImageに戻す
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        // 投稿者
        self.name = valueDictionary["name"] as? String
        
        // キャプション
        self.caption = valueDictionary["caption"] as? String
        
        // 投稿日時
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!) // 日付文字列をNSdateに戻す
        
        // いいねをしたユーザー
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        // 自分がいいねをしたか
        for likeId in self.likes {
            if likeId == myId {
                // いいねをしたユーザID配列に自分のIDがあった場合
                self.isLiked = true
                break
            }
        }
        
        // コメント
        if let comments = valueDictionary["comments"] as? [String] {
            self.comments = comments
        }
    }
}
