import Foundation

extension NSObject {
    /// Return a demangled type name for a given object.
    /// If `qualified` is `true`, Swift types will produce a qualified type name
    @objc(_kif_typeNameOfObject:qualified:)
    public static func _kif_typeName(object: Any, qualified: Bool) -> String {
        let meta = type(of: object)
        if qualified {
            return String(reflecting: meta)    
        } else {
            return String(describing: meta)
        }
    }
}
