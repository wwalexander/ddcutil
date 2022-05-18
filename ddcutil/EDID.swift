import Foundation
import BinaryCodable

enum EDIDError: String, LocalizedError {
    var errorDescription: String? { self.rawValue }

    case todoErrorNotLocalized = "TODO: Localize error"
    case todoNotImplemented = "TODO: Implement feature"
}

public struct EDID: BinaryCodable, Encodable, Equatable {
    static let header = Data([0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00])
    static let structureVersionAndRevision = EDIDStructureVersionAndRevision(1, 4)
    
    public let idManufacturerName: EDIDManufacturerName
    public let idProductCode: UInt16
    public let idSerialNumber: UInt32
    public let weekAndYearOfManufactureOrModelYear: EDIDWeekAndYearOfManufactureOrModelYear
    
    public init(idManufacturerName: EDIDManufacturerName, idProductCode: UInt16, idSerialNumber: UInt32, weekAndYearOfManufactureOrModelYear: EDIDWeekAndYearOfManufactureOrModelYear) {
        self.idManufacturerName = idManufacturerName
        self.idProductCode = idProductCode
        self.idSerialNumber = idSerialNumber
        self.weekAndYearOfManufactureOrModelYear = weekAndYearOfManufactureOrModelYear
    }
    
    public init(from decoder: BinaryDecoder) throws {
        var container = decoder.container(maxLength: 128)
        
        guard case EDID.header = try container.decode(length: 8) else {
            throw EDIDError.todoErrorNotLocalized
        }
        
        self.idManufacturerName = try container.decode(EDIDManufacturerName.self)
        self.idProductCode = try container.decode(UInt16.self)
        self.idSerialNumber = try container.decode(UInt32.self)
        self.weekAndYearOfManufactureOrModelYear = try container.decode(EDIDWeekAndYearOfManufactureOrModelYear.self)
        let structureVersionAndRevision = try container.decode(EDIDStructureVersionAndRevision.self)
        
        guard case EDID.structureVersionAndRevision = structureVersionAndRevision else {
            throw EDIDError.todoErrorNotLocalized
        }
        
        //throw EDIDError.todoNotImplemented
    }
    
    public func encode(to encoder: BinaryEncoder) throws {
        var container = encoder.container()
        try container.encode(sequence: EDID.header)
        try container.encode(self.idManufacturerName)
        try container.encode(self.idProductCode)
        try container.encode(self.idSerialNumber)
        try container.encode(self.weekAndYearOfManufactureOrModelYear)
        try container.encode(EDID.structureVersionAndRevision)
    }
    
    enum CodingKeys: String, CodingKey {
        case idManufacturerName = "ID Manufacturer Name"
        case idProductCode = "ID Product Code"
        case idSerialNumber = "ID Serial Number"
        case weekAndYearOfManufactureOrModelYear = "Week and Year of Manufacture or Model Year"
    }
}

public typealias EDIDManufacturerName = String

extension EDIDManufacturerName: BinaryCodable {
    static let characterCount = 3
    static let characterRange = (Character("A")...Character("Z"))
    static let compressedASCIICodeLength = 5
    static let compressedASCIICodeOffset: UInt8 = Character("A").asciiValue! - 1
    
    public init?(_ description: String) {
        guard case EDIDManufacturerName.characterCount = description.count else {
            return nil
        }
        
        guard description.allSatisfy(EDIDManufacturerName.characterRange.contains) else {
            return nil
        }
        
        self = description
    }
    
    public init(from decoder: BinaryDecoder) throws {
        var container = decoder.container(maxLength: 2)
        let rawValue = try container.decode(UInt16.self).bigEndian
        
        guard rawValue >> 15 & 0b1 == 0 else {
            throw EDIDError.todoErrorNotLocalized
        }
        
        let bytes = (0..<EDIDManufacturerName.characterCount)
            .reversed()
            .map { index -> UInt8 in
                let places = index * EDIDManufacturerName.compressedASCIICodeLength
                let compressedASCIICode = UInt8(rawValue >> places & 0b11111)
                return compressedASCIICode + EDIDManufacturerName.compressedASCIICodeOffset
            }
        
        guard let manufacturerName = String(bytes: bytes, encoding: .ascii) else {
            throw EDIDError.todoErrorNotLocalized
        }
        
        self = manufacturerName
    }
    
