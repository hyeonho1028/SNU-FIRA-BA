"""
a = 10
a = a/2
c = a**3
print(a + c)

b = 10.0
d = b * 3 - 10

print(d % 4)


str1 = 'I'
str2 = 'love'
str3 = 'Python'

str4 = str1 + ' ' +str2 + ' ' + str3

print(str4)

str4 = str4[:6]

str5 = str4 + ' ' + 'programming'

print(str5)


meal_tax = 137.50 * 0.08875
tip = (meal_tax + 137.50) * 0.15
total = 137.50 + meal_tax + tip

print(round(total, ndigits = 2))
print('{}'.format(round(total, 2)))

"""

sku = [gender + size + color
       for gender in 'FM'
       for size in 'SMLX' if not(gender == 'F' and size == 'X')
       for color in 'WGRB']
print(sku)



sku = [gender + size + color
       for gender in 'FM'
       for size in 'SMLX' 
       for color in 'WGRB' if not(gender == 'F' and size == 'X')]
print(sku)































