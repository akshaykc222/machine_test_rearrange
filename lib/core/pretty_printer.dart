import 'package:flutter/material.dart';

prettyPrint(String? msg, {String? type}) {
  debugPrint(" [REARRANGE] ==  [${type ?? PrettyPrinterTypes.debug}] => $msg ");
}

// class PrettyPrint {
//   static d(String? msg) {
//     developer.log('\x1B[34m$msg\x1B[0m');
//   }
//
//   static e(String? msg) {
//     developer.log("\x1B[31m${msg ?? "null"}\x1B[0m");
//   }
//
//   static w(String? msg) {
//     developer.log("\x1B[33m${msg ?? "null"}\x1B[0m");
//   }
// }

class PrettyPrinterTypes {
  static const error = "ERROR";
  static const debug = "DEBUG";
  static const warning = "WARNING";
}
