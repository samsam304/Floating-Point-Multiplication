.globl main

.equ NUM_1, 0xC0F00000  # -7.5
.equ NUM_2, 0x41040000  # 8.25

# %hi() and %lo() operations are not supported in
# the Venus simulator, but the values are still
# displayed in .equ for clarity 

.text
main:
# Load the numbers
lui t0, 0xC0F00     # Load upper 20 bits of NUM_1
ori t0, t0, 0x000   # Load lower 12 bits of NUM_1
lui t1, 0x41040     # Load upper 20 bits of NUM_2
ori t1, t1, 000     # Load lower 12 bits of NUM_2

# Get the sign bits and compute result with XOR
srli t2, t0, 31
srli t3, t1, 31
xor t4, t2, t3      # t4 = sign bit of result 

# Get exponents and compute result with addition 
srli t2, t0, 23     # Shift to isolate exponent 
andi t2, t2, 0xFF   # Mask for exponet (8 bits)
srli t3, t1, 23 
andi t3, t3, 0xFF
addi t2, t2, -127   # Remove bias from exponents
addi t3, t3, -127
add t5, t2, t3      # Add exponents without bias
addi t5, t5, 127    # t5 = new exponent (with bias)

# Get mantissas and add leading 1
li t2, 0x007FFFFF   # Mask for the 23-bit mantissa
li s0, 0x00800000
and t6, t0, t2      # Get mantissa from first number
or t6, t6, s0       # Add implicit 1 
and t3, t1, t2      # Get mantissa from second number
or t3, t3, s0       # Add implicit 1 

# Multiply mantissas (t6 * t3) and shift 
mul s3, t6, t3      # Lower 32 bits of operation
mulh s4, t6, t3     # Upper 32 bits of operation
slli s4, s4, 9      # Shift upper 32 bits left by 9
srli s3, s3, 23     # Shift lower 32 bits right by 23
or s3, s3, s4       # Combine into single mantissa

li t0, 0x01000000   # Load mask for bit 24 (1 << 24)
and t1, s3, t0      # Check if bit 24 is set in s3
beq t1, x0, skip    # If bit 24 not set, jump
srli s3, s3, 1      # Shift the mantissa right by 1
addi t5, t5, 1      # Increment the exponent since we've divided by 2
skip:
and s3, s3, t2      # s3 now holds the final 23-bit mantissa

# Reassemble number in standard format
slli t4, t4, 31     # Place the sign bit in bit 31
slli t5, t5, 23     # Place the exponent in bits 30-23
and s3, s3, t2      # Mask the mantissa to 23 bits 
or t5, t5, s3       # Combine exponent and mantissa, then the sign bit
or t5, t5, t4       # Store result in t5

# Print the result
mv a1, t5          # Move result to a1 for printing
li a0, 34           # syscall for print integer

# Exit
li a7, 10    # syscall for exit
ecall