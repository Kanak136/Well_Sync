////
////  MoodCountCollectionViewCell.swift
////  wellSync
////
////  Created by Vidit Saran Agarwal on 30/03/26.
////
//
//import UIKit
//
//class MoodCollectionViewCell: UICollectionViewCell {
//    @IBOutlet var MoodCount: UILabel!
//
//    func confuger(total: Int) {
//        MoodCount.text = "\(total)"
//    }
//
////    func incress(by: Int) {
////        let newValue = (Int(MoodCount.text ?? "0") ?? 0) + by
////        MoodCount.text = "\(newValue)"
////        animateBounce()
////    }
////
////    private func animateBounce() {
////        // Scale up
////        UIView.animate(
////            withDuration: 0.15,
////            delay: 0,
////            usingSpringWithDamping: 0.3,
////            initialSpringVelocity: 8.0,
////            options: [.curveEaseInOut],
////            animations: {
////                self.MoodCount.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
////            }
////        ) { _ in
////            // Spring back to original size
////            UIView.animate(
////                withDuration: 0.4,
////                delay: 0,
////                usingSpringWithDamping: 0.4,
////                initialSpringVelocity: 6.0,
////                options: [.curveEaseInOut],
////                animations: {
////                    self.MoodCount.transform = .identity
////                },
////                completion: nil
////            )
////        }
////    }
//    func incress(by amount: Int) {
//        let newValue = (Int(MoodCount.text ?? "0") ?? 0) + amount
//        animateMerge(amount: amount) {
//            self.MoodCount.text = "\(newValue)"
//        }
//    }
//
//    private func animateMerge(amount: Int, completion: @escaping () -> Void) {
//        // 1. Create the floating label right beside MoodCount
//        let floatingLabel = UILabel()
//        floatingLabel.text = "\(amount)"
//        floatingLabel.font = MoodCount.font  // same font as the count label
//        floatingLabel.textColor = MoodCount.textColor
//        floatingLabel.alpha = 1
//        floatingLabel.sizeToFit()
//
//        // 2. Position it just to the right of MoodCount
//        let moodCountFrame = MoodCount.convert(MoodCount.bounds, to: self)
//        floatingLabel.frame.origin = CGPoint(
//            x: moodCountFrame.maxX + 6,
//            y: moodCountFrame.midY - floatingLabel.frame.height / 2
//        )
//        addSubview(floatingLabel)
//
//        // 3. Slow bounce in place (keyframe animation)
//        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: []) {
//            // bounce up
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
//                floatingLabel.transform = CGAffineTransform(translationX: 0, y: -10)
//            }
//            // bounce down past origin
//            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
//                floatingLabel.transform = CGAffineTransform(translationX: 0, y: 4)
//            }
//            // settle back
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
//                floatingLabel.transform = .identity
//            }
//            // slide into MoodCount and dissolve
//            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
//                floatingLabel.frame.origin.x = moodCountFrame.midX - floatingLabel.frame.width / 2
//                floatingLabel.frame.origin.y = moodCountFrame.midY - floatingLabel.frame.height / 2
//                floatingLabel.alpha = 0
//                floatingLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            }
//        } completion: { _ in
//            floatingLabel.removeFromSuperview()
//            completion()  // ← value updates exactly as it dissolves
//        }
//    }
//}
//
//import UIKit
//
//class MoodCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet var MoodCount: UILabel!
//
//    func configure(total: Int) {
//        MoodCount.text = "\(total)"
//    }
//
//    func increase() {
//        let oldValue = Int(MoodCount.text ?? "0") ?? 0
//        let newValue = oldValue + 1
//
//        animateIncrement(from: oldValue, to: newValue)
//    }
//
//    private func animateIncrement(from oldValue: Int, to newValue: Int) {
//
//        // 🔹 Haptic (feels premium)
//        let generator = UIImpactFeedbackGenerator(style: .light)
//        generator.impactOccurred()
//
//        // 🔹 Floating +1 label
//        let plusOne = UILabel(frame: MoodCount.frame)
//        plusOne.text = "+1"
//        plusOne.textAlignment = .center
//        plusOne.font = MoodCount.font
//        plusOne.textColor = .systemGreen
//        plusOne.alpha = 0
//        contentView.addSubview(plusOne)
//
//        // 🔹 Rolling number animation
//        animateCount(from: oldValue, to: newValue)
//
//        // 🔹 Main label bounce + slight rotation
//        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
//
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
//                self.MoodCount.transform =
//                    CGAffineTransform(scaleX: 1.6, y: 1.6)
//                    .rotated(by: CGFloat.pi / 12)
//            }
//
//            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
//                self.MoodCount.transform = .identity
//            }
//
//        }
//
//        // 🔹 +1 float upward + fade
//        UIView.animate(withDuration: 0.6, animations: {
//            plusOne.alpha = 1
//            plusOne.transform = CGAffineTransform(translationX: 0, y: -30)
//        }) { _ in
//            plusOne.removeFromSuperview()
//        }
//    }
//
//    // 🔥 Smooth counting effect
//    private func animateCount(from start: Int, to end: Int) {
//
//        let duration = 0.25
//        let frameRate: Double = 1 / 60
//        let totalFrames = Int(duration / frameRate)
//
//        for frame in 0...totalFrames {
//            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(frame) * frameRate)) {
//                let progress = Double(frame) / Double(totalFrames)
//                let value = Int(Double(start) + (Double(end - start) * progress))
//                self.MoodCount.text = "\(value)"
//            }
//        }
//    }
//}

