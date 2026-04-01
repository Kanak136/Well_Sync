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

    func configure(total: Int) {
        MoodCount.text = "\(total)"
    }

    func increase() {
        let current = Int(MoodCount.text ?? "0") ?? 0
        animatePlusOne(to: current + 1)
    }

//    private func animatePlusOne(to newValue: Int) {
//        guard let container = MoodCount.superview else { return }
//        
//        // 1. Add subtle haptic feedback for a tactile feel
//        let generator = UIImpactFeedbackGenerator(style: .light)
//        generator.prepare()
//        generator.impactOccurred()
//
//        // 2. Main Number "Pop" Animation
//        // Swell up slightly, change the text, then spring back to normal
//        UIView.animate(withDuration: 0.15, animations: {
//            self.MoodCount.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
//        }) { [weak self] _ in
//            self?.MoodCount.text = "\(newValue)"
//            UIView.animate(withDuration: 0.3,
//                           delay: 0,
//                           usingSpringWithDamping: 0.5,
//                           initialSpringVelocity: 5,
//                           options: .curveEaseInOut,
//                           animations: {
//                self?.MoodCount.transform = .identity
//            })
//        }
//
//        // 3. Create the +1 Particle
//        let plusOne = UILabel()
//        plusOne.text = "+1"
//        plusOne.font = UIFont.systemFont(ofSize: MoodCount.font.pointSize * 0.6, weight: .heavy)
//        plusOne.textColor = .systemGreen
//        plusOne.alpha = 0
//        plusOne.sizeToFit()
//
//        // Start position: top right edge of the main counter
//        let labelFrame = container.convert(MoodCount.frame, to: contentView)
//        plusOne.center = CGPoint(
//            x: labelFrame.maxX - 5,
//            y: labelFrame.minY + 5
//        )
//        contentView.addSubview(plusOne)
//
//        // Initial state: Shrunk and tilted slightly left
//        plusOne.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            .concatenating(CGAffineTransform(rotationAngle: -0.2))
//
//        // 4. Keyframe Animation for the floating +1
//        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModeCubic]) {
//            
//            // Phase 1: Pop out, scale up, tilt right
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
//                plusOne.alpha = 1
//                plusOne.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                    .concatenating(CGAffineTransform(rotationAngle: 0.1))
//                plusOne.center.x += 15
//                plusOne.center.y -= 15
//            }
//            
//            // Phase 2: Settle scale back to 1.0, continue drifting up
//            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
//                plusOne.transform = .identity
//                plusOne.center.y -= 15
//            }
//            
//            // Phase 3: Shrink slightly, float higher, and fade out smoothly
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
//                plusOne.alpha = 0
//                plusOne.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//                plusOne.center.y -= 25
//            }
//            
//        } completion: { _ in
//            plusOne.removeFromSuperview()
//        }
//    }
    private func animatePlusOne(to newValue: Int) {
            guard let container = MoodCount.superview else { return }
            
            // 1. Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()

            // 2. Main Number "Pop" Animation
            UIView.animate(withDuration: 0.15, animations: {
                self.MoodCount.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }) { [weak self] _ in
                self?.MoodCount.text = "\(newValue)"
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 5,
                               options: .curveEaseInOut,
                               animations: {
                    self?.MoodCount.transform = .identity
                })
            }

            // 3. Create the +1 Particle
            let plusOne = UILabel()
            plusOne.text = "+1"
            plusOne.font = UIFont.systemFont(ofSize: MoodCount.font.pointSize * 0.6, weight: .heavy)
            plusOne.textColor = .systemGreen
            plusOne.alpha = 0
            plusOne.sizeToFit()

            let labelFrame = container.convert(MoodCount.frame, to: contentView)
            
            // --- NEW RANDOMIZATION LOGIC ---
            
            // Random Start Position (Anywhere within the label's frame)
            let randomStartX = labelFrame.midX + CGFloat.random(in: -(labelFrame.width/2)...(labelFrame.width/2))
            let randomStartY = labelFrame.midY + CGFloat.random(in: -(labelFrame.height/2)...(labelFrame.height/2))
            plusOne.center = CGPoint(x: randomStartX, y: randomStartY)
            
            // Random Initial Tilt (Between -30 and +30 degrees roughly)
            let randomInitialRotation = CGFloat.random(in: -0.5...0.5)
            
            // Random Drift Trajectory (Mostly upward, random left or right spread)
            let driftX = CGFloat.random(in: -30...30)
            let driftY = CGFloat.random(in: -40...(-20))

            // -------------------------------
            
            contentView.addSubview(plusOne)

            // Initial state: Shrunk and randomly tilted
            plusOne.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                .concatenating(CGAffineTransform(rotationAngle: randomInitialRotation))

            // 4. Keyframe Animation with random trajectories
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModeCubic]) {
                
                // Phase 1: Pop out, scale up, settle rotation
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                    plusOne.alpha = 1
                    plusOne.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        .concatenating(CGAffineTransform(rotationAngle: randomInitialRotation * 0.5)) // Ease out the tilt
                    plusOne.center.x += (driftX * 0.3)
                    plusOne.center.y += (driftY * 0.3)
                }
                
                // Phase 2: Settle scale back to 1.0, continue drift
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    plusOne.transform = .identity
                    plusOne.center.x += (driftX * 0.3)
                    plusOne.center.y += (driftY * 0.3)
                }
                
                // Phase 3: Shrink slightly, drift to final position, fade out
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    plusOne.alpha = 0
                    plusOne.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    plusOne.center.x += (driftX * 0.4)
                    plusOne.center.y += (driftY * 0.4)
                }
                
            } completion: { _ in
                plusOne.removeFromSuperview()
            }
        }
}
