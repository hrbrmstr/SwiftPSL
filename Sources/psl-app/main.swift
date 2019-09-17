//
//  main.swift
//  psl-app
//
//  Created by hrbrmstr on 9/15/19.
//

import Foundation
import SwiftPSL

var psl : SwiftPSL?

psl = SwiftPSL()

print("Using", psl!.builtinFilename())
print("Suffix Count", psl!.suffixCount())
print("TS", psl!.builtinTimestamp())

let arguments: [String] = CommandLine.arguments
if (arguments.count > 1) { print(psl!.apexDomain(arguments[1]) ?? arguments[1]) }

psl = nil
