import sys

if len(sys.argv) != 3 or sys.argv[1] == '-help':
    print('usage: python head.py number filename')
    sys.exit()


count = int(sys.argv[1])
file = sys.argv[2]

lines = open(file, encoding = 'utf-8').readlines()

if count > len(lines):
    count = len(lines)
        
for i in range(len(lines) - count, len(lines)):
    print(lines[i].rstrip())
