# Assignment Number...: 4
# Student Name........: 이현호
# File Name...........: hw4_이현호
# Program Description.: 제어문을 활용하는 과제입니다.



restaurant_list = [{'상호' :'A', '메뉴' : '피자', '가격(원)' : 20000},
                   {'상호' :'B', '메뉴' : '치킨', '가격(원)' : 18000},
                   {'상호' :'C', '메뉴' : '짜장면', '가격(원)' : 5000},
                   {'상호' :'D', '메뉴' : '초밥', '가격(원)' : 15000},
                   {'상호' :'E', '메뉴' : '치킨', '가격(원)' : 23000},
                   {'상호' :'F', '메뉴' : '족발', '가격(원)' : 30000}]                                             # restaurant_list 리스트 변수에 dict 자료형을 할당합니다.


want_to_eat = input('먹고 싶은 음식을 입력하세요 : ')                                                              # want_to_eat 변수에 input()함수를 이용해 먹고싶은 음식을 입력받아 할당합니다.


i = 0                                                                                                              
x = 0                                                                                                              # i는 밑의 순환문에서 사용되는 순환횟수이며, x는 사용자가 먹고 싶은 음식이 메뉴에 얼마나 존재하는지에 대해서 체크합니다.
while i < len(restaurant_list) :                                                                                   # while 순환문은 len(restaurant_list)함수를 통해 길이만큰 순환합니다.
    if restaurant_list[i].get('메뉴') == want_to_eat :                                                             # if문을 통해 사용자가 입력한 음식이 restaurant_list 메뉴에 있다면, 
        print('식당 {}, 가격 {} 원'.format(restaurant_list[i].get('상호'), restaurant_list[i].get('가격(원)')))    # restaurant_list의 상호와 가격(원)이 print()함수와 format()함수를 통해 출력됩니다.
                                                                                                                   # .get()함수는 key값을 통해 value값을 가져옵니다. 그 앞의 [i]통해 index를 가져옵니다.
        x += 1                                                                                                     # 사용자가 입력한 음식이 메뉴에 얼만큼 존재하는지 카운팅됩니다.
    i += 1                                                                                                         # i가 1단위씩 증가합니다.
else :                                                                                                             # while문이 끝난 뒤,
    if (x == 0) :                                                                                                  # 만약 x가 0이라면 즉 사용자가 입력한 메뉴가 restaurant_list에 하나도 없다면, 
        print('결과가 없습니다.')                                                                                  # 결과가 없음을 print()함수를 통해 출력합니다.
