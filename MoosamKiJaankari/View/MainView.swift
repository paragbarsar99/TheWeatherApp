//
//  MainView.swift
//  MoosamKiJaankari
//
//  Created by parag on 01/01/25.
//

import UIKit

class MainView {

    
    func VStack() -> UIStackView {
        let stack = UIStackView();
        stack.axis = .vertical;
        stack.spacing = 10;
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func HStack() -> UIStackView {
        let stack = UIStackView();
        stack.axis = .horizontal;
        stack.spacing = 10
        stack.distribution = .fill;
//        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func InputField() -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect;
        field.translatesAutoresizingMaskIntoConstraints = false
//        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }
    
    func IconButton(icon:String? = "") -> UIButton{
        let iconButton = UIButton()
//
        
//       guard let icon = icon, let imageSource = UIImage(systemName: icon)else {
//           return;
//        }
        let imageSource = SystemUIImage(src: icon, config: nil)
        var buttonConfig  = UIButton.Configuration.plain()
        buttonConfig.contentInsets  = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        iconButton.setImage(imageSource, for: .normal)
        iconButton.configuration = buttonConfig
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        return iconButton
    }
    
    func ImageView()-> UIImageView{
        let imgView = UIImageView();
        imgView.contentMode = .scaleAspectFill;
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
    func SystemUIImage(src:String?,config:UIImage.Configuration?) -> UIImage? {
        guard let imgSource = src else {
            return nil
        }
           
        let img =  UIImage(systemName: imgSource, withConfiguration: config)
        return img
           
    }
    
    func resizeImage(named imageName: String, to size: CGSize) -> UIImage? {
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resizedImage
    }
    
    func Text() -> UILabel{
        let t = UILabel();
        return t
    }
    
    
    
    func BackgroundImg(src:String) -> UIImageView{
        let imgView = UIImageView();
        let src = UIImage(named:src)
        imgView.image = src;
        imgView.contentMode = .scaleAspectFill;
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
}

