//
//  ShowDetailViewController.swift
//  Dogs
//

import UIKit

// Show Image of selected dog breed and fetch random image of same breed dog when user click on fetch new button icon.
class ShowDetailViewController: UIViewController {
    var breed:Breed?
    @IBOutlet weak var breed_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let breed = breed {
            updateUI(breed)
        }
    }
    // func will set title of navigation and fetch image and set image.
    func updateUI(_ breed:Breed) {
        title = breed.name + " " + breed.breed
        fetchImageURL(breed) { [weak self] link, error in
            if let link = link {
                DispatchQueue.main.async {
                    self?.breed_img.setImage(url:link, placeholderImage: nil)
                }
            }
        }
    }
    
    @IBAction func tapFetchNewImage(_ sender: Any) {
        if let breed = breed {
            updateUI(breed)
        }
    }
    
    // fetch random dog image from remote server
    private func fetchImageURL(_ breed:Breed, result:@escaping (String?,Error?) -> ()) {
        var url = "https://dog.ceo/api/breed/\(breed.breed)"
        if !breed.name.isEmpty { // condition for fetching sub breed dog image.
            url = url + "/\(breed.name)"
        }
        url = url + "/images/random"
        guard let all_breeds_url = URL(string:url) else { return }
        var request = URLRequest(url: all_breeds_url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                result(nil,error)
            } else if let data = data {
                do {
                    let dictRespone = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    if let status = dictRespone?["status"] as? String, status == "success", let message =  dictRespone?["message"] as? String {
                        result(message, nil)
                    } else {
                        result(nil,error)
                    }
                } catch {
                    result(nil,error)
                }
            } else {
                result(nil,error)
            }
        }
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
