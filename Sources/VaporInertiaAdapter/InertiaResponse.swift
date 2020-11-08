import Foundation
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
            return Response(
                status: .ok,
                headers: .init([("Vary", "Accept"), ("X-Inertia", "true")]),
                body: .init(data: try JSONSerialization.data(withJSONObject: context))
            ).encodeResponse(for: request)
        }
        
        return request.view.render(self.rootView, context)
            .flatMap { $0.encodeResponse(for: request) }
    }
    
}
