import Vapor
import Foundation

public struct InertiaMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        // TODO: Share errors, need to learn about Vapor's validation first
        
        // TODO: Configure root view
                
        return next.respond(to: request).map { response in
            if request.inertiaExpired(version: Inertia.instance.version) {
                
                response.status = .conflict
                response.headers.add(name: "X-Inertia-Location", value: request.url.string)
                response.body = .empty
            }
            
            if self.shouldChangeRedirectStatusCode(request: request, response: response) {
                response.status = .seeOther
            }
            
            return response
        }
    }
    
    func shouldChangeRedirectStatusCode(request: Request, response: Response) -> Bool {
        return request.isInertia()
            && response.status == .found
            && [.PUT, .PATCH, .DELETE].contains(request.method)
    }
}
