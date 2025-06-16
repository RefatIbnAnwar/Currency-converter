//
//  StoryBoard.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 16/06/2025.
//

import UIKit


class StoryBoardManeger {
    
    static let shared = StoryBoardManeger()
    private init() {}
    
    func viewController<T: UIViewController>(from storyboard: String, identifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController with identifier \(identifier) not found in \(storyboard)")
        }
        return vc
    }
    
    func push(to viewController: UIViewController, from navigationController: UINavigationController?) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(_ viewController: UIViewController, from: UIViewController, fullscreen: Bool = true) {
        if fullscreen {
            viewController.modalPresentationStyle = .fullScreen
        } else {
            viewController.modalPresentationStyle = .overCurrentContext
        }
        from.present(viewController, animated: true, completion: nil)
    }
}
