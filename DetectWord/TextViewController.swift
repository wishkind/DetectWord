//
//  TextViewController.swift
//  DetectWord
//
//  Created by Confident Macbook on 2021/2/20.
//

import UIKit
import SwiftUI
struct TextWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = TextViewController()
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
class TextViewController: UIViewController, UITextViewDelegate {
    let textField = UITextField(frame: CGRect(x: 10, y: 100, width: 200, height: 80))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.backgroundColor = .green
        textField.text = "hello good night spring festval, lunar new year"
        
        self.view.addSubview(textField)
        let textView = UITextView(frame: CGRect(x: 10, y: 10, width: self.view.bounds.width - 10.0 * 2, height: 80.0))
        
        self.view.addSubview(textView)
        textView.backgroundColor = UIColor.lightGray
        textView.textAlignment = .left
        
        textView.textColor = UIColor.red
        textView.font = UIFont(name: "GillSans", size: 15.0)
        // Do any additional setup after loading the view.
        
        // 光标颜色
        textView.tintColor = UIColor.green
                
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.showsHorizontalScrollIndicator = true
        textView.showsVerticalScrollIndicator = true
        textView.delegate = self
        
        
        
        let frame: CGRect = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 200)
        let textView1: MyTextView  = MyTextView(frame: frame)
            textView1.backgroundColor = UIColor.yellow
            self.view.addSubview(textView)

        let string: NSString  = "The UIFont class provides the interface for getting and setting font information. The class provides you with access to the font’s characteristics and also provides the system with access to the font’s glyph information, which is used during layout. You use font objects by passing them to methods that accept them as a parameter.";
        let attrStr: NSAttributedString  = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
           textView.attributedText = attrStr;
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let begin: UITextPosition = textField.beginningOfDocument
        let end: UITextPosition  = textField.endOfDocument
        let range: UITextRange = textField.selectedTextRange ?? UITextRange.init()
        let location = touches.first?.location(in: self.view)
        print(location ?? 0)
        print(begin)
        print(end)
        print(range)
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            print("1 textViewShouldBeginEditing")
       
            
            return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            print("2 textViewDidBeginEditing")
    }
          
    func textViewDidChange(_ textView: UITextView) {
            print("3 textViewDidChange")
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = NSRange(location: 0, length: 0)
        textView.selectedRange = range
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            print("4 textView")
              
        print("text：\(String(describing: textView.text)) length = \(String(describing: textView.text?.count))")
              
            // 回车时退出编辑
            if text == "\n"
            {
    //            textView.endEditing(true)
                // 或
    //            self.view.endEditing(true)
                // 或
                textView.resignFirstResponder()
                  
                return true
            }
            return true
    }
          
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            print("5 textViewShouldEndEditing")
              
            return true
    }
          
    func textViewDidEndEditing(_ textView: UITextView) {
            print("6 textViewDidEndEditing")
    }

    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        
       // let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
      //  let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
      //  let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
       // print(indexOfCharacter)
       // return NSLocationInRange(indexOfCharacter, targetRange)
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
