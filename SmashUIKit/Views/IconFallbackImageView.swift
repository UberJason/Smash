//
//  IconFallbackImageView.swift
//  SmashUIKit
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public class IconFallbackImageView: UIView {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var contentView: UIView!

    public var displayMode: DisplayMode = .circle {
        didSet {
            switch displayMode {
            case .circle:
                circleView.layer.cornerRadius = frame.size.width/2.0
                imageView.layer.cornerRadius = frame.size.width/2.0
                self.layer.cornerRadius = frame.size.width/2.0
            case .rounded(let radius):
                circleView.layer.cornerRadius = radius
                imageView.layer.cornerRadius = radius
                self.layer.cornerRadius = radius
            }
        }
    }

    public enum DisplayMode {
        case circle, rounded(radius: CGFloat)
    }
    
    @IBInspectable public var image: UIImage? = nil {
        didSet {
            imageView.image = image
            imageView.isHidden = image == nil
            circleView.isHidden = image != nil
            layoutIfNeeded()
        }
    }

    @IBInspectable public var fallbackText: String? = nil {
        didSet {
            textLabel.text = fallbackText
        }
    }
    
    @IBInspectable public var fallbackBackgroundColor: UIColor? = .white {
        didSet {
            circleView.backgroundColor = fallbackBackgroundColor
        }
    }
    
    public var fallbackFont: UIFont? = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            textLabel.font = fallbackFont
        }
    }

    @IBInspectable public var fallbackTextColor: UIColor? = .white {
        didSet {
            textLabel.textColor = fallbackTextColor
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    public convenience init(image: UIImage? = nil, fallbackText: String? = nil, fallbackBackgroundColor: UIColor? = nil, fallbackFont: UIFont?) {
        self.init(frame: .zero)
        self.image = image
        self.fallbackText = fallbackText
        self.fallbackBackgroundColor = fallbackBackgroundColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        Bundle(for: type(of: self)).loadNibNamed("IconFallbackImageView", owner: self, options: nil)
        guard let contentView = contentView else { return }
        addSubviewFullFrame(contentView)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        circleView.layer.masksToBounds = true
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        switch displayMode {
        case .circle:
            circleView.layer.cornerRadius = frame.size.width/2.0
            imageView.layer.cornerRadius = frame.size.width/2.0
            self.layer.cornerRadius = frame.size.width/2.0
        case .rounded(let radius):
            circleView.layer.cornerRadius = radius
            imageView.layer.cornerRadius = radius
            self.layer.cornerRadius = radius
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        circleView.isHidden = false
        circleView.layer.cornerRadius = frame.size.width/2.0
        textLabel.text = "C1"
    }
}


extension UIImageView {

    public func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        getDataFromUrl(url: url) { data, response, error in
            guard let response = response, let data = data, error == nil else { return }
            if self.canDisplayURL(response: response) {
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    func canDisplayURL(response: URLResponse) -> Bool {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                return true
            }
        }
        return false
    }
}
