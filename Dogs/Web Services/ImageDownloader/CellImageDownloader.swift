// Extenions

import UIKit

extension UIImageView {
    // way to hack stored property in extension, we using static hence needed dictionary to store based on address
    private static var urlStore = [String:String]()

    // this function first set placeholder image or default BG color and than check saved cached image or download.
    func setImage(url: String, placeholderImage: UIImage? = nil) {
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        UIImageView.urlStore[tmpAddress] = url
        
        if let image = placeholderImage {
            self.image = image
        } else{
            self.backgroundColor = .gray
        }
        
        // Download image if image is not store in local storage.
        ImageDownloader().downloadAndCacheImage(url: url, onSuccess: { (image, url) in
            DispatchQueue.main.async {
            if UIImageView.urlStore[tmpAddress] == url {
                        self.image = image
                        self.backgroundColor = .clear
                    }
            }
        }) { error in
        }
    }
}
