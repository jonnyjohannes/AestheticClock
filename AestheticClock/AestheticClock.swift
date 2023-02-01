
import ScreenSaver

class AestheticClockView: ScreenSaverView {
    
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()
    var preferences: Preferences = Preferences()
    
    // MARK: - init

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        registerCustomFonts()
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configs

    override public var hasConfigureSheet: Bool {
        return true
    }
    
    override public var configureSheet: NSWindow? {
        return sheetController.window
    }
    
    // MARK: - animations
    
    override func draw(_ rect: NSRect) {
        if (Themes.dark.rawValue == preferences.getPref(key: Themes.typeName)) {
            drawBackground(.black)
            drawTime(.white)
        } else {
            drawBackground(.white)
            drawTime(.black)
        }
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        setNeedsDisplay(bounds)
    }

    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawTime(_ color: NSColor) {
        let timeString = "\(getCalendarComponent(.hour)) \(getCalendarComponent(.minute)) \(getCalendarComponent(.second))"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.firstLineHeadIndent = 0

        let baselineOffset = -(bounds.height - (bounds.width/4)) / 2

        let fontName = "HelveticaNeue-UltraLight"
        let fontSize = bounds.width / 5
        guard let font = NSFont(name: fontName, size: fontSize) else { return }

        let string = NSAttributedString(
            string: timeString,
            attributes: [
                NSAttributedString.Key.baselineOffset: baselineOffset,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
        string.draw(in: bounds)
    }
    
    // MARK: - helpers

    private func registerCustomFonts() {
        let paths = Bundle.main.paths(forResourcesOfType: "otf", inDirectory: "")
        for path in paths {
            let fontUrl = NSURL(fileURLWithPath: path)
            var errorRef: Unmanaged<CFError>?
            
            let success = CTFontManagerRegisterFontsForURL(fontUrl, .process, &errorRef)
                
            if (errorRef != nil) {
                let error = errorRef!.takeRetainedValue()
                print("Error registering custom font: \(error)")
            }
            print(success)
        }
    }
    
    private func getCalendarComponent(_ component: Calendar.Component) -> String {
        let date = Date()
        let calendar = Calendar.current

        if (.hour == component && Formats.mod12.rawValue == preferences.getPref(key: Formats.typeName)) {
            return String(format: "% 2d", ((calendar.component(component, from: date) + 11) % 12) + 1)
        }
        return String(format: "%02d", calendar.component(component, from: date))
    }
}
