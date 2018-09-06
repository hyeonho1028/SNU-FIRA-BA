
L = [1, 7, [4, 9], 'f', ('a', 'b')]

L.append('g')

L2 = L[-2:]
print(L)
print(L2)
print("\n\n")



atuple = (1, 5, (2, 3), 'green', ['드럼', '기타'])
btuple = atuple[-2:]

print((2, 3) in atuple)
print(5 in btuple)
print("\n\n")

set1 = {2,4,5,7}
set2 = {1,2,7,9}

print(set1 | set2)
print(set1 & set2)
print(set1.union(set2))
print(set1.intersection(set2))
print("\n\n")



d = {'even' : (2, 4, 6, 8, 10),'odd' : (1, 3, 5, 7, 9), 'prime' : (2, 3, 5, 7)}
print(d)
d['all'] = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
print(d)
del d['odd']
print(d)
