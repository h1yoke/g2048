/// `(Int, Int)` to `IntPair` convertible protocol.
protocol IntPairConvertible {
    init(_ pair: (Int, Int))
}

/// Integer pair structure.
///
/// Used for `Hashable` purposes.
struct IntPair: Hashable, IntPairConvertible {
    let int0: Int
    let int1: Int

    init(_ pair: (Int, Int)) {
        self.int0 = pair.0
        self.int1 = pair.1
    }
}

/// Dictionary extensions for more convenient 
extension Dictionary where Key: IntPairConvertible {
    subscript (key: (Int, Int)) -> Value? {
        get {
            return self[Key(key)]
        }
        set {
            self[Key(key)] = newValue
        }
    }
    subscript (key0: Int, key1: Int) -> Value? {
        get {
            return self[Key((key0, key1))]
        }
        set {
            self[Key((key0, key1))] = newValue
        }
    }
}
