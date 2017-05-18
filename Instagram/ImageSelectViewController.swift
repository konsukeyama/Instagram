//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by konsukeyama on 2017/05/13.
//  Copyright © 2017年 konsukeyama. All rights reserved.
//

import UIKit

// UIImagePicker利用のため、UIImagePickerControllerDelegate, UINavigationControllerDelegate を継承
// Adobe Creative SDK利用のため、AdobeUXImageEditorViewControllerDelegate を継承
class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,AdobeUXImageEditorViewControllerDelegate {

    
    /// ライブラリボタン
    @IBAction func handleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            // ライブラリが利用可能な場合（isSourceTypeAvailableメソッドで判定）
            let pickerController = UIImagePickerController()                             // ピッカーのインスタンス作成
            pickerController.delegate = self                                             // デリゲート
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary // ソースタイプを指定（ライブラリ）
            self.present(pickerController, animated: true, completion: nil)              // ピッカーを表示する
        }
    }
    
    /// カメラボタン
    @IBAction func handleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // カメラが利用可能な場合
            let pickerController = UIImagePickerController()                       // ピッカーのインスタンス作成
            pickerController.delegate = self                                       // デリゲート
            pickerController.sourceType = UIImagePickerControllerSourceType.camera // ソースタイプを指定（カメラ）
            self.present(pickerController, animated: true, completion: nil)        // ピッカーを表示する
        }
    }
    
    /// キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 写真を撮影/選択したときに呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像が nil でない場合
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage // 撮影/選択された画像を取得する
            
            // AdobeUXImageEditorを起動する
            // 注：ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let adobeViewController = AdobeUXImageEditorViewController(image: image) // インスタンス作成
                adobeViewController.delegate = self                                      // デリゲート
                self.present(adobeViewController, animated: true, completion:  nil)      // 画面を開く
            }
            
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    /// フォトライブラリやカメラ起動中にキャンセルされたときに呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    /// AdobeImageEditorで加工が終わったときに呼ばれる
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        // 画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        // 投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
    }
    
    /// AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
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
