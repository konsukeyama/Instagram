//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/15.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit

/// PostDataオブジェクトの内容をテーブルのセルに反映するクラス
class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// PostDataの内容をセルに反映
    func setPostData(postData: PostData) {
        // 画像
        self.postImageView.image = postData.image
        
        // キャプション
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // いいねの数
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // 日付
        let dateString:String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        
        // いいねボタン
        if postData.isLiked {
            // 自分が「いいね」した場合
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        } else {
            // 自分が「いいね」していない場合
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        }
        
        // コメント
        var commentArray: [String] = []
        for value in postData.comments {
            commentArray.append("- " + value) // リストマーク
        }
        let comments = commentArray.joined(separator: "\n") // 1コメ毎に改行
        self.commentLabel.text = comments
    }
}
