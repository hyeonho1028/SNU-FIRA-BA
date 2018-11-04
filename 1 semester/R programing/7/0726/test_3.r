# sys사용하기




#setwd('C:/Users/renz/Desktop')
setwd('C:/workspace/R/7/0726')

idx = 1
a= 0
for ( i in 1:30 )
{
  Sys.sleep(1)
  cat('iterations:', i, 'th\n')
  a=a+1
}
a=a*idx
print(idx)
save.image(paste0('test', idx, '.rdata'))

system(command = 'r --restore --no-save <test_2.r> test_out.txt')
system(command = 'r --restore --no-save <test_2.r> test_out.txt', wait = FALSE)

a = system('tasklist', intern = T)
a

b <-gregexpr(" ", a[[3]])[[1]]
i = 5
substring(a[[i]],1,b[1])

substring(a[[i]],b[1]+1,b[2])

# readline와 cat ----

a = readLines('C:/workspace/R/7/0726/test_2.r')
a[59] = 'a - 1'






















a - 1
