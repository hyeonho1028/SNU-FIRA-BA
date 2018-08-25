# Assignment Number... : 8
# Student Name........ : 이현호
# File Name........... : hw8_이현호
# Program Description. : 함수를 정의하고 활용하는 법을 익히고, 패키지와 모듈을 불러오는 법을 익히는 과제입니다.

import datetime                             # datetime 모듈을 불러옵니다.

now = datetime.datetime.now()               # datetime모듈안에 있는 now()함수를 이용해 now라는 변수에 현재시간을 할당합니다.

print(now.strftime('%y-%m-%d-%H:%M:%S'))    # strftime()함수를 이용해 시간표현형식에 맞춰 출력합니다.


import calendar                             # calendar 모듈을 불러옵니다.
print(calendar.isleap(2050))                # isleap()함수를 이용해 2050년이 윤년인지에 대한 여부를 출력합니다.
print(calendar.weekday(2050,7,7))           # weekday()함수를 이용ㅎ 2050년 7월 7일이 무슨 요일인지 출력해봅니다.(0=월, 6=일[요일임])

 

from collections import Counter
                                            # collections모듈의 Counter 함수를 불러옵니다.
def vowel(n):                               # vowel이라는 함수를 정의합니다.(n이라는 매개변수를 받습니다.
    counts = Counter(n)                     # Counter함수를 사용하고 그 결과를 counts변수에 할당합니다.
    m = list()                              # m변수를 list로 할당합니다.
    for j in ['a','e','i','o','u']:         # for순환문을 a, e, i, o, u로 순환시키고 각 i가 counts에 있는지에 대한 여부를 if조건문을 사용합니다.
        if j in counts:
            print('The number of {}: {}'.format(j, counts.get(j)))
            m.append(counts.get(j))
        else:                                        # 있다면, print함수를 사용하여 각 j와 j의 개수를 get을 사용하여 출력합니다. 또한 append를 사용하여 각 모음의 개수를 m리스트에 추가합니다.
            print('The number of {}: 0'.format(j))   # 없다면, print함수를 사용하여 각 j와 j의 개수인 0을 출력합니다. 
    else:
        m = max(m)                                   
        for j in ['a','e','i','o','u']:
            if counts.get(j) == m:
                max_index = j               # for문이 정상적으로 종료되면 최대값을 구하기 위하여 m의 최대값을 m에 재할당하고, m의 개수를 가지고 있는 모음을 max_index에 할당합니다.
        
    for j in n:
        if j == max_index:
            print(j.upper(), end = "")
        else:
            print(j, end = "")              # for 순환문과 if조건문을 사용하여 사용자가 입력한 n중 j가 max_index와 같다면 upper를 사용하여 대문자로, 아니면 그대로 출력합니다.

vowel('The regret after not doing something is bigger than that of doing something') 
