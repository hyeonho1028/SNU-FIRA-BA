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
cat(a, file = 'C:/workspace/R/7/0726/test_3.R', sep = '\n')



# 시각화 추가부분 ----
counts = xtabs( ~ y + job, data = bank_dat)
prob = prop.table(xtabs( ~ y + job, data = bank_dat), 2)

b_plot = barplot(counts, main="직업별 구매여부", ylab = "count",
                 xlab = "직업", col = c(brewer.pal(5, 'BrBG')[c(2, 4)]),
                 legend = rownames(counts), 
                 args.legend = list(x ='topright', bty='n'), las=2)
text(b_plot, counts[1, ], labels = round(prob[2, ], 2), cex = 1.5)counts = xtabs( ~ y + job, data = bank_dat)
prob = prop.table(xtabs( ~ y + job, data = bank_dat), 2)

b_plot = barplot(counts, main="직업별 구매여부", ylab = "count",
                 xlab = "직업", col = c(brewer.pal(5, 'BrBG')[c(2, 4)]),
                 legend = rownames(counts), 
                 args.legend = list(x ='topright', bty='n'), las=2)
text(b_plot, counts[1, ], labels = round(prob[2, ], 2), cex = 1.5)


prob = prop.table(xtabs( ~ y + job, data = bank_dat), 2)

b_plot = barplot(prob, main="직업별 구매여부", ylab = "비율",
                 xlab = "직업", col = c(brewer.pal(5, 'BrBG')[c(2, 4)]), 
                 legend = rownames(counts),  ylim = c(0, 1.15), 
                 args.legend = list(x = "top", bty="n", ncol = 2), las=2)
text(b_plot, prob[1, ], labels = round(prob[2, ], 2), cex = 1.5)

prob = prop.table(xtabs( ~ y + contact, data = bank_dat), 2)

b_plot = barplot(prob, main="컨택별 구매여부", ylab = "비율",
                 xlab = "컨택", col = c(brewer.pal(5, 'BrBG')[c(2, 4)]), 
                 ylim = c(0, 1.15), legend.text = rownames(prob), 
                 args.legend = list(x = "top", bty="n", ncol = 2))
text(b_plot, prob[1, ], labels = round(prob[2, ], 2), cex = 1.5)

means = aggregate(nr.employed ~ month, data = bank_dat, mean)

l_plot = plot(means[, 2] , main = "month별 종업원수", type = "l",
              xlab = "month", ylab = "Count", xaxt="n", ylim = c(4950, 5250))
axis(1, at=1:10, labels=means[, 1]) 
text(x = means[, 1],y =  means[, 2] + 5, labels = round(means[, 2], 1), cex = 1.2)






















