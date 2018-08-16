"""
a = input('what is your name? ')
print('Hi! ' + a)
print('The length of your name is : ', len(a))
print()
b = input('what is your age? ')
print('you will be', int(b) + 1, 'years old in the next year.')
print('Bye~~~!')
"""


a = input('이름을 입력하세요...: ')
print('안녕', a)
print('The length of your name is ', len(a))
print('당신 이름은 :', str(len(a)) + '자 입니다.', end = '\n\n')
b = input('몇 살이세요? ')
print('you will be', int(b) + 1, 'years old in the next year.')
print('내년에', str(int(b) + 1) + '살이 되시는군요.')
print('Bye~~~!')






