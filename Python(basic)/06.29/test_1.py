"""
count = 0


print('{} file{}'.format((count if count != 0 else 'No'),
                         ('s' if count != 1 else '')))

print(\n\n)
"""


# <제어문 다루기>
"""
x = input('x를 입력하세요: ')
y = input('y를 입력하세요: ')

if x > y :
    print('x가 y보다 큽니다')
elif x == y :
    print('x와 y가 같습니다')
else :
    print('x가 y보다 작습니다')
"""

"""

x = int(input('x를 입력하세요: '))
y = int(input('y를 입력하세요: '))
if x % y == 0 :
    print('zero')
else :
    if x % 2 == 0 :
        print('even')
    else :
        print('odd')

"""


"""
t = (1, 3, 5, 6, 'a', 'b', 'c')

if 5 in t :
    print('5 is in t')
elif 'd' in t :
    print('d is in t')


"""

"""
integers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
i = 0
while i < len(integers) :
    if integers[i] % 2 == 1 :
        print(integers[i])
    i += 1
"""

"""
colors = ['red', 'blue', 'pink', 'green', 'yellow', 'purple']
i = 0

while i < len(colors) :
    if colors[i][0] =='p' :
        print(colors[i])
    i += 1
"""

"""
### pythonic way
colors = ['red', 'blue', 'pink', 'green', 'yellow', 'purple']
i = 0

while i < len(colors) :
    if colors[i].startswith('p') :
        # startswith()와 endwith() 를 사용해라.
        print(colors[i])
    i += 1




s = 'apple'
print(s.startswith('a'))
print(s.endswith('e'))

"""

"""
fruits = ['사과', '딸기', '바나나', '블루베리', '포도']

i = 0

while i < 2 :
    fruit = input('과일 이름을 입력하세요...: ')
    j = 0
    if fruit in fruits :        
        while j < len(fruits) :
            if fruit == fruits[j] : 
                print('과일목록의 {}번째에 존재합니다.'.format(j+1))
                break
            else :
                 j += 1
                
    else :
       print('과일목록이 존재하지 않습니다.')
    i += 1

"""    

"""
fruits = ['사과', '딸기', '바나나', '블루베리', '포도']
target = input('과일 이름을 입력하세요...: ')
index = 0
while index < len(fruits) :
    if fruits[index] == target:
        print('과일목록의 {}번째에 존재합니다.'.format(index+1))
        break
    index += 1
else :
    print('과일 목록에 존재하지 않습니다.')
"""



"""
while True :
    answer = input('입력하셍요: ')
    if not answer :
        break
    print(answer)
    continue
"""


integers = list(range(1, 11))
print(integers)

for integer in integers :
    if integer % 2 == 1 :
        print(integer)




colors = ['red', 'blue', 'pink', 'green', 'yellow', 'purple']

for color in colors :
v        print(color)


colors = ['red', 'blue', 'pink', 'green', 'yellow', 'purple']

for color in colors :
    if color.startswith('p') :
        print(color)


