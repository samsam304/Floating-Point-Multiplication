Overview

This project demonstrates manual floating-point multiplication in RISC-V assembly. Specifically, it multiplies two single-precision IEEE-754 floating-point numbers, handling the intricacies of sign bits, exponents, and mantissas explicitly within the assembly code. It does not rely on hardware floating-point instructions, showcasing a detailed implementation suitable for educational and illustrative purposes.


The steps include:

Loading Numbers:
Numbers are loaded into registers by splitting the hexadecimal values.

Determining Sign:
The sign bit of the resulting product is calculated using an XOR operation on the sign bits of the two input numbers.

Exponent Calculation:
The exponents are extracted, biased adjusted (-127), summed, and then biased back (+127).

Mantissa Multiplication:
The mantissas, including the implicit leading bit (1), are multiplied, resulting in a 48-bit product, which is then appropriately shifted and truncated to fit the IEEE-754 mantissa format.

Normalization:
If necessary, normalization of the mantissa is performed to ensure the correct representation.

Final Assembly:
Sign, exponent, and mantissa are combined into a final 32-bit IEEE-754 formatted number.

Result Display:
The result is printed using a syscall for visibility.


Educational Purpose

This implementation is ideal for understanding:

IEEE-754 floating-point representation

Bit manipulation and masking

Assembly-level arithmetic

Requirements

RISC-V Simulator (e.g., Venus)
