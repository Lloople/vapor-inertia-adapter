import Vapor

extension Request {
    public func isInertia() -> Bool {
        return self.headers.contains(name: "X-Inertia")
    }
    
    public func inertiaVersion() -> String {
        return self.headers.first(name: "X-Inertia-Version") ?? ""
    }
    
    public func inertiaExpired(version: String) -> Bool {
        return self.method == .GET
            && self.isInertia()
            && self.inertiaVersion() != version
    }
}
