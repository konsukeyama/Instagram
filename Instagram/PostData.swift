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
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(snapshot: FIRDataSnapshot, myId: String) { // データ更新時に FIRDataSnapshot クラスとして渡される
        self.id = snapshot.key // snapshot.key＝データのID
        
        let valueDictionary = snapshot.value as! [String: AnyObject] // snapshot.value＝データの値
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data) // Base64文字列をUIImageに戻す
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!) // 日付文字列をNSdateに戻す
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                // いいねをしたユーザID配列に自分のIDがあった場合
                self.isLiked = true
                break
            }
        }
    }
}
