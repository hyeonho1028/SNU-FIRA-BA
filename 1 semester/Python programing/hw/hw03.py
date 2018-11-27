# Assignment Number...: 3
# Student Name........: 이현호
# File Name...........: hw3_이현호
# Program Description.: 문자열 서식을 활용하고, 리스트(lists)와 튜플(tuples)을 생성하여 슬라이싱하여 출력하는 과제입니다.

print('스테이크의 원래 가격은 {} 원입니다. 하지만 VAT 가 {}%로, 계산하셔야 할\n가격은 {} 원입니다.'.format(30000, 15, int(30000*1.15)))
                                                                         # format()함수와 print()함수를 사용하여 출력하였다. format()함수의 경우
                                                                         # {}.format() 형식을 맞추었고, 새줄바꿈을 위해 \n을 사용하였다. 또한 계산할 가격이
                                                                         # 실수형이므로 int()함수를 이용하여 정수형으로 변경하였다.

s = '@^TrEat EvEryonE yOu meet likE you want tO be treated.$%'           # s 변수에 문자열을 할당하였다.
s = s[:3] + s[3:].lower()                                                # s를 슬라이싱하여 s 변수에 할당된 'T' 뒤의 문자들을 모두 소문자로 변경하는 함수인
                                                                         # lower()함수를 사용하였고, lower()함수를 사용하지 않은 s[:3]과 합친 뒤 s에 재 할당 하였다.
s = s.strip('@^$%')                                                      # s 변수에 양 끝에 있는 특수문자를 제거하기 위해 strip()사용하였고,
                                                                         # 이 함수는 strip()의 괄호 안에있는 문자를 양끝쪽에서 부터 제거하며, 없을시 중단하고
                                                                         # s 변수에 재 할당하였다.
print(s)                                                                 # s 변수를 출력하기 위해 print()함수를 사용하였다.

numbers = (2, 18, 26, 89, 45, 39, 14)                                    # numbers 변수에 튜플을 할당하기 위해 () 를 이용하였고, 그 내부에 원소를 넣어 할당하였다.
print(numbers)                                                           # numbers 튜플을 출력하기 위해 print()함수를 사용하였다.
print(len(numbers))                                                      # numbers 튜플에 포함된 요소의 개수를 출력하기 위해 len()함수를 사용하였고, 출력하기 위해 print()함수를 사용하였다.

fruits = ['apple', 'orange', 'strawberry', 'pear', 'kiwi']               # fruits 변수에 리스트을 할당하기 위해 []를 이용하였고, 그 내부에 원소를 넣어 할당하였다.
print(fruits)                                                            # fruits 리스트을 출력하기 위해 print()함수를 사용하였다.

fruits_sub = fruits[:3]                                                  # fruits_sub 리스트에 fruits 리스트이 첫 세 요소만 포함하게 하도록 슬라이싱을 하였다.
                                                                         # 슬라이싱은 [:3]으로 한 이유는 index의 0, 1, 2 이 3개만 포함이 되기 때문이다.
print(fruits_sub)                                                        # fruits_sub 리스트을 출력하기 위해 print()함수를 사용하였다.