//import UIKit
//
//class MoodCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet var MoodCount: UILabel!
//
//    func configure(total: Int) {
//        MoodCount.text = "\(total)"
//    }
//
//    func increase() {
//        let current = Int(MoodCount.text ?? "0") ?? 0
//        animatePlusOne(to: current + 1)
//    }
//
//    private func animatePlusOne(to newValue: Int) {
//        guard let container = MoodCount.superview else { return }
//        let labelFrame = container.convert(MoodCount.frame, to: contentView)
//
//        // Create +1 label
//        let plusOne = UILabel()
//        plusOne.text = "+1"
//        plusOne.font = UIFont.systemFont(ofSize: MoodCount.font.pointSize * 0.7, weight: .bold)
//        plusOne.textColor = .systemGreen
//        plusOne.alpha = 0
//        plusOne.sizeToFit()
//
//        // Position: right side of MoodCount, vertically centered
//        plusOne.center = CGPoint(
//            x: labelFrame.maxX + plusOne.frame.width / 2 + 4,
//            y: labelFrame.midY
//        )
//        contentView.addSubview(plusOne)
//
//        // STEP 1 — pop in (scale from 0 → 1)
//        plusOne.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//        UIView.animate(withDuration: 0.2, delay: 0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 8,
//                       options: []) {
//            plusOne.alpha = 1
//            plusOne.transform = .identity
//        } completion: { _ in
//
//            // STEP 2 — float straight up slowly
//            UIView.animate(withDuration: 0.7, delay: 0,
//                           options: [.curveEaseIn]) {
//                plusOne.center.y -= labelFrame.height + 10
//                plusOne.alpha = 0
//            } completion: { _ in
//                plusOne.removeFromSuperview()
//            }
//
//            // STEP 3 — cross dissolve the count at the midpoint of the float
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                UIView.transition(
//                    with: self.MoodCount,
//                    duration: 0.3,
//                    options: [.transitionCrossDissolve]
//                ) {
//                    self.MoodCount.text = "\(newValue)"
//                }
//            }
//        }
//    }
//}

import UIKit

class MoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet var MoodCount: UILabel!
    @IBOutlet var indicator: UIView!   // ← keep as UIView in storyboard, set class to MoodBarChartView

    var totalMood: [MoodLog] = []
    var todayMood: [MoodLog] = []

    private var chartView: MoodBarChartView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupChartView()
    }

    private func setupChartView() {
        let chart = MoodBarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        indicator.addSubview(chart)

        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: indicator.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: indicator.trailingAnchor),
            chart.topAnchor.constraint(equalTo: indicator.topAnchor),
            chart.bottomAnchor.constraint(equalTo: indicator.bottomAnchor)
        ])

        chartView = chart
    }

    func configure(mood: [MoodLog]) {
        totalMood      = mood
        let today      = Date()
        todayMood = totalMood.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        chartView?.update(with: todayMood)// ✅ show today's mood distribution
        MoodCount.text = "\(todayMood.count)"
    }
}

