import Vapor

extension Authenticatable {
    public static func inertiaRedirectMiddleware(path: String) -> Middleware {
        self.inertiaRedirectMiddleware(makePath: { _ in path })
    }
    
    public static func inertiaRedirectMiddleware(makePath: @escaping (Request) -> String) -> Middleware {
        InertiaRedirectMiddleware<Self>(makePath: makePath)
    }
}
