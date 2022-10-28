//
//  NetworkManager.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift

class NetworkManager {
    
    private let cache = NSCache<NSString, UIImage>()
    
    public func fetchData<T: Codable>(ofType: T.Type, from urlString: String) -> Observable<T> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else { return Disposables.create() }

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let decoder     = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data        = try Data(contentsOf: url)
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    observer.onNext(decodedData)
                } catch {
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
    
    public func fetchImage(from urlString: String?) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let urlString = urlString, let url = URL(string: NetworkLink.imageLink(for: urlString)) else {
                observer.onError(NetworkError.failURL)
                return Disposables.create()
            }
            
            // Converting urlString to type NSString
            let cacheKey = NSString(string: urlString)
            
            // Checking cached image by cacheKey
            if let image = self.cache.object(forKey: cacheKey) {
                observer.onNext(image)
            }
            
            DispatchQueue.global().async {
                do {
                    let imageData   = try Data(contentsOf: url)
                    let image       = UIImage(data: imageData)
                    
                    observer.onNext(image)
                    
                    if let image = image {
                        self.cache.setObject(image, forKey: cacheKey)
                    }
                } catch {
                    observer.onError(NetworkError.failedDecode)
                }
            }
            
            return Disposables.create()
        }
    }
}