import Foundation

struct InertiaContext: Encodable {
    
    let component: Data
    let version: String
    let url: String
    
    public init(component: Data, version: String, url: String) {
        self.component = component
        self.version = version
        self.url = url
    }
}
