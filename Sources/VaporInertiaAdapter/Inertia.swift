import Vapor

public class Inertia {
    
    public static let instance = Inertia()
    
    
    var rootView: String = "index"
    
    public var version: String = "no-version-configured"
    
    private init() {}
    
    public func container(content: String) -> String {
        return "<div id='app' data-page='\(content)'></div>"
    }
    
    public func location(url: String) -> Response {
        return Response(
            status: .conflict,
            headers: .init([("X-Inertia-Location", url)]),
            body: .empty
        )
    }
    
    public func render(component: Component) -> InertiaResponse {

        // TODO: Add shared properties to the component
        
        return InertiaResponse(
            component: component,
            rootView: self.rootView,
            version: self.version
        )
    }
}
