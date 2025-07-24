//
//  ViewController.swift
//  SwiftShorts
//
//  Created by Sumanth Maddela on 23/07/25.
//

import UIKit

class HomeViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCollectionView()
        registerCell()
        setConstraints()
        viewModel.fetchVideos(page: 1) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
    }

    private func registerCell() {
        collectionView.register(VideoCollectionViewCell.self,
                                forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videoFiles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VideoCollectionViewCell.identifier,
                for: indexPath) as? VideoCollectionViewCell else {
            fatalError("Unable to dequeue VideoCollectionViewCell")
        }

        let videoFile = viewModel.videoFiles[indexPath.item]
        cell.configure(with: videoFile.link)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
