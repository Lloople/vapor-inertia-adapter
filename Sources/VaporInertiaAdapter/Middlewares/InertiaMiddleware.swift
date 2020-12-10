import Vapor

public struct InertiaMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
                                
        return next.respond(to: request).map { response in
            
            if request.inertiaExpired(version: request.inertia.version) {
                return request.inertia.location(url: request.url.string)
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