    public func encode(to encoder: BinaryEncoder) throws {
        var container = encoder.container()
        
        let rawValue = self
            .compactMap { character in character.asciiValue }
            .reversed()
            .enumerated()
            .map { index, asciiValue -> UInt16 in
                let compressedASCIICode = asciiValue - EDIDManufacturerName.compressedASCIICodeOffset
                let places = index * EDIDManufacturerName.compressedASCIICodeLength
                return UInt16(compressedASCIICode) << places
            }
            .reduce(UInt16(0), { $0 | $1 })
        
        try container.encode(rawValue.bigEndian)
    }
}

public enum EDIDWeekAndYearOfManufactureOrModelYear: BinaryCodable, Encodable, Equatable {
    case weekAndYearOfManufacture(week: UInt8?, year: UInt16)
    case modelYear(UInt16)
    
    public init(from decoder: BinaryDecoder) throws {
        var container = decoder.container(maxLength: 2)
        let weekRawValue = try container.decode(UInt8.self)
        let yearRawValue = try container.decode(UInt8.self)
        let year = UInt16(yearRawValue) + 1990
        
        switch weekRawValue {
        case 0x37...0xfe:
            throw EDIDError.todoErrorNotLocalized
        case 0x00:
            self = .weekAndYearOfManufacture(week: nil, year: year)
        case 0xff:
            self = .modelYear(year)
        case let week:
            self = .weekAndYearOfManufacture(week: week, year: year)

        }
    }
    
    public func encode(to encoder: BinaryEncoder) throws {
        var container = encoder.container()
        let year: UInt16
        let weekRawValue: UInt8
        
        switch self {
        case .weekAndYearOfManufacture(let weekOfManufacutre, let yearOfManufacture):
            weekRawValue = weekOfManufacutre ?? 0x00
            year = yearOfManufacture
        case .modelYear(let modelYear):
            weekRawValue = 0xff
            year = modelYear
        }
        
        let yearRawValue = UInt8(year - 1990)
        try container.encode(weekRawValue)
        try container.encode(yearRawValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case weekAndYearOfManufacture = "Week and Year of Manufacture"
        case modelYear = "Model Year"
    }
    
    enum weekAndYearOfManufactureKeys: String, CodingKey {
        case week = "Week of Manufacture"
        case year = "Year of Manufacture"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .weekAndYearOfManufacture(let weekOfManufacture, let yearOfManufacture):
            var weekAndYearOfManufacture = container.nestedContainer(keyedBy: weekAndYearOfManufactureKeys.self, forKey: .weekAndYearOfManufacture)
            try weekAndYearOfManufacture.encode(weekOfManufacture, forKey: .week)
            try weekAndYearOfManufacture.encode(yearOfManufacture, forKey: .year)
        case .modelYear(let modelYear):
            try container.encode(modelYear, forKey: .modelYear)
        }
        
    }
}

struct EDIDStructureVersionAndRevision: BinaryCodable, Equatable, CustomStringConvertible {
    public let version: UInt8
    public let revision: UInt8
    
    public var description: String { "\(version).\(revision)" }
    
    public init(_ version: UInt8, _ revision: UInt8) {
        self.version = version
        self.revision = revision
    }
    
    public init(from decoder: BinaryDecoder) throws {
        var container = decoder.container(maxLength: 2)
        version = try container.decode(UInt8.self)
        revision = try container.decode(UInt8.self)
    }
    
    public func encode(to encoder: BinaryEncoder) throws {
        var container = encoder.container()
        try container.encode(version)
        try container.encode(revision)
    }
}
