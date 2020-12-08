import Vapor

public final class InertiaRedirectMiddleware<A>: Middleware
    where A: Authenticatable
{
    
    let makePath: (Request) -> String
    
    init(_ authenticatableType: A.Type = A.self, makePath: @escaping (Request) -> String) {
        self.makePath = makePath
    }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response>
        where A: Authenticatable
    {
        if request.auth.has(A.self) {
            return next.respond(to: request)
        }

        request.headers.add(name: "X-Inertia", value: "true")
        
        let redirect = request.redirect(to: self.makePath(request))
        
        return request.eventLoop.makeSucceededFuture(redirect)
    }
}
