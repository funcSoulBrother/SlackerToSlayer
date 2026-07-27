//
//  RomanNumeralExtension.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 7/24/26.
//

extension Int {

    var romanNumeral: String {
        guard self > 0 else { return "" }

        let values = [
            1000, 900, 500, 400,
            100, 90, 50, 40,
            10, 9, 5, 4,
            1
        ]

        let numerals = [
            "M", "CM", "D", "CD",
            "C", "XC", "L", "XL",
            "X", "IX", "V", "IV",
            "I"
        ]

        var number = self
        var result = ""

        for (value, numeral) in zip(values, numerals) {
            while number >= value {
                result += numeral
                number -= value
            }
        }

        return result
    }

}
