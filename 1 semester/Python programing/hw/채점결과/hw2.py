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


# Assignment Number...: 2
# Student Name........: 이현호
# File Name...........: hw2_이현호
# Program Description.: 문자열(str) 자료형의 변수를 생성하고 슬라이싱(slice)하여 출력하는  과제입니다.

cellphone = 'Samsung Galaxy S8'                                     # cellphone 변수에 자신의 핸드폰 정보를 문자열 자료형으로 할당합니다.
print(cellphone)                                                    # print()함수를 사용하여 cellphone를 출력합니다.

company = cellphone[:7]                                             # 분할 연산자를 사용하여 cellphone 변수의 index의 시작부분부터 7전까지를 company 변수에 할당합니다.
print(company)                                                      # print()함수를 사용하여 company를 출력합니다.

model = cellphone[8:]                                               # 분할 연산자를 사용하여 cellphone 변수의 index의 8부터 끝까지를 model 변수에 할당합니다.
print(model)                                                        # print()함수를 사용하여 model를 출력합니다.

print(type(company))                                                # 자료형을 출력하는 함수인 type()로 company 변수의 자료형을 출력하고 print()함수를 사용하여 출력합니다.

print(type(model))                                                  # 자료형을 출력하는 함수인 type()로 model 변수의 자료형을 출력하고 print()함수를 사용하여 출력합니다.

print('It had been that way for days and days. \n And then, \
just before the lunch bell rang, he walked into our \nclass room.\
\n Stepped through that door white and softly as the snow.')        # print()함수를 한번만 사용했을 경우 너무 길어 가독성이 떨어지므로 그 다음줄로 이어서 쳤고, 그러기 위해선
                                                                    # 새줄바꿈을 탈출하는 이스케이프'\'를 사용합니다. 또한 linefeed하기 위해 이스케이프'\n'를 사용합니다.
