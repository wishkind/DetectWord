//
//  MyTextView.swift
//  DetectWord
//
//  Created by Confident Macbook on 2021/2/19.
//

import UIKit

class MyTextView: UITextView, UITextViewDelegate {
    
    private struct Constants {
        static let defaultiOSPlaceholderColor: UIColor = {
            if #available(iOS 13.0, *) {
                return .systemGray3
            }

            return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
        }()
    }
    
    public let placeholderLabel: UILabel = UILabel()
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    
    @IBInspectable open var placeholder: String = "" {
            didSet {
                placeholderLabel.text = placeholder
            }
        }
    
    @IBInspectable open var placeholderColor: UIColor = MyTextView.Constants.defaultiOSPlaceholderColor {
           didSet {
               placeholderLabel.textColor = placeholderColor
           }
       }
    
    override open var font: UIFont! {
          didSet {
              if placeholderFont == nil {
                  placeholderLabel.font = font
              }
          }
      }
      
      open var placeholderFont: UIFont? {
          didSet {
              let font = (placeholderFont != nil) ? placeholderFont : self.font
              placeholderLabel.font = font
          }
      }
      
      override open var textAlignment: NSTextAlignment {
          didSet {
              placeholderLabel.textAlignment = textAlignment
          }
      }
      
      override open var text: String! {
          didSet {
              textDidChange()
          }
      }
      
      override open var attributedText: NSAttributedString! {
          didSet {
              textDidChange()
          }
      }
      
      override open var textContainerInset: UIEdgeInsets {
          didSet {
              updateConstraintsForPlaceholderLabel()
          }
      }
      
    
    
    let textField = UITextField(frame: CGRect(x: 10, y: 10, width: 200, height: 80))
    override init(frame: CGRect, textContainer: NSTextContainer?) {
      
               super.init(frame: frame, textContainer: textContainer)
               commonInit()
           }
           
    required public init?(coder aDecoder: NSCoder) {
               super.init(coder: aDecoder)
               commonInit()
           }

    
 


    private func commonInit() {
        #if swift(>=4.2)
        let notificationName = UITextView.textDidChangeNotification
        #else
        let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
        #endif
      
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidChange),
            name: notificationName,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    @objc private func textDidChange() {
            placeholderLabel.isHidden = !text.isEmpty
        }
    
    
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: placeholderLabel,
            attribute: .height,
            multiplier: 1.0,
            constant: textContainerInset.top + textContainerInset.bottom
        ))
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
            ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       // let begin: UITextPosition = textField.beginningOfDocument
        //let end: UITextPosition  = textField.endOfDocument
        //let range: UITextRange = textField.selectedTextRange ?? UITextRange.init()
       // let location = touches.first?.location(in: self)
        
            // 获取当前触摸位置的字符所属的字母(提示：触摸位置需向下调整10个点，以便与文本元素对齐)
        let touch: UITouch  = touches.first!
        var touchPoint: CGPoint = touch.location(in: self)
            touchPoint.y -= 10;
        let charIndex: NSInteger = self.layoutManager.characterIndex(for: touchPoint, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            // 获取点击的字母的位置
           
            // 获取单词的范围。range 由起始位置和长度构成。
        let range: NSRange  = self.getWordRange(charIndex)
          
            
            // 高亮单词
        self.modifyAttributeInRange(range)
            
            //调用父类的方法
        super.touchesBegan(touches, with: event)
    }
    
    //获取单词的范围
    func getWordRange(_ characterIndex: NSInteger) -> NSRange {
        var left: NSInteger = characterIndex - 1;
        var right: NSInteger  = characterIndex + 1;
        var length: NSInteger  = 0;
        var string: NSString  = self.attributedText.string as NSString;
        
        // 往左遍历直到空格
        while (left >= 0) {
            var s: String = string.substring(with: NSMakeRange(left, 1))
            if self.isLetter(s) {
                left -= 1
            }
            else {
                break
            }
            
        }
    
        
        // 往右遍历直到空格
        while (right < self.text.count) {
            var s: String = string.substring(with: NSMakeRange(left, 1))
            if self.isLetter(s) {
                right += 1
            }
            else {
                break
            }
            
            
        }

        // 此时 left 和 right 都指向空格
        left += 1
        right -= 1
        NSLog("letf = %ld, right = %ld",left,right);

        length = right - left + 1;
        var range: NSRange  = NSMakeRange(left, length);
        
        return range;
    }
    
    
    //判断是否字母
    func isLetter(str: String) {
        var letter: Character = Character
            [str characterAtIndex:0];
        
        if ((letter >= 'a' && letter <='z') || (letter >= 'A' && letter <= 'Z')) {
            return true
        }
        return false
    }
    
    
    //修改属性字符串
    func modifyAttributeInRange(range: NSRange) {
        var string: NSString  = self.attributedText.string
        var attString: NSMutableAttributedString  = NSMutableAttributedString(string: string, attributes:
                                                                                [NSAttributedString.Key : Any]?)
        alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];

        //添加文字颜色
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        //添加文字背景颜色
        [attString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];

        self.attributedText = attString;
    }
    open override func layoutSubviews() {
          super.layoutSubviews()
          placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
      }
      
      deinit {
        #if swift(>=4.2)
        let notificationName = UITextView.textDidChangeNotification
        #else
        let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
        #endif
        
          NotificationCenter.default.removeObserver(self,
              name: notificationName,
              object: nil)
      }
      
}
