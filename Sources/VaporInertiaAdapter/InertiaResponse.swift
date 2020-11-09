import Vapor

public class InertiaResponse {
    
    let component: Component
    let rootView: String
    let version: String
    
    public init(component: Component, rootView: String, version: String) {
        self.component = component
        self.rootView = rootView
        self.version = version
    }
    
    public func toResponse(for request: Request) throws -> EventLoopFuture<Response> {
        
        let context = InertiaContext(
            component: try self.component.toJson(),
            version: self.version,
            url: request.url.string
        )
        
        if request.isInertia() {
            
            let response = Response(status: .ok, headers: .init([("Vary", "Accept"), ("X-Inertia", "true")]))
            
            try response.content.encode(context, as: .json)
            
            return request.eventLoop.future(response)
        }
        
        return request.view.render(self.rootView, context)
            .flatMap { $0.encodeResponse(for: request) }
    }
    
}
