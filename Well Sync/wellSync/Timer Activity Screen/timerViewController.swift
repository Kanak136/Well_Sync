////
////  timerViewController.swift
////  wellSync
////
////  Created by Vidit Saran Agarwal on 08/04/26.
////
//
//import UIKit
//
//class TimerRingView: UIView {
//
//    let trackLayer = CAShapeLayer()
//    let progressLayer = CAShapeLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .clear
//        setupLayers()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupLayers()
//    }
//
//    private func setupLayers() {
//        let circularPath = UIBezierPath(
//            arcCenter: .zero,
//            radius: 100,
//            startAngle: -CGFloat.pi / 2,
//            endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
//            clockwise: true
//        )
//
//        // Track
//        trackLayer.path = circularPath.cgPath
//        trackLayer.strokeColor = UIColor.systemGray5.cgColor
//        trackLayer.lineWidth = 12
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineCap = .round
//        trackLayer.position = center
//
//        // Progress
//        progressLayer.path = circularPath.cgPath
//        progressLayer.strokeColor = UIColor.systemBlue.cgColor
//        progressLayer.lineWidth = 12
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.lineCap = .round
//        progressLayer.strokeEnd = 0
//        progressLayer.position = center
//
//        layer.addSublayer(trackLayer)
//        layer.addSublayer(progressLayer)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//        progressLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//    }
//
//    func setProgress(_ progress: CGFloat) {
//        progressLayer.strokeEnd = progress
//    }
//}
//
////class timerViewController: UIViewController {
////
////    @IBOutlet weak var timerLabel: UILabel!
////    @IBOutlet weak var durationSelector: UIDatePicker!
////    @IBOutlet weak var doctorsRecommandation: UILabel!
////    var timer: Timer?
////    var totalTime: Int = 0
////    var remainingTime: Int = 0
////    var isRunning = false
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////    }
////    @IBAction func startStop(_ sender: UIButton) {
////    }
////    @IBAction func pause(_ sender: UIButton) {
////    }
////    @IBAction func logActivity(_ sender: UIBarButtonItem) {
////    }
////    @IBAction func close(_ sender: UIBarButtonItem) {
////        dismiss(animated: true)
////    }
////}
//
//class timerViewController: UIViewController {
//
//    @IBOutlet weak var timerLabel: UILabel!
//    @IBOutlet weak var durationSelector: UIDatePicker!
//    @IBOutlet weak var doctorsRecommandation: UILabel!
//
//    var timer: Timer?
//    var totalTime: Int = 0
//    var remainingTime: Int = 0
//    var isRunning = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        durationSelector.datePickerMode = .countDownTimer
//        
//        // Default UI
//        updateUI()
//        
//        // Example recommendation
//        doctorsRecommandation.text = "Recommended: 20 min"
//    }
//
//    // MARK: - Start / Stop Toggle
//    @IBAction func startStop(_ sender: UIButton) {
//
//        if isRunning {
//            // STOP
//            timer?.invalidate()
//            isRunning = false
//            
//            remainingTime = totalTime
//            updateUI()
//            
//            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
//            sender.tintColor = .systemBlue
//        } else {
//            // START
//            
//            // Get time from picker
//            totalTime = Int(durationSelector.countDownDuration)
//            
//            // Prevent zero timer
//            guard totalTime > 0 else { return }
//            
//            remainingTime = totalTime
//            isRunning = true
//            
//            sender.setImage(UIImage(systemName: "stop.fill"), for: .normal)
//
//            timer?.invalidate()
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                self.tick(sender: sender)
//            }
//            sender.tintColor = .systemRed
//        }
//    }
//
//    // MARK: - Pause
//    @IBAction func pause(_ sender: UIButton) {
//        timer?.invalidate()
//        isRunning = false
//    }
//
//    // MARK: - Tick
//    func tick(sender: UIButton) {
//        if remainingTime > 0 {
//            remainingTime -= 1
//            updateUI()
//        } else {
//            timer?.invalidate()
//            isRunning = false
//            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        }
//    }
//
//    // MARK: - UI Update
//    func updateUI() {
//        let hrs = remainingTime / 3600
//        let mins = (remainingTime % 3600) / 60
//        let secs = remainingTime % 60
//
//        timerLabel.text = String(format: "%02d:%02d:%02d", hrs, mins, secs)
//    }
//
//    // MARK: - Log Activity
//    @IBAction func logActivity(_ sender: UIBarButtonItem) {
//
//        let duration = totalTime - remainingTime
//
//        guard duration > 0 else {
//            print("No activity logged")
//            return
//        }
//
//        print("Logged duration:", duration)
//
//        // 🔥 Integrate with your backend here:
//        // pass duration + activityID + patientID
//        
//        dismiss(animated: true)
//    }
//
//    // MARK: - Close
//    @IBAction func close(_ sender: UIBarButtonItem) {
//        timer?.invalidate()
//        dismiss(animated: true)
//    }
//}
import UIKit
class TimerRingView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setupLayers()
    }

    private func setupLayers() {
        trackLayer.strokeColor = UIColor.systemGray5.cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round

        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = min(bounds.width, bounds.height) / 2 - 12
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let path = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    func setProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
    }
}

class timerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var durationSelector: UIDatePicker!
    @IBOutlet weak var doctorsRecommandation: UILabel!
    @IBOutlet weak var ringView: TimerRingView!

    var timer: Timer?
    var totalTime: Int = 0
    var remainingTime: Int = 0
    var isRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()

        durationSelector.datePickerMode = .countDownTimer
        doctorsRecommandation.text = "Recommended: 20 min"

        updateUI()
    }

    // MARK: - Start / Stop / Resume
    @IBAction func startStop(_ sender: UIButton) {

        if isRunning {
            // STOP (full reset)
            timer?.invalidate()
            isRunning = false

            remainingTime = 0
            updateUI()

            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            sender.tintColor = .systemBlue
            durationSelector.isUserInteractionEnabled = true

        } else {
            // START or RESUME

            // Only initialize if fresh start
            if remainingTime == 0 {
                totalTime = Int(durationSelector.countDownDuration)
                guard totalTime > 0 else { return }
                remainingTime = totalTime
            }

            isRunning = true

            sender.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            sender.tintColor = .systemRed
            durationSelector.isUserInteractionEnabled = false

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.tick(sender: sender)
            }
        }
    }

    // MARK: - Pause (NO RESET)
    @IBAction func pause(_ sender: UIButton) {
        timer?.invalidate()
        isRunning = false
    }

    // MARK: - Timer Tick
    func tick(sender: UIButton) {

        if remainingTime > 0 {
            remainingTime -= 1
            updateUI()
        } else {
            // Completed
            timer?.invalidate()
            isRunning = false

            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            sender.tintColor = .systemBlue

            durationSelector.isUserInteractionEnabled = true
        }
    }

    // MARK: - Update UI (Label + Ring)
    func updateUI() {

        let hrs = remainingTime / 3600
        let mins = (remainingTime % 3600) / 60
        let secs = remainingTime % 60

        timerLabel.text = String(format: "%02d:%02d:%02d", hrs, mins, secs)

        // Ring Progress
        if totalTime > 0 {
            let progress = 1 - (CGFloat(remainingTime) / CGFloat(totalTime))
            ringView.setProgress(progress)
        } else {
            ringView.setProgress(0)
        }
    }

    // MARK: - Log Activity
    @IBAction func logActivity(_ sender: UIBarButtonItem) {

        let duration = totalTime - remainingTime

        guard duration > 0 else {
            print("No activity logged")
            return
        }

        print("Logged duration:", duration)

        dismiss(animated: true)
    }

    // MARK: - Close
    @IBAction func close(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        dismiss(animated: true)
    }
}
