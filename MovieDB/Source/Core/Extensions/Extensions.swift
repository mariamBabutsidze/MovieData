//
//  Extensions.swift
//
//  Created by Giorgi Iashvili on 16.06.18.
//  Copyright © 2018 Giorgi Iashvili. All rights reserved.
//

import UIKit
import CoreLocation
import RDExtensionsSwift
import SVProgressHUD
import SwiftyJSON
import Accelerate
import SDWebImage
import CoreData

precedencegroup NotGreaterOrEqualThan {
    associativity: left
}
infix operator !>= : NotGreaterOrEqualThan

precedencegroup NotLessOrEqualThan {
    associativity: left
}
infix operator !<= : NotLessOrEqualThan

precedencegroup UnwrappedAssign {
    associativity: right
}
infix operator ?= : UnwrappedAssign

/// RDExtensionsSwift: Check if nullable lhs is not greater or equal than nullable rhs
public func !>=<T : Comparable>(left: T?, right: T?) -> Bool
{
    return !(left >= right)
}

/// RDExtensionsSwift: Check if nullable lhs is not less or equal than nullable rhs
public func !<=<T : Comparable>(left: T?, right: T?) -> Bool
{
    return !(left <= right)
}

/// RDExtensionsSwift: Set rhs value to lhs if rhs is not nil
public func ?=<T>(base: inout T, newValue: T?)
{
    if let newValue = newValue
    {
        let mirror = Mirror(reflecting: newValue)
        if(mirror.displayStyle != .optional)
        {
            base = newValue
        }
        else if(!mirror.children.isEmpty)
        {
            if let nv = mirror.children.first?.value as? T
            {
                base = nv
            }
        }
    }
}

extension NSDecimalNumber{
    
