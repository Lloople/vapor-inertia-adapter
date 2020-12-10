import Vapor

extension Request {
    
    private struct InertiaStorageKey: StorageKey {
        typealias Value = Inertia
    }
    
    public var inertia: Inertia {
        if (self.storage[InertiaStorageKey.self] == nil) {
            self.storage[InertiaStorageKey.self] = Inertia(self)
        }
        
        return self.storage[InertiaStorageKey.self]!
    }
    
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
