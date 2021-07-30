import Leaf

struct InertiaContainerTagError: Error {}

public struct InertiaContainerTag: LeafTag {
    
    public init() {}
    
    public func render(_ ctx: LeafContext) throws -> LeafData {
        // json is a parameter set in InertiaResponse.swift
        // contains a serialized json object from the rendered properties
        guard let json = ctx.data["json"]?.string else {
                throw InertiaContainerTagError()
        }
        return LeafData.string("<div id='app' data-page='\(json)'></div>'")
    }
}