    public static func <(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool
    {
        let result = lhs.compare(rhs)
        return result == .orderedAscending
    }
    
    public static func <=(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool
    {
        let result = lhs.compare(rhs)
        return result == .orderedAscending || result == .orderedSame
    }
    
    public static func ==(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool
    {
        let result = lhs.compare(rhs)
        return result == .orderedSame
    }
    
    public static func >=(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool
    {
        let result = lhs.compare(rhs)
        return result == .orderedDescending || result == .orderedSame
    }
    
    public static func >(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool
    {
        let result = lhs.compare(rhs)
        return result == .orderedDescending
    }
    
}

extension String {
    
    /// RDExtensionsSwift: Convert String to NSDecimalNumber
    var toNSDecimalNumberValue: NSDecimalNumber { get { let number = NSDecimalNumber(string: self); return number == .notANumber ? .zero : number } }
    
    static var dot: String { get { return String(".") } }
    
    static var comma: String { get { return String(",") } }
    
    static var newLine: String { get { return String("\n") } }
    
    static var percent: String { get { return String("%") } }
    
    func toCurrencyAttributedString(prefix: String? = nil, prefixFont: UIFont? = nil, prefixColor: UIColor? = nil, couponFont: UIFont, couponColor: UIColor = .white, coinsFont: UIFont, coinsColor: UIColor = .white, currencySymbol: String? = Constants.Currency.GEL) -> NSAttributedString
    {
        let components = self.replacingOccurrences(of: String.comma, with: String.dot).components(separatedBy: String.dot)
        var attributeComponents: [(String, [NSAttributedString.Key : Any])] = []
        if let coupons = components.first
        {
            if let prefix = prefix,
                let prefixFont = prefixFont,
                let prefixColor = prefixColor
            {
                attributeComponents.append((prefix, [
                    .font                       :       prefixFont,
                    .foregroundColor            :       prefixColor
                ]))
            }
            
            attributeComponents.append((coupons + (components.count == 2 ? .dot : .empty), [
                .font                       :       couponFont,
                .foregroundColor            :       couponColor
            ]))
            
            if let coins = components.last,
                components.count == 2
            {
                attributeComponents.append((coins + (currencySymbol == nil ? .empty : currencySymbol!), [
                    .font                       :       coinsFont,
                    .foregroundColor            :       coinsColor
                ]))
            }
            
            let label = UILabel()
            label.setAttributedText(attributeComponents)
            if let attrStr = label.attributedText
            {
                return attrStr
            }
        }
        return NSAttributedString(string: (prefix ?? .empty) + self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    /// RDExtensionsSwift: Convert String to NSURL
    var toHttpURL : URL? { return URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self) }
    
    func index(of string: String, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: String, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: String, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func ranges(of string: String, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
}

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    
    @IBInspectable var adjustSeparatorInsetsToFitDevice: Bool { get { return false } set { if(newValue) { self.separatorInset = UIEdgeInsets(top: self.separatorInset.top * Constants.ScreenFactor, left: self.separatorInset.left * Constants.ScreenFactor, bottom: self.separatorInset.bottom * Constants.ScreenFactor, right: self.separatorInset.right * Constants.ScreenFactor) } } }
    
    @IBInspectable var adjustRowHeightToFitDevice: Bool { get { return false } set { if(newValue) { self.rowHeight *= Constants.ScreenFactor } } }
    
    @IBInspectable var adjustSectionHeaderHeightToFitDevice: Bool { get { return false } set { if(newValue) { self.sectionHeaderHeight *= Constants.ScreenFactor } } }
    
    @IBInspectable var adjustSectionFooterHeightToFitDevice: Bool { get { return false } set { if(newValue) { self.sectionFooterHeight *= Constants.ScreenFactor } } }
    
    func dequeueReusableCell <T: UITableViewCell> (for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            print("Couldn't dequeue cell with identifier: \(T.reuseIdentifier). Returning empty, newly initialized \(T.reuseIdentifier) cell")
            return T()
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: Reusable {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
    
}

extension UICollectionView {
    
    @IBInspectable var adjustMinimumInteritemSpacingToFitDevice: Bool { get { return false } set { if(newValue) { (self.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing *= Constants.ScreenFactor } } }
    
    @IBInspectable var adjustMinimumLineSpacingToFitDevice: Bool { get { return false } set { if(newValue) { (self.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing *= Constants.ScreenFactor } } }
    
    @IBInspectable var adjustSectionInsetsToFitDevice: Bool
    {
        get { return false }
        set
        {
            if(newValue)
            {
                if let inset = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
                {
                    (self.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: inset.top * Constants.ScreenFactor,
                                                                                                            left: inset.left * Constants.ScreenFactor,
                                                                                                            bottom: inset.bottom * Constants.ScreenFactor,
                                                                                                            right: inset.right * Constants.ScreenFactor)
                }
            }
        }
    }
    
    func dequeueReusableCell <T: UICollectionViewCell> (for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            print("Couldn't dequeue cell with identifier: \(T.reuseIdentifier). Returning empty, newly initialized \(T.reuseIdentifier) cell")
            return T()
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionViewCell>(elementKind: String, indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
}

extension UICollectionViewCell {
    @objc func fill(with item: Any) {
        
    }
}

extension CGRect {
    
    /// RDExtensionsSwift: Get or Set frame width
    var width : CGFloat { get { return self.size.width } set { self.size = CGSize(width: newValue, height: self.size.height) } }
    
    /// RDExtensionsSwift: Get or Set frame height
    var height : CGFloat { get { return self.size.height } set { self.size = CGSize(width: self.size.width, height: newValue) } }
    
}

extension NSLayoutConstraint {
    @IBInspectable var shouldAdjustConstantToFitDevice : Bool { get { return false } set { if(newValue) { self.constant *= Constants.ScreenFactor } } }
}

extension UIViewController {
    
    @IBInspectable var localizedTitle : String { get { return self.title ?? "" } set { self.title = LocalString(newValue) } }
    
    public class func loadFromStoryboard() -> Self
    {
        return self.load(from: self.className.replacingOccurrences(of: "NavigationController", with: "").replacingOccurrences(of: "ViewController", with: "").replacingOccurrences(of: "Controller", with: ""))!
    }
    
    @discardableResult public static func loadAsRootViewController() -> Self
    {
        return self.loadFromStoryboard().loadAsRootViewController()!
    }
    
    var standardFailBlock: Network.FailBlock
    {
        return { [weak self] status in
            self?.stopLoader()
            if(Network.isConnectedToNetwork){
                UIApplication.shared.keyWindow?.lastPresentedViewController?.present(UIAlertController(message: status.localizedDescription, actions: [], cancelButtonTitle: LocalString("Close")), animated: true, completion: nil)
            }
        }
    }
    
    @objc func startLoader()
    {
        self.view.startLoader()
    }
    
    @objc func stopLoader()
    {
        self.view.stopLoader()
    }
    
    @objc var isLoading: Bool { get { return self.view.isLoading } }
    
    func present(_ viewControllerToPresent: UIViewController)
    {
        self.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    func present(on viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil)
    {
        viewController.present(self, animated: animated, completion: completion)
    }
    
}

extension UIView {
    
    @IBInspectable var borderWidth : CGFloat { get { return self.layer.borderWidth } set { self.layer.borderWidth = newValue } }
    
    @IBInspectable var adjustBorderWidthToFitDevice : Bool { get { return false } set { if(newValue) { self.borderWidth = self.borderWidth * Constants.ScreenFactor } } }
    
    @IBInspectable var borderColor : UIColor? { get { return self.layer.borderColor != nil ? UIColor(cgColor: self.layer.borderColor!) : nil } set { self.layer.borderColor = newValue?.cgColor } }
    
    @IBInspectable var cornerRadius : CGFloat { get { return self.layer.cornerRadius } set { self.layer.cornerRadius = newValue; self.layer.masksToBounds = true } }
    
    @IBInspectable var adjustCornerRadiusToFitDevice : Bool { get { return false } set { if(newValue) { self.layer.cornerRadius = self.cornerRadius * Constants.ScreenFactor } } }
    
    @IBInspectable var roundedCorners : Bool { get { return self.layer.cornerRadius == self.frame.height/2 } set { if(newValue) { self.layer.cornerRadius = self.frame.height/2; self.clipsToBounds = true } } }
    
    @IBInspectable var shadowColor : UIColor? { get { return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil } set { self.layer.shadowColor = newValue?.cgColor } }
    
    @IBInspectable var shadowOpacity : Float { get { return self.layer.shadowOpacity } set { self.layer.shadowOpacity = newValue } }
    
    @IBInspectable var shadowRadius: CGFloat { get { return self.layer.shadowRadius } set { self.layer.shadowRadius = newValue } }
    
    @IBInspectable var shadowOffset : CGSize { get { return self.layer.shadowOffset } set { self.layer.shadowOffset = newValue } }
    
    @IBInspectable var spread: CGFloat { get { return 0 } set { self.layer.shadowPath = newValue == 0 ? nil : UIBezierPath(rect: self.bounds.insetBy(dx: -newValue, dy: -newValue)).cgPath } }
    
    @IBInspectable var masksToBounds : Bool { get { return self.layer.masksToBounds } set { self.layer.masksToBounds = newValue } }
    
    @IBInspectable var shouldRasterize : Bool { get { return self.layer.shouldRasterize } set { self.layer.shouldRasterize = newValue } }
    
    private static func _loadFromStoryboard<T>(id: String) -> T
    {
        let viewController = UIStoryboard(name: id.replacingOccurrences(of: "ViewController", with: "").replacingOccurrences(of: "Controller", with: ""), bundle: nil).instantiateViewController(withIdentifier: self.className)
        let view = viewController.view
        viewController.view = nil
        return view as! T
    }
    
    static func loadFromStoryboard(id: String) -> Self
    {
        return self._loadFromStoryboard(id: id)
    }
    
    func resignFirstResponderOnTap(delegate: UIGestureRecognizerDelegate? = nil)
    {
        self.addGestureRecognizer(RDTapGestureRecognizer(delegate: delegate, callBack: { [weak self] _ in
            self?.endEditing(true)
        }))
    }
    
    func startLoader()
    {
        SVProgressHUD.show()
        self.isUserInteractionEnabled = false
    }
    
    func stopLoader()
    {
        SVProgressHUD.dismiss()
        self.isUserInteractionEnabled = true
    }
    
    @objc var isLoading: Bool { get { return SVProgressHUD.isVisible() } }
    
    func round(corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func animate(alpha: CGFloat, duration: TimeInterval = Constants.Animation.DefaultDuration, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], completion: ((Bool) -> Void)? = nil)
    {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { [weak self] in
            self?.alpha = alpha
            }, completion: completion)
    }
    
    func hideKeyboardOnTap()
    {
        let tap = RDTapGestureRecognizer(callBack: { [weak self] _ in
            self?.endEditing(true)
        })
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
}

extension UIButton {
    
    @IBInspectable var localizedTitle : String { get { return self.titleLabel?.text ?? "" } set { self.setTitle(LocalString(newValue), for: .normal) } }
    
    @IBInspectable var shouldAdjustFontSizeToFitDevice : Bool { get { return false } set { if(newValue) { self.adjustsFontSizeToFitDevice() } } }
    
    func adjustsFontSizeToFitDevice()
    {
        self.titleLabel?.adjustsFontSizeToFitDevice()
    }
    
    @IBInspectable var highlightedAdjustsAlpha: Bool
    {
        get { return false }
        set
        {
            if(newValue)
            {
                self.ceh.controlEvent([.touchDown, .touchDragInside, .touchDragEnter]) { [weak self] in
                    UIView.animate(withDuration: Constants.Animation.DefaultDuration, animations: { [weak self] in
                        self?.imageView?.alpha = 0.5
                        self?.titleLabel?.alpha = 0.5
                    })
                }
                
                self.ceh.controlEvent([.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit]) { [weak self] in
                    UIView.animate(withDuration: Constants.Animation.DefaultDuration, animations: { [weak self] in
                        self?.imageView?.alpha = 1
                        self?.titleLabel?.alpha = 1
                    })
                }
            }
        }
    }
    
    @IBInspectable var adjustContentEdgeInsetsToFitDevice : Bool
        {
        get { return false }
        set
        {
            self.contentEdgeInsets.top *= Constants.ScreenFactor
            self.contentEdgeInsets.left *= Constants.ScreenFactor
            self.contentEdgeInsets.bottom *= Constants.ScreenFactor
            self.contentEdgeInsets.right *= Constants.ScreenFactor
        }
    }
    
    @IBInspectable var adjustImageEdgeInsetsToFitDevice : Bool
        {
        get { return false }
        set
        {
            self.imageEdgeInsets.top *= Constants.ScreenFactor
            self.imageEdgeInsets.left *= Constants.ScreenFactor
            self.imageEdgeInsets.bottom *= Constants.ScreenFactor
            self.imageEdgeInsets.right *= Constants.ScreenFactor
        }
    }
    
    @IBInspectable var adjustTitleEdgeInsetsToFitDevice : Bool
        {
        get { return false }
        set
        {
            self.titleEdgeInsets.top *= Constants.ScreenFactor
            self.titleEdgeInsets.left *= Constants.ScreenFactor
            self.titleEdgeInsets.bottom *= Constants.ScreenFactor
            self.titleEdgeInsets.right *= Constants.ScreenFactor
        }
    }
    
    @IBInspectable var titleLabelAlignment: Int { get { return self.titleLabel?.textAlignment.rawValue ?? 0 } set { self.titleLabel?.textAlignment = NSTextAlignment(rawValue: newValue) ?? .left } }
    
    @IBInspectable var numberOfLines: Int { get { return self.titleLabel?.numberOfLines ?? 1 } set { self.titleLabel?.numberOfLines = newValue } }
    
    @IBInspectable var adjustsFontSizeToFitWidth: Bool { get { return self.titleLabel?.adjustsFontSizeToFitWidth ?? false } set { self.titleLabel?.adjustsFontSizeToFitWidth = newValue } }
    
    /// RDExtensionsSwift: Sets attributed text with given components
    func setAttributedText(_ components: [(String, [NSAttributedString.Key: Any])], for state: UIControl.State)
    {
        let label = UILabel()
        label.setAttributedText(components)
        self.setAttributedTitle(label.attributedText, for: state)
    }
    
}

extension UITableViewCell : Reusable {
    @objc func fill(with item: Any) {
    }
}

extension UIBarButtonItem {
    
    @IBInspectable var localizedTitle : String { get { return self.title ?? "" } set { self.title = LocalString(newValue) } }
    
}

extension UILabel {
    
    @IBInspectable var localizedText : String { get { return self.string } set { self.text = LocalString(newValue) } }
    
    @IBInspectable var shouldAdjustFontSizeToFitDevice : Bool { get { return false } set { if(newValue) { self.adjustsFontSizeToFitDevice() } } }
    
    func adjustsFontSizeToFitDevice()
    {
        if let f = self.font
        {
            self.font = UIFont(name: f.fontName, size: f.pointSize * Constants.ScreenFactor)
        }
    }
    
    /// RDExtensionsSwift: Sets attributed text with given components
    func addAttributedText(_ components: [(String, [NSAttributedString.Key: Any])])
    {
        let attributedText = NSMutableAttributedString(string: components.map { $0.0 }.joined())
        for i in 0 ..< components.count
        {
            attributedText.addAttributes(components[i].1, range: NSRange(location: components[0 ..< i].map { $0.0 }.joined().length, length: components[i].0.length))
        }
        let newAttributedText = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString())
        newAttributedText.append(attributedText)
        self.attributedText = newAttributedText
    }
    
}

extension UITextField {
    
    @IBInspectable var localizedText : String { get { return self.string } set { self.text = LocalString(newValue) } }
    
    @IBInspectable var localizedPlaceholder : String { get { return self.placeholder ?? "" } set { self.placeholder = LocalString(newValue) } }
    
    @IBInspectable var placeHolderColor: UIColor?
    {
        get { return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.attributedPlaceholder?.length ?? 0)) as? UIColor }
        set
        {
            if(newValue != nil)
            {
                let attributedText = self.attributedPlaceholder == nil ? NSMutableAttributedString(string: self.placeholder ?? "") : NSMutableAttributedString(attributedString: self.attributedPlaceholder!)
                attributedText.addAttribute(.foregroundColor, value: newValue!, range: NSRange(location: 0, length: attributedText.length))
                self.attributedPlaceholder = attributedText
            }
        }
    }
    
    @IBInspectable var placeHolderFont: UIFont?
    {
        get { return self.attributedPlaceholder?.attribute(.font, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.attributedPlaceholder?.length ?? 0)) as? UIFont }
        set
        {
            if(newValue != nil)
            {
                let attributedText = self.attributedPlaceholder == nil ? NSMutableAttributedString(string: self.placeholder ?? "") : NSMutableAttributedString(attributedString: self.attributedPlaceholder!)
                attributedText.addAttribute(.font, value: newValue!, range: NSRange(location: 0, length: attributedText.length))
                self.attributedPlaceholder = attributedText
            }
        }
    }
    
    @IBInspectable var shouldAdjustFontSizeToFitDevice : Bool { get { return false } set { if(newValue) { self.adjustsFontSizeToFitDevice() } } }
    
    func adjustsFontSizeToFitDevice()
    {
        if let f = self.font
        {
            self.font = UIFont(name: f.fontName, size: f.pointSize * Constants.ScreenFactor)
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightArrow(){
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_down")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20 * Constants.ScreenFactor)
        }
        setRightPaddingPoints(-30 * Constants.ScreenFactor)
    }
    
}

extension UITextView {
    
    @IBInspectable var localizedText : String { get { return self.string } set { self.text = LocalString(newValue) } }
    
    @IBInspectable var shouldAdjustFontSizeToFitDevice : Bool { get { return false } set { if(newValue) { self.adjustsFontSizeToFitDevice() } } }
    
    func adjustsFontSizeToFitDevice()
    {
        if let f = self.font
        {
            self.font = UIFont(name: f.fontName, size: f.pointSize * Constants.ScreenFactor)
        }
    }
    
}

extension Int64 {
    
    var currencyValue: NSDecimalNumber { get { return NSDecimalNumber(value: self).dividing(by: 100) } }
    
    var currencyValueGel: String { get { return self.currencyValue.toString() + " " + Constants.Currency.GEL } }
    
    func toCurrencyAttributedString(prefix: String? = nil, prefixFont: UIFont? = nil, prefixColor: UIColor? = nil, couponFont: UIFont, couponColor: UIColor = .white, coinsFont: UIFont, coinsColor: UIColor = .white, currencySymbol: String? = Constants.Currency.GEL) -> NSAttributedString
    {
        return self.currencyValue.toCurrencyAttributedString(prefix: prefix, prefixFont: prefixFont, prefixColor: prefixColor, couponFont: couponFont, couponColor: couponColor, coinsFont: coinsFont, coinsColor: coinsColor, currencySymbol: currencySymbol)
    }
    
}

extension Int {
    var timeValue: String {
        return self.toString.count == 1 ? "0" + self.toString :self.toString
    }
}

extension NSDecimalNumber {
    
    var currencyCoins: Int64
    {
        get
        {
            let decimalNumber = self.multiplying(by: 100)
            let formatter = NumberFormatter()
            formatter.positiveFormat = "0." + String(repeating: "0", count: 2)
            let value = formatter.string(from: decimalNumber)
            let number = NSDecimalNumber(string: value!).int64Value
            return number
        }
    }
    
    var toCurrencyString: String { get { return self.toString(trimZeros: true) + .space + Constants.Currency.GEL } }
    
    func toCurrencyAttributedString(prefix: String? = nil, prefixFont: UIFont? = nil, prefixColor: UIColor? = nil, couponFont: UIFont, couponColor: UIColor = .white, coinsFont: UIFont, coinsColor: UIColor = .white, currencySymbol: String? = Constants.Currency.GEL) -> NSAttributedString
    {
        return self.toString().toCurrencyAttributedString(prefix: prefix, prefixFont: prefixFont, prefixColor: prefixColor, couponFont: couponFont, couponColor: couponColor, coinsFont: coinsFont, coinsColor: coinsColor, currencySymbol: currencySymbol)
    }
    
}

extension UIWindow
{
    var lastPresentedViewController : UIViewController?
    {
        get
        {
            var top = self.rootViewController
            while true
            {
                if let presented = top?.presentedViewController
                {
                    top = presented
                }
                else if let nav = top as? UINavigationController
                {
                    top = nav.visibleViewController
                }
                else if let tab = top as? UITabBarController
                {
                    top = tab.selectedViewController
                }
                else
                {
                    break
                }
            }
            return top
        }
    }
}

extension NSObject {
    
    var ramPointer : String { get { return String(describing: Unmanaged.passUnretained(self).toOpaque()) } }
    
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { get { return self.viewControllers.last?.preferredStatusBarStyle ?? super.preferredStatusBarStyle } }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void)
    {
        self.pushViewController(viewController, animated: animated)
        if let coordinator = self.transitionCoordinator,
            animated
        {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        else
        {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void)
    {
        self.popViewController(animated: animated)
        if let coordinator = self.transitionCoordinator,
            animated
        {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        else
        {
            completion()
        }
    }
    
}

extension UITabBar {
    
    func itemIconImageView(at index: Int) -> UIImageView?
    {
        if let cls = NSClassFromString("UITabBarButton"),
            let imageView = self.subviews.filter({ $0.isKind(of: cls) }).object(at: index)?.subviews.filter({ $0 is UIImageView }).first as? UIImageView
        {
            return imageView
        }
        return  nil
    }
    
}

extension UITabBarController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { get { return self.currentViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle } }
    
}

extension CGColor {
    
    var uiColor: UIColor { get { return UIColor(cgColor: self) } }
    
}

extension UIApplication {
    
    var statusBarView: UIView? { get { return self.value(forKey: "statusBar") as? UIView } }
    
}

extension Collection /*where Element: Equatable */{
    
    func indexes(for block: @escaping (Element) -> Bool) -> [Int]
    {
        var indexes: [Int] = []
        var index = 0
        for element in self
        {
            if(block(element))
            {
                indexes.append(index)
            }
            index += 1
        }
        return indexes
    }
    
    func enumeratedMap<T>(transform: @escaping (Element, Int) -> T) -> [T]
    {
        var items: [T] = []
        var index = 0
        for item in self
        {
            items.append(transform(item, index))
            index += 1
        }
        return items
    }
    
    func iterableForEach(_ body: @escaping (Element) -> Void)
    {
        self.iterableForEach { item, _ in
            body(item)
        }
    }
    
    func iterableForEach(_ body: @escaping (Element, Int) -> Void)
    {
        var index = 0
        for item in self
        {
            body(item, index)
            index += 1
        }
    }
    
}

extension Collection {
    
    func removing(_ body: @escaping (Element) -> Bool) -> Self
    {
        return self.removing { item, _ in
            return body(item)
        }
    }
    
    func removing(_ body: @escaping (Element, Int) -> Bool) -> Self
    {
        var collection: [Element] = []
        var index = 0
        for item in self
        {
            if(!body(item, index))
            {
                collection.append(item)
            }
            index += 1
        }
        return collection as! Self
    }
    
    mutating func remove(_ body: @escaping (Element) -> Bool)
    {
        self.remove { item, _ in
            return body(item)
        }
    }
    
    mutating func remove(_ body: @escaping (Element, Int) -> Bool)
    {
        self = self.removing(body)
    }
    
}

extension UIRefreshControl {
    
    func forceBeginRefreshing(in tableView: UITableView? = nil)
    {
        self.beginRefreshing()
        tableView?.setContentOffset(CGPoint(x: 0, y: -self.frame.size.height), animated: true)
        self.sendActions(for: .valueChanged)
    }
    
}

extension UIImage{
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        destCGImage = nil
        return resizedImage
    }
    
    func compressImage(compressionQuality: CGFloat) -> UIImage?
    {
        var actualHeight = self.size.height;
        var actualWidth = self.size.width;
        let maxHeight = 600.0 as CGFloat;
        let maxWidth = 600.0 as CGFloat;
        var imgRatio = actualWidth/actualHeight;
        let maxRatio = maxWidth/maxHeight;
        //let compressionQuality = 1.0;//100 percent compression
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        
        UIGraphicsBeginImageContext(rect.size)
        
        self.draw(in: rect)
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        if let img = img {
            let imageData = img.jpegData(compressionQuality: compressionQuality);
            UIGraphicsEndImageContext();
            
            if let imageData = imageData {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Date {
    
    init?(cSharpFormattedValue: String)
    {
        if let date = Date(formattedString: cSharpFormattedValue, format: Constants.Date.cSharpFormat12Hour) ??
            Date(formattedString: cSharpFormattedValue, format: Constants.Date.cSharpFormat24Hour)
        {
            self = date
        }
        else
        {
            return nil
        }
    }
    
    var toCSharp12HourFormattedValue: String { get { return self.toString(Constants.Date.cSharpFormat12Hour) } }
    
    var toCSharp24HourFormattedValue: String { get { return self.toString(Constants.Date.cSharpFormat24Hour) } }
    
}

extension UISearchBar {
    
    private struct Keys {
        
        static let searchField = "searchField"
        
        static let clearButton = "clearButton"
        
        static let cancelButton = "cancelButton"
        
        static let placeholderLabel = "placeholderLabel"
        
        
    }
    
    var searchField: UITextField? { get { return self.value(forKey: Keys.searchField) as? UITextField } set { self.setValue(newValue, forKey: Keys.searchField) } }
    
    var clearButton: UIButton? { get { return self.value(forKey: Keys.clearButton) as? UIButton } set { self.setValue(newValue, forKey: Keys.clearButton) } }
    
    var cancelButton: UIButton? { get { return self.value(forKey: Keys.cancelButton) as? UIButton } set { self.setValue(newValue, forKey: Keys.cancelButton) } }
    
    var placeholderLabel: UILabel? { get { return self.value(forKey: Keys.placeholderLabel) as? UILabel } set { self.setValue(newValue, forKey: Keys.placeholderLabel) } }
    
}

extension Decodable {
    
    private static func _decode<T: Decodable>(from data: Data?, userInfo: [CodingUserInfoKey: Any]? = nil) throws -> T?
    {
        guard let data = data else
        {
            return nil
        }
        
        let decoder = JSONDecoder()
        if let userInfo = userInfo {
            for item in userInfo {
                decoder.userInfo[item.key] = item.value
            }
        }
        return try decoder.decode(T.self, from: data)
    }
    
    static func decode(from data: Data?, userInfo: [CodingUserInfoKey: Any]? = nil) -> Self?
    {
        do
        {
            return try self._decode(from: data, userInfo: userInfo)
        }
        catch
        {
            print(error.localizedDescription)
            return nil
        }
    }
    
}


extension CLLocationCoordinate2D {
    
    static var zero: CLLocationCoordinate2D { get { return CLLocationCoordinate2D(latitude: 0, longitude: 0) } }
    
    /// RDExtensionsSwift: Haversine Formula. Note: result is given in kilometers.
    func distance(from coordinate: CLLocationCoordinate2D) -> Double
    {
        let lat1rad = self.latitude * Double.pi/180
        let lon1rad = self.longitude * Double.pi/180
        let lat2rad = coordinate.latitude * Double.pi/180
        let lon2rad = coordinate.longitude * Double.pi/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 6372.8
        
        return R * c
    }
    
}

extension NSMutableParagraphStyle {
    
    convenience init(alignment: NSTextAlignment)
    {
        self.init()
        
        self.alignment = .center
    }
    
}

extension Decoder {
    
    func jsonValue() throws -> JSON
    {
        return try JSON(from: self)
    }
    
    var toJSON: JSON
    {
        get
        {
            do
            {
                return try self.jsonValue()
            }
            catch
            {
                print(error.localizedDescription)
                return JSON(NSNull())
            }
        }
    }
    
}

extension JSON {
    
    var toNSDecimalNumber: NSDecimalNumber? { get { return self.stringValue.toNSDecimalNumber } }
    
    var toNSDecimalNumberValue: NSDecimalNumber { get { return self.stringValue.toNSDecimalNumberValue } }
    
    func value<T: Decodable>(type: T.Type) -> T?
    {
        return T.decode(from: try? self.rawData())
    }
    
}

extension Data {
    
    func dataInMBs() -> Double {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        bcf.isAdaptive = false
        return bcf.string(fromByteCount: Int64(count)).toDouble
    }
}

extension Double {
    
}

extension UIImageView {
    
    func sd_setImage(with url: URL?, options: SDWebImageOptions = [], completed completedBlock: SDExternalCompletionBlock? = nil)
    {
        self.sd_setImage(with: url, placeholderImage: self.image, options: options, completed: completedBlock)
    }
    
}

extension Array {
    
    func split(maxLength: Int) -> [[Element]]
    {
        return self.count <= maxLength ? [self] : [Array(self[0 ..< maxLength])] + Array(self[maxLength ..< self.count]).split(maxLength: maxLength)
    }
    
}

extension RawRepresentable {
    
    init?(rawValue: RawValue?)
    {
        if let rawValue = rawValue,
            let value = Self(rawValue: rawValue)
        {
            self = value
        }
        else
        {
            return nil
        }
    }
    
}

extension Collection {
    
    var toArray: Array<Element> { get { return Array(self) } }
    
    func object(at index: Index) -> Element?
    {
        return self.indices.contains(index) ? self[index] : nil
    }
    
}

extension ArraySlice {
    
    var toArray: Array<Element> { get { return Array(self) } }
    
}

extension CodingUserInfoKey {
    
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
    
}
