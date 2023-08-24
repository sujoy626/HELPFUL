//
//  EmojiView.swift
//  TestAlgo
//
//  Created by Sujoy Adhikary on 24/08/23.
//

import Foundation
import UIKit


protocol EmojiViewDelegate : AnyObject{
    func didselectEmoji(indexPath: IndexPath, emoji : String)
    func setupEmojiUI()
    func dismissWith(point: CGPoint,indexPath: IndexPath?,emoji : String?)
}

class EmojiView: UIView {
    
    let emojis: [String] = ["😀", "🥰", "😎", "🐶", "🌺"]
    weak var emojiViewDelegate : EmojiViewDelegate?
    private lazy var viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
    
    init(frame: CGRect,delegate:EmojiViewDelegate) {
        super.init(frame: frame)
        emojiViewDelegate = delegate
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
//
//
//    init(frame: CGRect,delegate:EmojiViewDelegate) {
//        super.init(frame: .zero)
//        emojiViewDelegate = delegate
//        setupUI(frame: frame)
//
//    }
    
    private lazy var dismissBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(dismissBtnActon), for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissBtnActon(){
        isHidden = true
        guard let buttonFrame = dismissBtn.superview?.convert(dismissBtn.frame, to: nil).origin else {return}
        emojiViewDelegate?.dismissWith(point: buttonFrame, indexPath: nil, emoji: nil)
    }
    
    func showWith(point: CGPoint){
        self.viewContainer.frame.origin = point
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.isHidden = false
        }
        
    }
    func showWith(view: UIView){
        
        guard let viewPoint = view.superview?.convert(view.frame, to: nil).origin else {return}
        showWith(point: viewPoint)
    }
    
    
    
    private func setupUI() {
        
        addSubview(dismissBtn)
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        dismissBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        dismissBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        dismissBtn.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        
//        viewContainer = UIView(frame: frame)
        viewContainer.backgroundColor = .blue
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 8
        
        dismissBtn.addSubview(viewContainer)
        
        
       
        
        
        let floaw = UICollectionViewFlowLayout()
        floaw.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: viewContainer.bounds, collectionViewLayout: floaw)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.backgroundColor = .clear
        viewContainer.addSubview(collectionView)
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        isHidden = true
    }
    
    
    
    
    
}

extension EmojiView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
        cell.configure(with: emojis[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isHidden = true
        emojiViewDelegate?.didselectEmoji(indexPath: indexPath, emoji: emojis[indexPath.item])
        
        guard let buttonFrame = dismissBtn.superview?.convert(dismissBtn.frame, to: nil).origin else {return}
        emojiViewDelegate?.dismissWith(point: buttonFrame, indexPath: indexPath, emoji: emojis[indexPath.item])
    }
}

class EmojiCell: UICollectionViewCell {
    let emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .yellow
        contentView.addSubview(emojiLabel)
        
        emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}



//MARK: - Example
//extension EmojiDisplayVC : EmojiViewDelegate{
//    func dismissWith(point: CGPoint, indexPath: IndexPath?, emoji: String?) {
//
//    }
//
//    func setupEmojiUI(){
//        view.addSubview(emojiView)
//        emojiView.translatesAutoresizingMaskIntoConstraints = false
//        emojiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        emojiView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        emojiView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        emojiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//    }
//    func didselectEmoji(indexPath: IndexPath, emoji: String) {
//        print("Tapped emoji:", emoji)
//
//    }
//}
