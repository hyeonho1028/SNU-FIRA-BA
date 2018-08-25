# Assignment Number...: 10
# Student Name........: 이현호
# File Name...........: hw10_이현호
# Program Description.: 파일을 열고 자료를 처리하는 과제입니다.


import copy                                                         # 깊은 복사를 하기 위해 copy를 import합니다.

file = open('subway.txt', mode = 'r', encoding = 'utf-8-sig')       # 파일을 open함수를 이용해 읽어옵니다. encoding이 utf-8-sig인 이유는 text파일을 읽어올때 head부분에 \ufeff가 붙는데 그걸 제거하고 불러옵니다.
lines = file.readlines()
file.close()                                                        # file을 readlines함수를 이용해 lines변수에 할당하고 close함수를 이용해 file을 close합니다.

subway_data = []
dict = {}
column = []                                                         # subway_data변수를 리스트, dict변수를 딕셔너리, column변수를 리스트로 각각 할당합니다.
for index, line in enumerate(lines):                                # lines를 for문으로 순회합니다.
    if index == 0:                                                  # index = 1일때 즉 lines의 첫줄, 컬럼명을
        for col in line.split(','):                                 # for문과 split함수를 이용해 분리하여 column리스트에 컬럼명을 추가합니다. strip를 이용하여 '\n'를 제거합니다.
            column.append(col.strip())
    else:
        line = line.split(',')                                      # 마찬가지로 split함수를 이용해 ','를 기준으로 분리하고
        for a in range(len(column)):                                # for순회문을 통해 column리스트를 순회합니다.
            dict[column[a]] = line[a].rstrip()                      # dict딕셔너리에 column리스트의 첫번째, line리스트의 첫번째를 할당합니다. line리스트에 있는 '\n'도 strip를 이용하여 제거합니다.
        subway_data.append(dict)                                    # 처음부터 마지막까지 다 할당하였다면, subway_data리스트에 append함수를 이용하여 추가합니다.
        subway_data = copy.deepcopy(subway_data)                    # 추가만 할 경우 dict와 같은 곳을 참조하므로 subway_data의 값이 변화하므로 deepcopy함수를 통해 깊은 복사를 하여 dict와 같은 곳을 참조를 안하게 합니다.



print('================================ 테스트 1 ================================')
print('금요일의 승하차 정보만 모은 목록')
fri = []                                                            # fri를 리스트로 만듭니다.
for line in subway_data:                                            # for문을 통해 subway_data를 순회합니다.
    if line.get('요일') == '금' and line.get('구분') == '하차':
        fri.append(line)                                            # if문을 통해 get함수를 이용하여 요일이 '금'이고, 구분이 '하차'일 경우 fri리스트에 line을 추가합니다.(line은 subway_data의 각 딕셔너리입니다.)
print(fri)                                                          # 위에서 get함수를 통해 key값으로 value값을 불러옵니다.print함수를 통해 fri리스트를 출력합니다.


print('================================ 테스트 2 ================================') 
print('날짜가 5의 배수인 날짜 중 10시에서 11시까지의 승차 인원은 홀수인 날들의 날짜 목록')
test2 = []
for line in subway_data:                                            # test2변수를 리스트로 만들고 for문을 통해 sdubway_data를 순회합니다.
    if int(line.get('날짜')) % 5 == 0 and int(line.get('10')) % 2 == 1:
        if line.get('구분') == '승차':                              # if문과 int함수를 통해 날짜가 5의 배수일 때를 5의 나머지는 0으로 구현합니다. 그리고 홀수인 경우는 int함수를 이용하여 2의 나머지가 1인경우로 하고 구분은 승차일 때로 조건을 합니다.
            test2.append(line)                                      # 위에서 get함수를 통해 key값으로 value값을 불러옵니다.test2리스트에 append함수를 이용하여 line을 추가합니다.
print(test2)



print('================================ 테스트 3 ================================') 
print('각 시간대별의 평균 승하차 인원', end = '\n\n')

test3_ride = [[],[],[],[],[]]
test3_quit = [[],[],[],[],[]]                                       # test3_ride, test3_quit 변수를 리스트로 만듭니다. 시간에 대한 컬럼의 개수는 5개이므로, 각각 데이터를 담을 곳도 5개가 필요하므로 리스트안에 5개의 리스트를 넣어 만듭니다.

for i, line in enumerate(subway_data):                              # for문을 통해 subway_data를 순회합니다.
    if line.get('구분') == '승차':                                  # get함수를 통해 key가 구분인 value가 승차이면, 각각 test3_ride리스트에 get함수를 통해 각각의 value값들이 append함수를 통해 추가됩니다. int함수를 통해 문자열이 아닌 정수로 추가합니다.
        test3_ride[0].append(int(line.get('7')))
        test3_ride[1].append(int(line.get('8')))
        test3_ride[2].append(int(line.get('9')))
        test3_ride[3].append(int(line.get('10')))
        test3_ride[4].append(int(line.get('11')))
    else:                                                           # 승차가 아닌경우 자동으로 하차가 되므로 
        test3_quit[0].append(int(line.get('7')))                    # get함수를 통해 key가 구분인 value가 승차이면, 각각 test3_ride리스트에 get함수를 통해 각각의 value값들이 append함수를 통해 추가됩니다. int함수를 통해 문자열이 아닌 정수로 추가합니다.
        test3_quit[1].append(int(line.get('8')))
        test3_quit[2].append(int(line.get('9')))
        test3_quit[3].append(int(line.get('10')))
        test3_quit[4].append(int(line.get('11')))


for index, data in enumerate(test3_ride):                           # for순회문을 통해 test3_ride값을 순회하며, 각각의 값을 모두더하기 위해 sum함수를 이용하고 len함수를 통해 개수를 센 평균값을 round함수를 통해 반올림합니다.
    print('승차의 시간대 평균 인원은 {}시 ~ {}시 : {}명'.format(    # 그 값을 format함수와 print()함수를 이용하여 출력합니다. index의 경우 각각의 시간의 값을 출력하기 위해 넣습니다.
        index + 7, index + 8, round(sum(test3_ride[index])/len(test3_ride[index]))))
print('')    
for index, data in enumerate(test3_quit):
    print('하차의 시간대 평균 인원은 {}시 ~ {}시 : {}명'.format(
        index + 7, index + 8, round(sum(test3_quit[index])/len(test3_quit[index]))))
