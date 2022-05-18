import Foundation

enum ExternalDisplayDataServiceError: String, LocalizedError {
    var errorDescription: String? { self.rawValue }

    case todoErrorNotLocalized = "TODO: localize error"
}

public struct ExternalDisplayDataService {
    static let ddcI2CChipAddress = UInt32(0x37)
    static let ddcI2CDataAddress = UInt32(0x51)
    
    var service: IOAVService
    
    public init?() {
        guard let service = IOAVServiceCreate(kCFAllocatorDefault) else {
            return nil
        }
        
        self.service = service.takeRetainedValue()
    }
    
    public func edid() -> Data? {
        var cfData: Unmanaged<CFData>?
        IOAVServiceCopyEDID(service, &cfData)
        return cfData?.takeRetainedValue() as? NSData as? Data
    }
    
    /*
    func writeDDC(data: Data) throws {
        try data.withUnsafeBytes {
            guard case 0 = IOAVServiceWriteI2C(
                service,
                ExternalDisplayDataService.ddcI2CChipAddress,
                ExternalDisplayDataService.ddcI2CDataAddress,
                UnsafeMutableRawPointer(mutating: $0.baseAddress),
                UInt32(data.count)
            ) else {
                throw ExternalDisplayDataServiceError.todoErrorNotLocalized
            }
        }
    }
    
    func readDDC() throws -> Data {
        let data = Data(repeating: 0, count: 256)
        
        try data.withUnsafeBytes {
            guard case 0 = IOAVServiceReadI2C(
                service,
                ExternalDisplayDataService.ddcI2CChipAddress,
                ExternalDisplayDataService.ddcI2CDataAddress,
                UnsafeMutableRawPointer(mutating: $0.baseAddress),
                UInt32(data.count)
            ) else {
                throw ExternalDisplayDataServiceError.todoErrorNotLocalized
            }
        }
       
        return data
    }
     */
}
