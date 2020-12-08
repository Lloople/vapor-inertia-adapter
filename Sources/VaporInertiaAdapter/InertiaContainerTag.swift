import Leaf

struct InertiaContainerTagError: Error {}

public struct InertiaContainerTag: LeafTag {
    
    public init() {}
    
    public func render(_ ctx: LeafContext) throws -> LeafData {
        guard let json = ctx.parameters[0].string else {
            throw InertiaContainerTagError()
        }
        
        return LeafData.string("<div id='app' data-page='\(json)'></div>'")
    }
}
