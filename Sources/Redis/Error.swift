import Debugging

public struct RedisError: Debuggable, Traceable, Swift.Error, Encodable {
    /// rrors
    enum ClientError {
        /// Parsing the Value's token failed because the value's identifying token is unknown
        case invalidTypeToken
        
        /// Parsing the redis response failed. The protocol communication was invalid
        case parsingError
        
        /// The command's result was unexpected
        case unexpectedResult(RedisData)
        
        /// A server-side error
        case serverSide(String)
    }
    
    /// This error's kind
    internal let kind: ClientError
    
    /// See Debuggable.Reason
    public var reason: String {
        switch kind {
        case .invalidTypeToken:
            return "When parsing the result data, a unknown type was found in the response."
        case .parsingError:
            return "The server response was unsuccessfully parsed"
        case .unexpectedResult(let result):
            return "The server response was successfully parsed but did not match driver expectations. The result was: \(result)"
        case .serverSide(let reason):
            return reason
        }
    }
    
    /// See Identifiable.identifier
    public var identifier: String {
        switch kind {
        case .invalidTypeToken:
            return "invalidTypeToken"
        case .parsingError:
            return "responseParsingError"
        case .unexpectedResult(let result):
            return "Unexpected result: (\(result))"
        case .serverSide(let reason):
            return "Server error: \(reason)"
        }
    }
    
    
    /// See Traceable.file
    public let file: String
    
    /// See Traceable.function
    public let function: String
    
    /// See Traceable.line
    public let line: UInt
    
    /// See Traceable.coumn
    public let column: UInt
    
    /// See Traceable.stackTrace
    public let stackTrace: [String]
    
    /// Create a new FileError
    internal init(_ kind: ClientError, file: String = #file, function: String = #function, line: UInt = #line, column: UInt = #column) {
        self.kind = kind
        self.file = file
        self.function = function
        self.line = line
        self.column = column
        self.stackTrace = RedisError.makeStackTrace()
    }
}