class MoodBarChartView: UIView {

    private let moodColors: [UIColor] = [
        UIColor(red: 0.87, green: 0.26, blue: 0.26, alpha: 1), // red      - mood 1
        UIColor(red: 0.94, green: 0.51, blue: 0.13, alpha: 1), // orange   - mood 2
        UIColor(red: 0.95, green: 0.78, blue: 0.18, alpha: 1), // yellow   - mood 3
        UIColor(red: 0.55, green: 0.76, blue: 0.29, alpha: 1), // lt green - mood 4
        UIColor(red: 0.20, green: 0.53, blue: 0.20, alpha: 1)  // dk green - mood 5
    ]

    // counts[0] = mood 1 count ... counts[4] = mood 5 count
    var counts: [Int] = [0, 0, 0, 0, 0] {
        didSet { setNeedsLayout() }
    }

    private var barLayers: [CAShapeLayer] = []

    override func layoutSubviews() {
        super.layoutSubviews()
        drawBars()
    }

//    private func drawBars() {
//        // Remove old layers
//        barLayers.forEach { $0.removeFromSuperlayer() }
//        barLayers.removeAll()
//
//        let total       = counts.reduce(0, +)
//        let maxCount    = counts.max() ?? 1
//        let barCount    = 5
//        let spacing:    CGFloat = 10
//        let barWidth:   CGFloat = (bounds.width - spacing * CGFloat(barCount - 1)) / CGFloat(barCount)
//        let maxBarHeight: CGFloat = bounds.height - 8
//        let minBarHeight: CGFloat = barWidth * 0.6  // minimum pill height
//
//        for i in 0..<barCount {
//            let count      = counts[i]
//            let ratio      = maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
//            let barHeight  = max(minBarHeight, ratio * maxBarHeight)
//            let xOrigin    = CGFloat(i) * (barWidth + spacing)
//            let yOrigin    = bounds.height - barHeight
//
//            let rect = CGRect(x: xOrigin, y: yOrigin, width: barWidth, height: barHeight)
//            let radius = barWidth / 2
//            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
//
//            let shapeLayer        = CAShapeLayer()
//            shapeLayer.path       = path.cgPath
//            shapeLayer.fillColor  = moodColors[i].cgColor
//
//            layer.addSublayer(shapeLayer)
//            barLayers.append(shapeLayer)
//        }
//    }
    private func drawBars() {
        barLayers.forEach { $0.removeFromSuperlayer() }
        barLayers.removeAll()

        let maxCount      = counts.max() ?? 0
        let barCount      = 5
        let spacing:      CGFloat = 12                                           // ✅ tighter spacing
        let barWidth:     CGFloat = (bounds.width - spacing * CGFloat(barCount - 1)) / CGFloat(barCount)
        let maxBarHeight: CGFloat = bounds.height - 1
        let minBarHeight: CGFloat = barWidth * 0.5                               // ✅ half-width = natural pill

        for i in 0..<barCount {
            let count     = counts[i]
            let ratio     = maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
            let barHeight = maxCount == 0
                ? minBarHeight
                : max(minBarHeight, ratio * maxBarHeight)

            let xOrigin   = CGFloat(i) * (barWidth + spacing)
            let yOrigin   = bounds.height - barHeight

            let rect      = CGRect(x: xOrigin, y: yOrigin, width: barWidth, height: barHeight)
            let radius    = barWidth / 2                                          // ✅ always fully rounded ends
            let path      = UIBezierPath(roundedRect: rect, cornerRadius: radius)

            let shapeLayer       = CAShapeLayer()
            shapeLayer.path      = path.cgPath
            shapeLayer.fillColor = maxCount == 0
                ? moodColors[i].withAlphaComponent(0.25).cgColor
                : moodColors[i].cgColor

            layer.addSublayer(shapeLayer)
            barLayers.append(shapeLayer)
        }
    }
    
    func update(with logs: [MoodLog]) {
        var c = [0, 0, 0, 0, 0]
        for log in logs {
            let index = log.mood - 1  // assuming mood is 1...5
            if index >= 0 && index < 5 {
                c[index] += 1
            }
        }
        counts = c
    }
}
