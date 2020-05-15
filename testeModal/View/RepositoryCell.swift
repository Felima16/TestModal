//
//  RepositoryCell.swift
//  testeModal
//
//  Created by Fernanda de Lima on 14/05/20.
//  Copyright © 2020 felima. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var countStarLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    
    var repository: Item? {
        didSet{
            setupCell()
        }
    }
    
    var avatarImg: UIImage? {
        didSet{
            avatarImageView?.image = avatarImg
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("carregou")
    }
    
    private func setupCell(){
        countStarLabel?.text = "\(repository?.stargazers_count ?? 0)"
        ownerLabel?.text = repository?.owner.login ?? ""
        repositoryLabel?.text = repository?.name ?? ""
        let url = URL(string: (repository?.owner.avatar_url)!)!
        downloadImage(from: url)
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.avatarImg = UIImage(data: data)
            }
        }
    }
}
