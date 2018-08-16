# 7월 2일 Lab 

L = [['A', 'B', 'C', 'D', 'E'], ['F', 'G', 'H', 'I', 'J'], ['K', 'L', 'M', 'N', 'O']]

"""
for i in range(len(L)) :
    for j in range(len(L[i])) :
        L[i][j] = L[i][j].lower()
        if j != 4 :
            print(L[i][j], end = ' ')
        else :
            print(L[i][j])
"""


for row in L :
    for column in row :
        print(column.lower(), end = ' ')
    print('\n')



# print('\n') 얘는 2줄 띄어쓰기  print() 얘는 한줄 띄어쓰기


print('\n\n')


for i in range(2, 10) :
    for j in range(1, 10) :
        if j == 9 :
            print(i * j)
        else :
            print(i * j, end = ' ')



for i in range(2, 10) :
    for j in range(1, 10) :
        print(i * j, end = ' ')
    print()


            
print('\n\n')

"""
for i in range(2000, 3001) :
    if i % 4 == 0 :
        if i % 100 == 0 :
            if i % 400 == 0 :
                print(i, end = ' ')
        else :
            print(i, end = ' ')
"""

leaps = []
for year in range(2000, 3001) :
    if year % 4 == 0 and year % 100 != 0 or year % 400 == 0 :
        leaps.append(year)
print(leaps)


leaps = [year for year in range(2000, 3001)
         if year % 4 == 0 and year % 100 != 0 or year % 400 == 0]
print(leaps)




print('\n\n')


income = {'David' : 30000, 'John' : 50000, 'Andrew' : 45000, 'Rita' : 70000, 'Michael' : 10000}


for i in income :
    if income[i] >= 50000 :
        print("{}'s salary is {:,}".format(i, income[i]))


salary = {'David' : 30000, 'John' : 50000, 'Andrew' : 45000, 'Rita' : 70000, 'Michael' : 10000}

for key in salary.keys() :
    if salary[key] >= 50000 :
        print("{}'s salary is {:,}".format(key, salary[key]))



        



L = ['사과', '딸기', '바나나', '블루베리', '포도']

fruit = input('과일입력...: ')

for fruits in range(len(L)) :
    if fruit == L[fruits] :
        print('과일 목록의 {}번째에 존재합니다.'.format(fruits + 1))
        break
else :
    print('과일 목록에 존재하지 않습니다.')





target = input('과일입력...: ')

for index, fruit in enumerate(fruits, 1) :
    if fruit == target :
        print('{}'.format())
else :
    print('없음')










































              
