import sys
if len(sys.argv) != 3 or sys.argv[1] == '-help':
    print('usage python head.py number filename')
    sys.exit()
    
word = sys.argv[1]
file = sys.argv[2]

lines = open(file, mode = 'r', encoding = 'utf-8').readlines()

for index, line in enumerate(lines):
    if word in line:
        print('{}: {}'.format(index+1, line), end = "")
