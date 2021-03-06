// Copyright 2016 The Vanadium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import Foundation

/// Principal gets the default app/user blessings from the default blessings store. These methods
/// are mainly for internal use only (for encoding Identifier), or advanced users only.
public enum Principal {
  /// Returns the app blessing from the main context. This is used for encoding database ids.
  /// If no app blessing has been set, this throws an exception.
  public static func appBlessing() throws -> String {
    let cStr: v23_syncbase_String = try VError.maybeThrow { errPtr in
      var cStr = v23_syncbase_String()
      v23_syncbase_AppBlessingFromContext(&cStr, errPtr)
      return cStr
    }
    guard let str = cStr.extract() else {
      throw SyncbaseError.NotAuthorized
    }
    return str
  }

  /// Returns the user blessing from the main context. This is used for encoding collection ids.
  /// If no user blessing has been set, this throws an exception.
  public static func userBlessing() throws -> String {
    let cStr: v23_syncbase_String = try VError.maybeThrow { errPtr in
      var cStr = v23_syncbase_String()
      v23_syncbase_UserBlessingFromContext(&cStr, errPtr)
      return cStr
    }
    guard let str = cStr.extract() else {
      throw SyncbaseError.NotAuthorized
    }
    return str
  }

  /// Returns a debug string that contains the current blessing store. For debug use only.
  static var blessingsDebugDescription: String {
    var cStr = v23_syncbase_String()
    v23_syncbase_BlessingStoreDebugString(&cStr)
    return cStr.extract() ?? "ERROR"
  }
}
