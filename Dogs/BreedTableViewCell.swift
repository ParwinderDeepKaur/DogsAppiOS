//
//  BreedTableViewCell.swift
//  Dogs
//


import UIKit


class BreedTableViewCell: UITableViewCell {
    static let identifier = "BreedTableViewCell"
    @IBOutlet weak var breed_name: UILabel!
    @IBOutlet weak var breed_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        breed_img.layer.cornerRadius = breed_img.frame.height * 0.5
        breed_img.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(_ breed:Breed) {
        breed_name.text = breed.name + " " + breed.breed
        fetchImageURL(breed) { [weak self] link, error in
            if let link = link {
                DispatchQueue.main.async {
                    self?.breed_img.setImage(url:link, placeholderImage: nil)
                }
            }
        }
    }
    
    
    private func fetchImageURL(_ breed:Breed, result:@escaping (String?,Error?) -> ()) {
        var url = "https://dog.ceo/api/breed/\(breed.breed)"
        if !breed.name.isEmpty {
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
    
}

