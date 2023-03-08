//
//  PictureViewModel.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import Alamofire

class PictureViewModel {

    var pictures : [Picture] = []
    var startIndex = 0
    let batchSize = 50
    private var isFetching = false
    
    func fetchPictures(completion: @escaping (Error?) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/photos?_start=\(startIndex)&_limit=\(batchSize)"
        
        if isFetching {
            return
        }
        
        isFetching = true
        AF.request(url).responseDecodable(of: [Picture].self) { response in
            switch response.result {
            case .success(let pictures):
                let sortedPictures = pictures.sorted { $0.albumId < $1.albumId }
                self.pictures.append(contentsOf: sortedPictures)
                self.isFetching = false
                self.startIndex += 50
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func fetchImage(from url: String, completion: @escaping (Data?) -> Void) {
            
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
