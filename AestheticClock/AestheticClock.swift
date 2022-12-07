
import ScreenSaver

class AestheticClockView: ScreenSaverView {
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        registerCustomFonts()
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: NSRect) {
        drawBackground(.black)
        drawTime(.white)
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
        let date = Date()
        let calendar = Calendar.current
        let hour = String(format: "%02d", calendar.component(.hour, from: date))
        let minutes = String(format: "%02d", calendar.component(.minute, from: date))
        let seconds = String(format: "%02d", calendar.component(.second, from: date))
        let timeString = "\(hour) \(minutes) \(seconds)"
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let string = NSAttributedString(
            string: timeString,
            attributes: [
                NSAttributedString.Key.baselineOffset: -(bounds.height-(bounds.width/5))/2,
                NSAttributedString.Key.paragraphStyle: paragraph,
                NSAttributedString.Key.font: NSFont(name: "HelveticaNeue-UltraLight", size: bounds.width / 5),
                NSAttributedString.Key.foregroundColor: color
            ]
        )
        string.draw(in: bounds)
    }
    
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
    
    func printFamilyNames() -> String {
        let fontManager = NSFontManager.shared
        var array = [String]()
        for family in fontManager.availableFontFamilies {
            if let fonts = fontManager.availableMembers(ofFontFamily: family) {
                for font in fonts {
                    if font.description.contains("HelveticaNeue-UltraLight") {
                        array.append(font.description)
                    }
                }
            }
        }
        return array.joined(separator: "\n")
    }
}
