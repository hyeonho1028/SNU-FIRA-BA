'''
Coding Style
   - redundancy :
   - minor error :
   - major error :
Poor Documentation :
Logical Error :
Compilation Error :
Score : 100/100
TA's comment :
'''


# Assignment Number...: 5
# Student Name........: 이현호
# File Name...........: hw5_이현호
# Program Description.: if-else문과 for, while문을 활용하는 과제입니다.

a = int(input('Enter a: '))                      # input()함수를 통해 입력받고, int()함수를 통해 정수형으로 변환하여 변수 a에 할당합니다.
b = int(input('Enter b: '))                      # input()함수를 통해 입력받고, int()함수를 통해 정수형으로 변환하여 변수 b에 할당합니다.
c = int(input('Enter c: '))                      # input()함수를 통해 입력받고, int()함수를 통해 정수형으로 변환하여 변수 c에 할당합니다.


if a > b and a > c :                             # if:조건문을 통해 a가 b보다 크고, a가 c보다 크면(2개의 조건만족을 and를 통해 실행합니다.), 
    print(b + c)                                 # print()함수를 통해 b + c를 출력합니다.
if b > a and b > c :                             # if:조건문을 통해 b가 a보다 크고, b가 c보다 크면(2개의 조건만족을 and를 통해 실행합니다.),
    print(a + c)                                 # print()함수를 통해 a + c를 출력합니다.
if c > a and c > b :                             # if:조건문을 통해 c가 a보다 크고, c가 b보다 크면(2개의 조건만족을 and를 통해 실행합니다.),
    print(a + b)                                 # print()함수를 통해 a + b를 출력합니다.
                                                 # a와 b와 c가 같을 때의 조건문이 없으므로 같으면 아무 일이 일어나지 않습니다.

city = input('Enter the name of the city: ')     # city변수에 사용자가 입력하는 city를 할당합니다.

if city == 'Seoul' :                             # if:조건문을 통해 city변수가 'Seoul'이면,
    size = 605                                   # size변수에 605를 할당합니다.
elif city == 'New York' :                        # elif:조건문을 통해 city변수가 'New York'이면,
    size = 789                                   # size변수에 789를 할당합니다.
elif city == 'Beijing' :                         # elif:조건문을 통해 city변수가 'Beijing'이면,
    size = 16808                                 # size변수에 16808를 할당합니다.
else :                                           # 마지막으로 else :문은 위의 3개의 if문에 해당하지 않는다면,
    size = 'Unknown'                             # size변수에 'Unknown'을 할당합니다.

print('The size of {} is {}'.format(city, size)) # print()함수와 format을 사용하여 city와 size를 출력합니다.



import math                                      # math 라이브러리를 불러옵니다.

for i in range(10) :                             # for:순환문을 range()함수를 사용하여 0:9의 값을 i변수에 순차적으로 할당됩니다.
    print(math.factorial(i))                     # print()함수를 사용하여 math.factorial()함수를 출력합니다.
                                                 # math.factorial(i)함수는 0부터 i값까지의 계승 값입니다. math.factorial(0)인 경우 1입니다.

i = 0                                            # while을 사용하기 위해 반복횟수인 i = 0을 할당합니다.
while i < 10 :                                   # i = 0 부터 10 미만이 되기까지 while문을 반복합니다.
    print(math.factorial(i))                     # print()함수를 사용하여 math.factorial()함수를 출력합니다.
    i += 1                                       # i변수를 한 단위씩 증가하게 하기 위하여 반복 매 횟수마다 i변수에 +1을 합니다.
                                                 # 마찬가지로 math.factorial()함수는 0부터 i값까지의 계층 값입니다.
