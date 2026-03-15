import UIKit
import FSCalendar

class CalendarCell: UICollectionViewCell, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendar: FSCalendar!

    var selectedDate = Date()
    override func awakeFromNib() {
        calendar.delegate = self
        calendar.dataSource = self

        configureCalendar()
    }
        func configureCalendar() {

            calendar.scope = .month
            calendar.scrollDirection = .horizontal
            calendar.firstWeekday = 1

            calendar.appearance.selectionColor = .systemRed
            calendar.appearance.todayColor = UIColor.systemRed.withAlphaComponent(0.6)
            calendar.appearance.titleSelectionColor = .white

            calendar.placeholderType = .none
            calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .medium)
            calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)

            calendar.appearance.borderRadius = 1
            
            calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)

            calendar.appearance.weekdayTextColor = .secondaryLabel
            calendar.appearance.headerTitleColor = .label
            calendar.appearance.eventDefaultColor = .systemRed

        }
    func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {

            selectedDate = date
            print("Selected:", date)
        }
    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {

        calendar.frame.size.height = bounds.height
    }

}
