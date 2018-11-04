################################## 6월 30일 ####################################
##### ...L 1) Varibles #####
##### ......L (1) typeof #####
x1 = 3.5
typeof(x1)
x2 = 3
typeof(x2)
x3 = 3L
typeof(x3)
x4 = 'a'
typeof(x4)
x5 = TRUE
typeof(x5)
x6 = x1 + x3
typeof(x6)

# R language is not strict tp the type of variables. It provides flexible type casting, 
# and thus we have to be care about the casting in R.
# R은 변수유형이 엄격하지 않고 유연하다.


##### ......L (2) creating vector #####
x = c(3)
# 1차원 배열 선언
x = c(88, 15, 12, 13)
# 일련의 연속적인 정수를 생성하기 위해 콜론을 자주 사용한다.
1:5
3:(-2)
(3.1):(5.5)

x1 = 1:3
x2 = 10:5
x3 = c(x2, x1)
x3
# 붙이는게 자유로움.



















