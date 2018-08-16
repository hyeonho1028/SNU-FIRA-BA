import sys

if len(sys.argv) != 3 or sys.argv[1] == '-help':
    print('usage: python head.py number filename')
    sys.exit()


count = int(sys.argv[1])
file = sys.argv[2]

with open(file, encoding = 'utf-8') as f:
    lines = f.readlines()
# lines = open(file).readlines()    
if count > len(lines):
    count = len(lines)
        
for i in range(count):
    print(lines[i].rstrip())
