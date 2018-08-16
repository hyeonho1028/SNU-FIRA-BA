import sys

if len(sys.argv) != 4 or sys.argv[1] == '-help':
    print('usage: python head.py number filename')
    sys.exit()

start = int(sys.argv[1])
end = int(sys.argv[2])
file = sys.argv[3]

lines = open(file, mode = 'r', encoding = 'utf-8').readlines()

if start < 1:
    start = 1


if end > len(lines):
    end = len(lines)
        
for i in range(start - 1, end):
    print(lines[i].rstrip())
