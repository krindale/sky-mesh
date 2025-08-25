/// Logger utility for production-safe logging
/// 
/// Provides structured logging with different levels and conditional output
/// based on build mode (debug vs release).
class Logger {
  static const bool _isDebug = true; // In production, this would be false
  
  /// Log debug information (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (_isDebug) {
      print('🔍 [DEBUG${tag != null ? ' - $tag' : ''}] $message');
    }
  }
  
  /// Log informational messages
  static void info(String message, [String? tag]) {
    if (_isDebug) {
      print('ℹ️ [INFO${tag != null ? ' - $tag' : ''}] $message');
    }
  }
  
  /// Log warnings (always shown)
  static void warning(String message, [String? tag]) {
    print('⚠️ [WARNING${tag != null ? ' - $tag' : ''}] $message');
  }
  
  /// Log errors (always shown)
  static void error(String message, [String? tag]) {
    print('❌ [ERROR${tag != null ? ' - $tag' : ''}] $message');
  }
  
  /// API-specific logging
  static void api(String message) {
    debug(message, 'API');
  }
  
  /// Location service logging
  static void location(String message) {
    debug(message, 'LOCATION');
  }
  
  /// Weather service logging
  static void weather(String message) {
    debug(message, 'WEATHER');
  }
  
  /// Image service logging
  static void image(String message) {
    debug(message, 'IMAGE');
  }
}