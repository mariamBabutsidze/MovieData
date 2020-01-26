//
//  PhotoViewerManager.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 6/12/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import UIKit
import AXPhotoViewer

class PhotoViewerManager: NSObject {
    
    class PhotoData {
        
        var image: UIImage?
        var url: URL?
        var title: String?
        
        init(image: UIImage? = nil, url: URL? = nil, title: String? = nil)
        {
            self.image = image
            self.url = url
            self.title = title
        }
        
    }
    
    private var photoDatas: [PhotoData] = []
    {
        didSet
        {
            self.photos = self.photoDatas.map { photoData -> AXPhoto in
                let photo = AXPhoto(attributedTitle: NSAttributedString(string: photoData.title ?? .empty, attributes: [
                    .font                       :       UIFont.poppins(type: .bold, size: 15 * Constants.ScreenFactor),
                    .foregroundColor            :       UIColor.white
                ]), attributedDescription: NSAttributedString(string: .space), image: photoData.image, url: photoData.url)
                return photo
            }
        }
    }
    private var initialPhotoIndex = 0
    private var parentView: UIView?
    private var imageView: UIImageView?
    private var presentedViewController: UIViewController?
    
    private var photos: [AXPhoto] = []
    private var photosDataSource: AXPhotosDataSource { get { return AXPhotosDataSource(photos: self.photos, initialPhotoIndex: self.initialPhotoIndex) } }
    
    deinit
    {
        print("deinit: - " + self.className)
    }
    
    func present(on viewController: UIViewController, photoDatas: [PhotoData], initialPhotoIndex: Int, parentView: UIView?, imageView: UIImageView?)
    {
        self.photoDatas = photoDatas
        self.initialPhotoIndex = initialPhotoIndex
        self.parentView = parentView
        self.imageView = imageView
        self.presentedViewController = viewController
        let photoViewer = PhotosViewController(dataSource: self.photosDataSource, pagingConfig: nil, transitionInfo: AXTransitionInfo(interactiveDismissalEnabled: true, startingView: imageView) { photo, index -> UIImageView? in
//            if(self.initialPhotoIndex == index)
//            {
//                return self.imageView
//            }
            return nil
        }, networkIntegration: NetworkIntegration())
        
        photoViewer.delegate = self
        photoViewer.modalPresentationStyle = .fullScreen
       // photoViewer.modalTransitionStyle = .crossDissolve
        photoViewer.transitioningDelegate = nil
        if #available(iOS 13.0, *) {
            photoViewer.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.presentedViewController?.present(photoViewer)
    }

}

//MARK: - AXPhotosViewControllerDelegate, UIViewControllerPreviewingDelegate
extension PhotoViewerManager: AXPhotosViewControllerDelegate, UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        previewingContext.sourceRect = self.parentView?.convert(self.imageView?.frame ?? .zero, from: self.imageView?.superview) ?? .zero
        return AXPreviewingPhotosViewController(dataSource: self.photosDataSource)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        if let previewingPhotosViewController = viewControllerToCommit as? AXPreviewingPhotosViewController
        {
            self.presentedViewController?.present(AXPhotosViewController(from: previewingPhotosViewController), animated: false)
        }
    }
    
    func photosViewControllerWillDismiss(_ photosViewController: AXPhotosViewController) {
        print("sdifhsifh")
    }
    
    func photosViewControllerDidDismiss(_ photosViewController: AXPhotosViewController) {
        print("sdjkfns")
    }
}

private class PhotosViewController: AXPhotosViewController {
    
    override var closeBarButtonItem: UIBarButtonItem { get { return UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(self.closeAction(_:))) } }
    
    override var actionBarButtonItem: UIBarButtonItem { get { return UIBarButtonItem(image: UIImage(named: "ic_share"), style: .plain, target: self, action: #selector(self.shareAction(_:))) } }
    
}

private class LoadingView: UIView, AXLoadingViewProtocol {
    
    private let viewActivityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    func startLoading(initialProgress: CGFloat)
    {
        self.addSubview(self.viewActivityIndicator)
        self.viewActivityIndicator.startAnimating()
    }
    
    func stopLoading()
    {
        self.viewActivityIndicator.stopAnimating()
    }
    
    func showError(_ error: Error, retryHandler: @escaping () -> Void)
    {
        self.viewActivityIndicator.stopAnimating()
    }
    
    func removeError()
    {
        
    }
    
}

private class NetworkIntegration: NSObject, AXNetworkIntegrationProtocol, URLSessionDelegate {
    
    var delegate: AXNetworkIntegrationDelegate?
    
    private var photo: AXPhotoProtocol!
    
    func loadPhoto(_ photo: AXPhotoProtocol)
    {
        self.photo = photo
        
        if let url = photo.url
        {
            URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: URLRequest(url: url)) { data, response, error in
                if let data = data
                {
                    photo.image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
                    }
                }
            }.resume()
        }
        else if(photo.image != nil)
        {
            self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
        }
        else
        {
            self.delegate?.networkIntegration(self, loadDidFailWith: NSError(domain: "Load cancled", code: 0, userInfo: nil), for: photo)
        }
    }
    
    func cancelLoad(for photo: AXPhotoProtocol)
    {
        self.delegate?.networkIntegration(self, loadDidFailWith: NSError(domain: "Load cancled", code: 0, userInfo: nil), for: photo)
    }
    
    func cancelAllLoads()
    {
        self.delegate?.networkIntegration(self, loadDidFailWith: NSError(domain: "All loads cancled", code: 0, userInfo: nil), for: self.photo)
    }
    
    // MARK: - URLSessionDelegate
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if let trust = challenge.protectionSpace.serverTrust
        {
            completionHandler(.useCredential, URLCredential(trust: trust))
        }
    }
    
}
