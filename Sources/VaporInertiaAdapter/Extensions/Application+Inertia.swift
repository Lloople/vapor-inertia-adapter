import Vapor

extension Application {
    
    public func registerInertia() {
        self.leaf.tags["inertia"] = InertiaContainerTag()
        self.middleware.use(InertiaMiddleware())
    }

    public func registerInertia(version:String, shared:[String:Any]? = nil) {
        self.registerInertia()
        Inertia.instance().setVersion(version)
        if shared != nil {
            Inertia.instance().share(shared!)
        }
    }
}

