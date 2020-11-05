
public class Inertia {
    
    public static let instance = Inertia()
    
    private init() {}
    
    public var version: String = "no-version-configured"
    
    
    public func container(content: String) -> String {
        return "<div id='app' data-page='\(content)'></div>"
    }
}
