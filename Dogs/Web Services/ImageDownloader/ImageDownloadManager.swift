//  AsyncImageLoading

import UIKit
// ImageDownloadManager is cacheing images in device using URL as key for reference or index.
class ImageDownloadManager: NSObject {

    static let shared = ImageDownloadManager()
    var imageCache:NSCache<NSString, UIImage>
    
    
    private override init() {
        self.imageCache = NSCache()
    }
    
    func getImage(forUrl url:String) -> UIImage? {
        return self.imageCache.object(forKey: url as NSString)
    }
    
    func setImage(image:UIImage,forKey url:String) -> Void {
        self.imageCache.setObject(image, forKey: url as NSString)
    }
}
