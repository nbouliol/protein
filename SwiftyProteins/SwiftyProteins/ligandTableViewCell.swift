//
//  ligandTableViewCell.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 5/4/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit

class ligandTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var ligName: UILabel!
    @IBOutlet weak var ligMage: UIImageView!
    

}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, activityView:UIActivityIndicatorView) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                activityView.stopAnimating()
            }
            }.resume()
    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
}
