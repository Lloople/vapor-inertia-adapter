import Vapor

extension Application {
    
    public func registerInertia() {
        self.leaf.tags["inertia"] = InertiaContainerTag()
    }
}

