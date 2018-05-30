import Darwin

//  Angle.swift
//  SwiftPlaneGeometry

// Represents the degree of turn between two straight
// lines with a common vertex
public struct Angle : CustomStringConvertible, Equatable {
	
	/// The pi constant, the ratio of a circle's circumference to its diameter
	public static let (pi, π) = (Double.pi, Double.pi)
	
	/// The tau constant, the ratio of a circle's circumference to its radius
	public static let (tau, τ)  = (2 * pi, 2 * pi)
	
	/// The default constructor creates a zero angle
	public init() { _radians = 0 }
	
	/// Initializes with radians
	public init(radians: Double) { _radians = radians }
	
	/// Initializes with user-supplied degrees
	public init(degrees: Double) { _radians = degrees * Angle.pi / 180.0 }
	
	/// Initializes with user-supplied count of π's
	public init(multiplesOfPi piCount: Double) { _radians = piCount * Angle.pi }
	
	/// Initializes with user-supplied count of τ's
	public init(multiplesOfTau tauCount: Double) { _radians = tauCount * Angle.pi }
	
	/// Expresses angle in degrees
	public var degrees: Double { return _radians * 180.0 / Angle.pi }
	
	/// Expresses angles as a count of pi
	public var multiplesOfPi: Double { return _radians / Angle.pi }
	
	/// Expresses angles as a count of tau
	public var multiplesOfTau: Double { return _radians / Angle.tau }
	
	/// Expresses angle in (native) radians
	public var radians: Double { return _radians }
	
	/// String convertible support
	public var description: String {
		return "\(degrees)°, \(multiplesOfPi)π, \(radians) rads"
	}
	
	/// Compares two angles, conforming type to `Equatable`
	public static func ==(lhs: Angle, rhs: Angle) -> Bool {
		return lhs.radians == rhs.radians
	}
	
	/// Internal radian store
	private let _radians: Double
}

//  Angle+Trig.swift
//  SwiftPlaneGeometry

extension Angle {
	/// Returns sine
	public var sin: Double { return Darwin.sin(radians) }
	
	/// Returns cosine
	public var cos: Double { return Darwin.cos(radians) }
	
	/// Returns tangent
	public var tan: Double { return Darwin.tan(radians) }
	
	/// Returns hyperbolic sine
	public var sinh: Double { return Darwin.sinh(radians) }
	
	/// Returns hyperbolic cosine
	public var cosh: Double { return Darwin.cosh(radians) }
	
	/// Returns hyperbolic tangent
	public var tanh: Double { return Darwin.tanh(radians) }
	
	/// Returns cosecant
	public var csc: Double { return 1 / sin }
	
	/// Returns secant
	public var sec: Double { return 1 / cos }
	
	/// Returns cotangent
	public var cot: Double { return 1 / tan }
}

extension Double {
	/// Returns angle corresponding to arcsin
	public var asin: Angle { return Angle(radians: Darwin.asin(self)) }
	
	/// Returns angle corresponding to arccos
	public var acos: Angle { return Angle(radians: Darwin.acos(self)) }
	
	/// Returns angle corresponding to arctan
	public var atan: Angle { return Angle(radians: Darwin.atan(self)) }
	
	/// Returns angle corresponding to inverse hyperbolic sine function
	public var asinh: Angle { return Angle(radians: Darwin.asinh(self)) }
	
	/// Returns angle corresponding to inverse hyperbolic cos function
	public var acosh: Angle { return Angle(radians: Darwin.acosh(self)) }
	
	/// Returns angle corresponding to inverse hyperbolic tan function
	public var atanh: Angle { return Angle(radians: Darwin.atanh(self)) }
}
