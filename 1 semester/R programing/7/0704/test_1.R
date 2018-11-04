# The Birthday Problem
p = 0
q = 1
n = 1
while(p < 0.5)
{
  n = n + 1
  q = q * (365 - (n-1))/365
  p = 1 - q
}
n


