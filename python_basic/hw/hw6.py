# Assignment Number...: 6
# Student Name........: 이현호
# File Name...........: hw6_이현호
# Program Description.: 새로운 함수를 정의하고 사용하고, 람다함수를 활용하는 과제입니다.

def area_triangle(h, w):                     # def를 이용하여 area_trigangle라는 parameter(h, w)로 함수를 정의합니다. 
    return 0.5 * h * w                       # return을 사용하여 결과값을 정의합니다.


print(area_triangle(h = 10, w = 15))         # print()함수와 area_trigangle()라는 함수를 실행하여 그 값을 출력합니다. 
                                             # 전달인자는 h = 10, w = 15로 합니다.

def distance(a, b) :                         # def를 이용하여 distance라는 parameter(a, b)로 함수를 정의합니다.
    d = 0                                    # for문에서 d변수를 사용하기 위해 d변수를 초기화합니다.
    for i in range(2) :                      # 2차원 공간 상에서 두 점 사이의 거리를 계산하므로 range(2)로 두어 2회만 반복합니다.
        d = d + (a[i] - b[i])**2             # 2회를 반복하면서 (a[0] - b[0])의 제곱 (a[1] - b[1])의 제곱의 합을 d변수에 할당합니다.
    else :
        return d**(1/2)                      # 정상적으로 종료시 else :와 return을 이용하여 d변수의 1/2제곱을 결과로 돌려줍니다.

print(distance(a = (1, 2), b = (5, 7)))      # print()함수와 distance()함수를 사용하 a전달인자는 a = (1, 2), b = (5, 7)로 출력합니다.


def count(n) :                               # def를 이용하여 count라는 parameter(n)로 함수를 정의합니다.
    if n > 0 :                               # if:문을 사용하여 n이 0보다 크면,
        print(n)                             # print()함수를 사용하여 n을 출력합니다.
        return count(n - 1)                  # 또한 return을 사용하여 count(n-1)이라는 결과값이자 함수를 실행합니다.(재귀합수 = 자기자신을 불러드리는 함수)
    else :                                   # else:문을 사용하여 n이 0보다 크지 않은 경우
        print('zero!!')                      # print()함수를 사용하여 'zero!!'를 출력합니다.

count(5)                                     # count()함수를 전달인자 n = 5를 통해 실행합니다.
                                             # 이 경우 함수 안에 print()함수가 있으므로 print()함수를 사용하지 않고 count()함수만 실행시켜도 가능합니다.

area_triangle_Id = lambda h, w : 0.5 * h * w # area_triangle_Id에 람다함수를 정의합니다. 파라미터는 h와 w로 설정합니다. 반환값을 0.5 * h * w입니다.

print(area_triangle_Id(h = 10, w = 15))      # print()함수와 area_triangle_id함수를 실행하고, 전달인자를 h = 10, w = 15로 실행한 결과를 출력합니다.

