# BigFactorial

This program was made in assembler x64 and can calculate the factorial up to 40000


## Algorithm
```
multiply(a[1..p], b[1..q], base)                            // Operands containing rightmost digits at index 1
  product = [1..p+q]                                        // Allocate space for result
  for b_i = 1 to q                                          // for all digits in b
    carry = 0
    for a_i = 1 to p                                        // for all digits in a
      product[a_i + b_i - 1] += carry + a[a_i] * b[b_i]
      carry = product[a_i + b_i - 1] / base
      product[a_i + b_i - 1] = product[a_i + b_i - 1] mod base
    product[b_i + p] = carry                               // last digit comes from final carry
  return product
```
