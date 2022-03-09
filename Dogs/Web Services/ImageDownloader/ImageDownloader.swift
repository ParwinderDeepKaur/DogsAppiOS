//
//  MKImageDownloader.swift
//  AsyncImageLoading


import UIKit

// Image Downloader download image from remote server and convert data into UIImage.
class ImageDownloader: NSObject {

    func downloadAndCacheImage(url:String, onSuccess:@escaping (_ image:UIImage?, _ url: String) -> Void, onFailure:@escaping (_ error:Error?) -> Void) -> Void {
        
        let finalUrl = URL(string: url )
        
        if let image = ImageDownloadManager.shared.getImage(forUrl: url){
            onSuccess(image, url)
        }else{
            URLSession.shared.dataTask(with: finalUrl!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    onFailure(error)
                }else{
                    if let image = UIImage(data: data!){
                        ImageDownloadManager.shared.setImage(image: image, forKey: url)
                        onSuccess(image, url)
                    }else{
                        onFailure(NSError(domain: "", code: 100, userInfo: ["reason":"Unable to download image"]))
                    }

                }
                
            }).resume()
        }
       
    }
    
  
    
}
