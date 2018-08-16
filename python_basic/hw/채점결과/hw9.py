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

# Assignment Number... : 9
# Student Name........ : 이현호
# File Name........... : hw9_이현호
# Program Description. : csv파일을 불러와 읽는 방법을 익히고 txt파일을 파싱하는 과제입니다.


file = open('C:/tools/Scripts/hw/hw9_dataset/cars.csv', mode = 'r', encoding = 'utf-8')      # open()함수를 이용해 cars.csv파일을 읽어와 file변수에 할당합니다.

for line in file:
    print(line)
file.close()                                                                                 # for문을 활용해 cars.csv파일을의 각 줄을 출력하고, close()함수를 이용하여 flie을 close합니다.







file = open('C:/tools/Scripts/hw/hw9_dataset/cars.csv', mode = 'r', encoding = 'utf-8')      # open()함수를 이용해 cars.csv파일을 읽어와 flie변수에 할당합니다.

L = list()
for line in file.readlines():
    line = tuple(line.split(','))
    L.append(line)                                                                           # for순환문을 이용하여 readlines()함수로 불러온 문장을 ','를 기준으로 split하여 tuple로 만들고, append함수를 이용하여 L리스트에 추가합니다.
print(L)                    
file.close()                                                                                 # print()함수를 이용하여 3개의 요소를 가진 4개의 튜플이 저장된 리스트를 출력하고 close()함수를 이용하여 file을 close합니다.
    






file2 = open('C:/tools/Scripts/hw/hw9_dataset/My way.txt', mode = 'r', encoding = 'utf-8')   # open()함수를 이용해 My way.txt파일을 읽어와 file2변수에 할당합니다.

for line in file2:
    print(line)
file.close()                                                                                 # for순환문을 이용하여 My way.txt의 각 줄을 출력하고 close()함수를 이용하여 file을 close합니다.






file2 = open('C:/tools/Scripts/hw/hw9_dataset/My way.txt', mode = 'r', encoding = 'utf-8')   # open()함수를 이용하여 My way.txt파일을 읽어와 file2함수에 할당합니다.

L = list()
for line in file2.readlines():
    L.append(line)                                                                           # for순환문과 print()함수를 이용하여 My way.txt파일의 각줄을 L리스트에 append합니다.
print(L[2])                                                                                  # print()함수를 이용하여 L리스트의 3번째 요소를 출력합니다.
file.close()                                                                                 # close()함수를 이용하여 file을 close합니다.

file2 = open('C:/tools/Scripts/hw/hw9_dataset/My way.txt', mode = 'a', encoding = 'utf-8')   # open()함수를 이용하여 My way.txt파일을 'a'매개변수 즉 글의 밑부분에 추가할 수 있는 매개변수를 입력하여 flie2변수에 할당합니다.
file2.write("\nI'll state my case, of which i'm certain")                                    # write()함수를 이용하여 문구를 추가합니다.
file2.close()                                                                                # file을 close합니다.

file2 = open('C:/tools/Scripts/hw/hw9_dataset/My way.txt', mode = 'r', encoding = 'utf-8')   # open()함수를 이용하여 My way.txt파일을 읽어와 flie2변수에 할당합니다.
print(file2.read())                                                                          # print()함수와 read()함수를 이용하여 My way.txt파일을 출력합니다.
