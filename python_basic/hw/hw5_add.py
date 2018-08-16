# Assignment Number...: 5_add
# Student Name........: 이현호
# File Name...........: hw5_add_이현호
# Program Description.: try except를 이용한 예외처리 문을 활용하는 과제입니다.

while True :                                                        # 무한루프입니다.
    try :                                                           # try:문을 통해 예외처리를 시작합니다.
        i = int(input('임의의 양의 정수를 입력하세요: '))           # i변수에 input()함수를 통해 양의 정수를 입력 받고, 정수형으로 변환한 후 할당합니다.
        if type(i) == int and 1 < i :                               # if:조건문을 통해 i변수의 type이 정수형이고, 1보다 크다면, for:순환문을 실행합니다.
            for j in range(2, i) :                                  # for:순환문은 range()함수를 통해 2부터 i전까지 j변수에 할당됩니다.
                if i % j == 0 :                                     # for:순환문 내부에서 if:조건문을 통해 i변수를 j변수로 나눴을 때의 몫이 0이면,
                    print('{} x {} = {}'.format(j, int(i/j), i))    # print()함수와 format()함수를 통해 j, 정수형으로 변환한 i/j, i가 출력됩니다.
                    print('이 숫자는 소수가 아닙니다.')             # print()함수를 통해 소수가 아니라는 문자열을 출력합니다.
                    break                                           # break를 통해 if:조건문을 정지합니다.
            else :                                                  # for:순환문이 정상적으로 종료된다면,
                print('이 숫자는 소수입니다.')                      # print()함수를 통해 소수라는 문자열을 출력합니다.
            break                                                   # break를 통해 for:순환문을 정지합니다.
        elif i == 1 :                                               # elif:조건문을 통해 i변수가 1이라면,
            print('ValueError : 1보다 큰 양의 정수를 입력하세요.')  # print()함수를 통해 1보다 큰 양의 정수를 입력하라는 문자열을 출력합니다.
        else :                                                      # 마지막으로 else:문은 if:, elif: 조건문이 아닐 때 실행됩니다.
            raise ValueError                                        # 사용자 지정 에러인 raise를 사용하여 ValueError을 발생시킵니다.
    except ValueError :                                             # except를 사용하여 ValueError이 일어나면, 
        print('ValueError : 임의의 양의 정수를 입력하세요.')        # print()함수를 사용하여 임의의 양의 정수를 입력하라는 문자열을 출력합니다.
        





while True:
    try:
        i = int(input('임의의 양의 정수를 입력하세요:  '))   # 3.0은 에러나네..
        if not isinstance(i, int) or i < 2:                  #i 가 int 자료형인지 T/F반환하는 함수
            raise ValueError
    except ValueError:
        print('ValueError: 1보다 큰 양의 정수를 입력하세요.')
        continue
    else:
        break

#소수 확인 절차
#전달인자의 값을 2부터 n-1까지의 숫자로 나누어, 나머지가 0인 숫자가 있으면 소수가 아니다.
for n in range(2, i - 1):
    if i % n == 0: #1과 자신 외에 나누어 떨어지는 수가 존재하면 소수가 아니다.
        print('{0} x {1} = {2}'.format(n, i // n, i))
        print('이 숫자는 소수가 아닙니다.')
        break
else: #1과 자신 이외에 제수가 없는 경우
    print('이 숫자는 소수 입니다.')
