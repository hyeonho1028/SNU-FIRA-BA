# 예외처리 문
"""
L = ['사과', '딸기', '바나나', '블루베리', '포도']

target = input('과일입력...: ')

try :
    if target not in L :
        print('과일 목록에 존재하지 않습니다.')
    else :
        raise ValueError
except ValueError :
    for index, fruit in enumerate(L, 1) :
        if fruit == target :
            print('과일 목록의 {}번째에 존재합니다.'.format(index))


try :
    index = fruits.index(target)
except ValueError:
    print('과일 목록에 존재하지 않습니다.')
else
"""


while True :
    try :
        i = int(input('임의의 양의 정수를 입력하세요: '))
        if i == 1 :
            raise IndexError
        if type(i) == int and 1 < i :
            for j in range(2, i) :
                if i % j == 0 :
                    print('{} x {} = {}'.format(j, int(i/j), i))
                    print('이 숫자는 소수가 아닙니다.')
                    break
            else :
                print('이 숫자는 소수입니다.')
                break
            break
        else :
            raise ValueError        
    except ValueError :
        print('ValueError : 임의의 양의 정수를 입력하세요.')
    except IndexError :
        print('ValueError : 1보다 큰 양의 정수를 입력하세요.')


        
