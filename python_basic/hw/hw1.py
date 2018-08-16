# Assignment Number...: 1
# Student Name........: 이현호
# File Name...........: hw1_이현호
# Program Description.: 이것은 기본적인 자료형, input 함수를 활용하고 print하는 과제입니다.

season = input('What is your favorite season? ')                                            # season이라는 변수에 사용자가 좋아하는 계절을 할당시키기 위해 input함수를 사용하였다.
print(season)                                                                               # season 변수를 출력하기 위해 print함수를 사용하였다.

date = input('Which date were you born? ')                                                  # date라는 변수에 사용자가 태어난 날짜를 할당하기 위해 input함수를 사용하였다.
print(type(date))                                                                           # date 변수의 자료형을 출력하기 위해 type함수와 print함수를 사용하였다.

date = float(date)                                                                          # date 변수의 자료형을 float 타입으로 변경하기 위해 float함수를 사용하였다.
print(type(date))                                                                           # 변경된 date 변수의 자료형을 출력하기 위해 type함수와 print함수를 사용하였다.

print('My favorite season is', season + '. I was born on the', str(int(date)) + 'th.')      # 사용자가 좋아하는 게절과 태어난 날짜를 한문장에 출력하기 위해 문자형인 season은 +을 이용해 결합하였고,
                                                                                            # 실수형인 date는 정수형으로 바꿔준 후, 결합하기 위해 문자형으로 변경하였다.
                                                                                            # 사용된 함수는 정수형으로 바꾸기 위한 int함수와 문자형으로 변경하기위한 str함수이다.
