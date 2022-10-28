//
//  FloatingDatePicker.swift
//  CarHome
//
//  Created by mac on 26/03/22.
//

import UIKit

@available(iOS 13.2, *)
public class FloatingDatePicker: UIView {
    
    // xib loader
    @IBOutlet public weak var view: UIView!
    private var didLoad: Bool = false
    private var timer: Timer?
    
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtDate: FloatingTextField!
    @IBOutlet weak var txtwDate: UITextField!
    @IBOutlet private weak var stackViewMarginLeft: NSLayoutConstraint!
    @IBOutlet private weak var stackViewMarginRight: NSLayoutConstraint!
    @IBOutlet private weak var stackViewMarginTop: NSLayoutConstraint!
    @IBOutlet private weak var stackViewMarginBottom: NSLayoutConstraint!
    @IBOutlet private weak var calendarIconConstraint: NSLayoutConstraint!
    
    // config
    var isFirstEmpty = true
    var title = ""
    var isMandatory = false
    
    public var initialDate: Date?
    public var minimumDate: Date? {
        didSet {
            self.checkDateLimits()
        }
    }
    public var maximumDate: Date? {
        didSet {
            self.checkDateLimits()
        }
    }
    public var pickerMode: UIDatePicker.Mode?
    public var dateFormat: String?
    public var closeWhenSelectingDate: Bool = true
    public var closeAnimationDuration: CGFloat = 0.3
    public var calendarIconIsHidden: Bool = false {
        didSet {
            self.calendarImageView.isHidden = self.calendarIconIsHidden
            self.txtDate.textAlignment = self.calendarIconIsHidden ? .center : .left
        }
    }
    public var calendarIconSizeMultiplier: CGFloat? {
        didSet {
            guard let newMultiplier = self.calendarIconSizeMultiplier, newMultiplier >= 0 && newMultiplier <= 1 else { return }
            self.calendarIconConstraint = self.calendarIconConstraint.setMultiplier(newMultiplier)
            self.layoutIfNeeded()
        }
    }
    public var font: UIFont? {
        didSet {
            self.txtDate.font = self.font
        }
    }
    public var textColor: UIColor? {
        didSet {
            self.txtDate.textColor = self.textColor
        }
    }
    public var leftMargin: Double = 0 {
        didSet {
            self.updateMargins()
        }
    }
    public var rightMargin: Double = 0 {
        didSet {
            self.updateMargins()
        }
    }
    public var topMargin: Double = 0 {
        didSet {
            self.updateMargins()
        }
    }
    public var bottomMargin: Double = 0 {
        didSet {
            self.updateMargins()
        }
    }

    func setTitle(title: String, isMandatory: Bool = false) {
        self.title = title
        self.isMandatory = isMandatory
        txtDate.setTitle(title: title, isMandatory: isMandatory)
    }
    
    public var forceScalePicker: Bool = true
    public var currentDate = Date() {
        didSet {
            DispatchQueue.main.async {
                self.isFirstEmpty = false
                self.didUpdateDate()
            }
        }
    }
    
    // callback
    public var didChangeDate: ((Date) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.didLoad {
            self.didLoad = true
            self.viewDidLoad()
        }
    }
    
    private func viewDidLoad() {
        self.prepareDatePicker()
        setupDateTextFeild()
        if #available(iOS 14, *) {
            self.timer = Timer(timeInterval: 0.0, repeats: true, block: { [weak self] _ in
                self?.hideDateLabel()
            })
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    private func setupDateTextFeild() {
        txtDate.textColor = UIColor(hexaRGBA: "162651")
    }
    
    private func prepareDatePicker() {

        if #available(iOS 14, *) {
            self.datePicker.isHidden = false
            self.txtwDate.isHidden = true
            self.hideDateLabel()
            self.txtDate.inputView = self.datePicker
            self.datePicker.layer.zPosition = CGFloat(MAXFLOAT)
            self.datePicker.datePickerMode = self.pickerMode ?? .date
            self.datePicker.alpha = 0.03
            self.datePicker.date = self.initialDate ?? Date()
            self.checkDateLimits()
            self.updateMargins()
        } else {
            self.datePicker.isHidden = true
            self.txtwDate.isHidden = false
            txtwDate.tintColor = .clear
            txtwDate.setInputViewDatePicker(target: self, selector:  #selector(tapDone), title: "", maxDate: self.maximumDate , minDate: self.minimumDate , dateType: .date, initialDate: self.initialDate ?? Date())
            checkDateLimits()
        }
    }
     
    @objc func tapDone() {
        if let wdatePicker = self.txtwDate.inputView as? UIDatePicker {
            self.currentDate = wdatePicker.date
        }
        self.didChangeDate?(self.currentDate)
        self.txtwDate.resignFirstResponder()
    }
    
    private func didUpdateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat ?? "dd/MM/YYYY"
        self.calendarImageView.tintColor = UIColor(hexaARGB: "5367FC")
        let date = isFirstEmpty ? "" : dateFormatter.string(from: self.currentDate)
        self.txtDate.text = date
        datePicker.setDate(self.currentDate, animated: false)
        if let wdatePicker = self.txtwDate.inputView as? UIDatePicker {
            wdatePicker.setDate(self.currentDate, animated: false)
        }
    }
    
    public func didFirstEmpty() {
        hideDateLabel()
        isFirstEmpty = true
        txtDate.setTitle(title: self.title, isMandatory: self.isMandatory)
        self.calendarImageView.tintColor = UIColor(named: "PreviousGeyColor")!
        txtDate.text = ""
    }
    
