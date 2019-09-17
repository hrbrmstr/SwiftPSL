import psl

enum SwiftPSLError : Error {
  case FileNotFound
  case Invalidarg
  case Converter
  case ToUTF16
  case ToLower
  case ToUTF8
  case NoMem
}

public final class SwiftPSL {
  
  public let pslVersion = PSL_VERSION
  public let pslVersionMajor = PSL_VERSION_MAJOR
  public let pslVersionMinor = PSL_VERSION_MINOR
  public let pslVersionPatch = PSL_VERSION_PATCH

  public struct pslType {
    static let ICANN : Int32 = PSL_TYPE_ICANN
    static let NoStarRule : Int32  = PSL_TYPE_NO_STAR_RULE
    static let ANY : Int32 = PSL_TYPE_ANY
    static let Private : Int32 = PSL_TYPE_PRIVATE
  }

  private var ctx : OpaquePointer? = psl_builtin()
  private var isBuiltin = true
  
//  psl_error_t value. PSL_SUCCESS: Success PSL_ERR_INVALID_ARG: str is a NULL value. PSL_ERR_CONVERTER: Failed to open the unicode converter with name encoding PSL_ERR_TO_UTF16: Failed to convert str to unicode PSL_ERR_TO_LOWER: Failed to convert unicode to lowercase PSL_ERR_TO_UTF8: Failed to convert unicode to UTF-8 PSL_ERR_NO_MEM: Failed to allocate memory
  
  public func strToUTF8Lower(_ str : String, encoding : String = "utf-8", locale : String = "en") throws -> String? {
    
    var lower : UnsafeMutablePointer<Int8>?
    
    let ret = psl_str_to_utf8lower(str, encoding, locale, &lower)
    
    var dom : String? = nil
    
    switch ret {
      case PSL_ERR_INVALID_ARG: throw SwiftPSLError.Invalidarg
      case PSL_ERR_CONVERTER: throw SwiftPSLError.Converter
      case PSL_ERR_TO_UTF16: throw SwiftPSLError.ToUTF16
      case PSL_ERR_TO_LOWER: throw SwiftPSLError.ToLower
      case PSL_ERR_TO_UTF8: throw SwiftPSLError.ToUTF8
      case PSL_ERR_NO_MEM: throw SwiftPSLError.NoMem
      default: dom = String(cString: lower!)
    }
    
    psl_free_string(lower)
    
    return(dom)
    
  }

  public func publicSuffix(_ domain : String, encoding : String = "utf-8", locale : String = "en") -> String? {
    let psl : OpaquePointer? = ctx
    var lower : UnsafeMutablePointer<Int8>?
    let dom : String? = (psl_str_to_utf8lower(domain, encoding, locale, &lower) == PSL_SUCCESS) ? String(cString: psl_unregistrable_domain(psl, lower)) : nil
    psl_free_string(lower)
    return(dom)

  }

  public func apexDomain(_ domain : String, encoding : String = "utf-8", locale : String = "en") -> String? {
    let psl : OpaquePointer? = ctx
    var lower : UnsafeMutablePointer<Int8>?
    let dom : String? = (psl_str_to_utf8lower(domain, encoding, locale, &lower) == PSL_SUCCESS) ? String(cString: psl_registrable_domain(psl, lower)) : nil
    psl_free_string(lower)
    return(dom)
  }

  public func isPublicSuffix(_ domain : String, encoding : String = "utf-8", locale : String = "en") -> Bool {
    let psl : OpaquePointer? = ctx
    var lower : UnsafeMutablePointer<Int8>?
    let res : Bool = (psl_str_to_utf8lower(domain, encoding, locale, &lower) == PSL_SUCCESS) && (psl_is_public_suffix(psl, lower) == 1)
    psl_free_string(lower)
    return(res)
  }

  public func isPublicSuffix(_ domain : String, type : Int32,  encoding : String = "utf-8", locale : String = "en") -> Bool {
    let psl : OpaquePointer? = ctx
    var lower : UnsafeMutablePointer<Int8>?
    let res : Bool = (psl_str_to_utf8lower(domain, encoding, locale, &lower) == PSL_SUCCESS) && (psl_is_public_suffix2(psl, lower, type) == 1)
    psl_free_string(lower)
    return(res)
  }

  public func isCookieDomainAcceptable(_ hostname : String, cookieDomain : String) -> Bool {

    let psl : OpaquePointer? = ctx
    var lower1 : UnsafeMutablePointer<Int8>?
    var lower2 : UnsafeMutablePointer<Int8>?

    let rc1 = psl_str_to_utf8lower(hostname, "utf-8", "en", &lower1)
    let rc2 = psl_str_to_utf8lower(cookieDomain, "utf-8", "en", &lower2)

    let res : Bool = (rc1 == PSL_SUCCESS) && (rc2 == PSL_SUCCESS) && (psl_is_cookie_domain_acceptable(psl, lower1, lower2) == 1)
    
    psl_free_string(lower1)
    psl_free_string(lower2)

    return(res)

  }
  
  public init() {}
  
  public init(_ path: String) throws {
    ctx = psl_load_file(path)
    if (ctx == nil) { throw SwiftPSLError.FileNotFound }
    isBuiltin = false
  }
  
  public func free() {
    if ((!isBuiltin) && (ctx != nil)) {
      psl_free(ctx)
      ctx = nil
    }
  }
  
  public func suffixCount() -> Int32 {
    return(psl_suffix_count(ctx))
  }
  
  public func suffixWildcardCount() -> Int32 {
    return(psl_suffix_wildcard_count(ctx))
  }
  
  public func suffixExceptionCount() -> Int32 {
    return(psl_suffix_exception_count(ctx))
  }

  public func builtinDistFilename() -> String {
    return(String(cString: psl_dist_filename()))
  }

  public func builtinFilename() -> String {
    return(String(cString: psl_builtin_filename()))
  }

  public func builtinSHA1() -> String {
    return(String(cString: psl_builtin_sha1sum()))
  }

  public func isBuiltinOutdated() -> Bool {
    return(psl_builtin_outdated() == 1)
  }

  public func builtinTimestamp() -> Int {
    let ft = psl_builtin_file_time()
    return(ft)
  }
  
  deinit {
    free()
  }
  
}
