//
//  MovieDetailsHeaderViewCell.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

protocol MovieDetailsHeaderViewCellDelegate: class{
    func loadPhotoViewer(photoDatas: [PhotoViewerManager.PhotoData], initialIndex: Int, forImageView imageView: UIImageView?)
    func dismiss()
    func favouriteClicked()
}

class MovieDetailsHeaderViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    private var rateView : RatingView?
    @IBOutlet private weak var favouriteButton: UIButton!
    private var movieDetails: MovieDetails?
    private var imageUrls: [URL]?
    private var isFav = false
    
    weak var delegate: MovieDetailsHeaderViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        pageControl.hidesForSinglePage = true
        if let ratesView = RatingView.load(){
            ratingView.addSubview(ratesView)
            ratesView.stretchLayout()
            rateView = ratesView
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = detailView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailView.insertSubview(blurEffectView, at: 0)
        ratingView.isHidden = true
        titleLabel.isHidden = true
    }
    
    private func setCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MovieDetailsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(with movieDetails: MovieDetails){
        isFav = movieDetails.isFavourite
        ratingView.isHidden = false
        titleLabel.isHidden = false
        self.movieDetails = movieDetails
        let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flow?.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        flow?.minimumLineSpacing = 0
        if let url = movieDetails.iconURL{
            imageUrls = [url]
        }
        rateView?.setRating(rating: movieDetails.vote, numberOfRates: movieDetails.voteCount)
        titleLabel.text = movieDetails.title
        favouriteButton.setImage(UIImage(named: isFav ? "heart_full" : "heart"))
        collectionView.reloadData()
    }
    
    private func update(favourite: Bool){
        favouriteButton.setImage(UIImage(named: favourite ? "heart_full" : "heart"))
    }
}

extension MovieDetailsHeaderViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = imageUrls?.count ?? .zero
        pageControl.numberOfPages = number
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieDetailsCollectionViewCell{
            cell.fill(withUrl: imageUrls?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView = (collectionView.cellForItem(at: indexPath) as? MovieDetailsCollectionViewCell)?.imageView
        delegate?.loadPhotoViewer(photoDatas: imageUrls?.enumeratedMap { _, index in
            PhotoViewerManager.PhotoData(image: index == indexPath.row ? imageView?.image : nil, url: index == indexPath.row && imageView?.image != nil ? nil : self.imageUrls?[index], title: "")
            } ?? [], initialIndex: indexPath.row, forImageView: imageView)
    }
}

extension MovieDetailsHeaderViewCell{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(contentView.frame.width)
    }
}

// MARK: Actions
extension MovieDetailsHeaderViewCell{
    @IBAction func dismiss(_ sender: Any) {
        delegate?.dismiss()
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        isFav.toggle()
        update(favourite: isFav)
        delegate?.favouriteClicked()
    }
}