    private func checkDateLimits() {
        if #available(iOS 14, *) {
            self.datePicker.minimumDate = self.minimumDate
            self.datePicker.maximumDate = self.maximumDate
            
            if let minimumDate = self.minimumDate, self.datePicker.date < minimumDate {
                self.datePicker.date = minimumDate
            } else if let maximumDate = self.maximumDate, self.datePicker.date > maximumDate {
                self.datePicker.date = maximumDate
            }
            if !isFirstEmpty { self.currentDate = self.datePicker.date }
        } else {
            if let wdatePicker = self.txtwDate.inputView as? UIDatePicker {
                wdatePicker.minimumDate = self.minimumDate
                wdatePicker.maximumDate = self.maximumDate
                
                if let minimumDate = self.minimumDate, wdatePicker.date < minimumDate {
//                    wdatePicker.setDate(minimumDate, animated: false)
//                    wdatePicker.date = minimumDate
                } else if let maximumDate = self.maximumDate, wdatePicker.date > maximumDate {
//                    wdatePicker.setDate(maximumDate, animated: false)
//                    wdatePicker.date = maximumDate
                }
//                self.currentDate = datePicker.date
            }
        }
    }
    
    private func hideDateLabel() {
        if #available(iOS 14, *) {
            guard let datePickerLinkedLabel = self.datePicker.subviews.first?.subviews.first?.subviews.filter({ "\($0.classForCoder)" == "_UIDatePickerLinkedLabel" }).first else { return }
            
            datePickerLinkedLabel.tintColor = .clear
            datePickerLinkedLabel.alpha = 0
            datePickerLinkedLabel.backgroundColor = .clear
            
            if self.forceScalePicker {
                guard let actualPickerContainer = datePickerLinkedLabel.superview else { return }
                //        actualPickerContainer.transform = CGAffineTransform(scaleX: (self.view.frame.width / datePickerLinkedLabel.frame.width) * 2, y: 2)
                actualPickerContainer.transform = CGAffineTransform(scaleX: 6, y: 2.3)
            }
        }
    }
    
    @IBAction private func dateChangedAction(_ sender: UIDatePicker) {
        let changedDay: Bool = Calendar.current.component(.day, from: self.currentDate) != Calendar.current.component(.day, from: sender.date)
        
        self.hideDateLabel()
        self.txtDate.setTitle(title: self.title, isMandatory: self.isMandatory)
        self.calendarImageView.tintColor = UIColor(hexaRGBA: "162651")
        self.currentDate = sender.date
        self.didChangeDate?(self.currentDate)
        
        guard self.closeWhenSelectingDate else { return }
        guard changedDay else { return }
        
        guard let datePickerVC = self.getTopMostVC() else { return }
        let animationDuration = self.closeAnimationDuration
        
        let screenSize = UIScreen.main.bounds
        let positionOnScreen = self.convert(CGPoint.zero, to: nil)
        let anchorX = (positionOnScreen.x + self.frame.width / 2) / screenSize.width
        let anchorY = positionOnScreen.y / screenSize.height
        
        UIView.animate(withDuration: animationDuration, delay: 0.1, options: .curveEaseOut) { [weak self] in
            self?.setAnchorPoint(CGPoint(x: anchorX, y: anchorY), for: datePickerVC.view)
            datePickerVC.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: animationDuration / 2) {
                datePickerVC.view.alpha = 0
            }
        } completion: { [weak self] finished in
            if finished {
                DispatchQueue.main.async {
                    datePickerVC.dismiss(animated: false)
                    self?.hideDateLabel()
                }
            }
        }
    }
    
    private func updateMargins() {
        DispatchQueue.main.async {
            self.stackViewMarginLeft.constant = self.leftMargin
            self.stackViewMarginRight.constant = self.rightMargin
            self.stackViewMarginTop.constant = self.topMargin
            self.stackViewMarginBottom.constant = self.bottomMargin
            self.view.layoutIfNeeded()
        }
    }
   
}
// utils
@available(iOS 13.2, *)
fileprivate extension FloatingDatePicker {
    func getTopMostVC() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
    
    // https://www.hackingwithswift.com/example-code/calayer/how-to-change-a-views-anchor-point-without-moving-it
    func setAnchorPoint(_ point: CGPoint, for view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * point.x, y: view.bounds.size.height * point.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        newPoint = newPoint.applying(transform) ; oldPoint = oldPoint.applying(transform)
        var position = view.layer.position
        position.x -= oldPoint.x ; position.x += newPoint.x
        position.y -= oldPoint.y ; position.y += newPoint.y
        view.layer.position = position ; view.layer.anchorPoint = point
    }
}

extension FloatingDatePicker : UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hideDateLabel()
        self.view.endEditing(true)
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideDateLabel()
        textField.resignFirstResponder()
        return true
    }
    
}

// xib loader
@available(iOS 13.2, *)
fileprivate extension FloatingDatePicker {
    private func nibSetup() {
        self.view = self.loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(self.view)
    }

    private func loadViewFromNib() -> UIView {
        if let defaultBundleView = UINib(nibName: "FloatingDatePicker", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            return defaultBundleView
        } else {
            fatalError("Cannot load view from bundle")
        }
    }
}

// constraint utils
fileprivate extension NSLayoutConstraint {
    func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(item: firstItem as Any, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)

        newConstraint.priority = self.priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
