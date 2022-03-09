//
//  ViewController.swift
//  Dogs
//


import UIKit

// Struct for storing breads and there sub breads
struct Breed {
    let name:String
    let breed:String
}

class ViewController: UIViewController {
    
    private var breeds:[Breed] = []
    @IBOutlet weak var list_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchBreeds()
        registerCell()
    }
    // Registering custom cell to table view
    private func registerCell() {
        let nib = UINib(nibName:BreedTableViewCell.identifier, bundle: nil)
        list_table.register(nib, forCellReuseIdentifier: BreedTableViewCell.identifier)
    }
    
    // show alert view with message, if any error occur
    private func showError(_ message:String) {
        let alertVC = UIAlertController(title:"Error", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title:"Retry", style: .default) { [weak self] action in
            self?.fetchBreeds()
        }
        alertVC.addAction(retry)
        present(alertVC, animated: true, completion: nil)
    }
    
    // fetching list of dog breeds from remote server using API
    private func fetchBreeds() {
        breeds.removeAll()
        list_table.reloadData()
        guard let all_breeds_url = URL(string:"https://dog.ceo/api/breeds/list/all") else { return }
        var request = URLRequest(url: all_breeds_url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.showError(error.localizedDescription)
            } else if let data = data {
                do {
                    let dictRespone = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    self?.parser(dict:dictRespone)
                } catch {
                    self?.showError("Invalid JSON response")
                }
            } else {
                self?.showError("Nil Data response")
            }
        }
        task.resume()
    }
    
    // This func will parser the response and create data sources for table view and reload it after all done.
    private func parser(dict: [String:Any]?) {
        if let messages = dict?["message"] as? [String:[String]] {
            let keys = Array(messages.keys)
            for breed in keys {
                if let sub_breeds = messages[breed], sub_breeds.count > 0 {
                    for sub_breed in sub_breeds {
                        let breed_tmp = Breed(name:sub_breed, breed:breed)
                        breeds.append(breed_tmp)
                    }
                } else {
                    let breed_tmp = Breed(name:"", breed: breed)
                    breeds.append(breed_tmp)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.list_table.reloadData()
            }
        } else {
            showError("Something went wrong while parsing.")
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ShowDetailViewController, segue.identifier == "showDetailViewSegueIdentifier",let indexPath =  sender as? IndexPath {
            destination.breed = breeds[indexPath.row]
            
        }
    }
    
}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:BreedTableViewCell.identifier, for: indexPath) as? BreedTableViewCell {
            cell.selectionStyle = .none
            cell.updateUI(breeds[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"showDetailViewSegueIdentifier", sender: indexPath)
    }
    
}



