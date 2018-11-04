# 데이터
# 연속 vs 이산
# 
# 이산은
# 계수(counting) vs 범주(categorical)
# 
# 범주
# nominal(명목형-성별) vs ordinal(순서형-나이대별)


data(iris)


table(iris$Species)
tabulate(iris$Species)


par(cex=1.3) #plot의 상대적인 크기



data(faithful)

edge1<-seq(from=1, to=6, by=0.4)
hist(faithful$eruptions, breaks=edge1, freq=F,xlim=c(0,6), ylim=c(0,0.6),main='h=0.4')
hist(faithful$waiting)


# right = F default = T이다. 이건 히스토그램에서 (1,2], (2,3] 같이 경계값들은
# 왼쪽으로 떨어지거나 오른쪽으로 떨어지게 조절

# 히스토그램 확장한 방법 -> non prarmetic 비모수
# ASH방법이 또 잇는데 (i,j] j값을 조절하는 거.


# dencity로 하면 되지.
# 줄기잎은 데이터 많을 땐 못하고 좀 없을때 쓰자.

# 2차원자료정리.
# contingency table 2차원 분할표
#독립성검정
#동질성검정의 경우 1차원 일 때!

#plot에서 type = 'n'은 아무것도 안나오게 하는거.
#point에서 lwd=2는 점 크기.

# tidyverse라는 사이트가 있는데 여기에 dplyr 과 ggplot 등이 있음

# estimatior 과 estimate 가 다르다.
# estimate 다 더해서 n으로 나누는 기능을 하는 애, estimatior는 그 값.

# 사분위수의 경우 이상값의 영향을 잘 받지 않는다. 백분위수도 마찬가지.

# 표본의 범위 x(n) - x(1) 맥시멈-미니멈 ()는 index를 대부분 뜻함.

# range함수는 자동으로 R[2], R[1] 맥시멈, 미니멈 구해준다.

# quantile 0.1, 0.3, 0.25, 원하는 %타입 을 지정.

# 5개 통계치 최솟값 1분위수 중앙값 3분위수 최대값.

boxplot(faithful$eruptions)
boxplot(faithful$waiting)


# 왜도와 첨도.

# 왜도의 경우 데이터가 찌그러진정도 세제곱이 양, 0, 음으로 판단(치우침)

# 정률추정법으로(estimate) 추정한 시그마^2 기준에 따라서 어떤애들이 좋은지 
# 뭐..그런 기준이 있다.


# 왼쪽으로 치우친 애들은 음의 값을 갖고 오른쪽으로 치우친 애들은 양의 값을 갖는다.

# 첨도는 꼬리부분이 얼마나 두꺼운지를 나타난다.
# 보험같은경우.. 태풍 or 극단적인 상황 이런 데이터는 끝의 데이터가 유지.
# 테일이 두껍다.. 그런게 있는지를 판단.
# 정규분포를 기준으로 한다. 3이면 정규분포이다.

# t분포는 정규분포보다 tail 이 두껍다. 즉 양수가 나온다.


# 선형의 관계가 아니면 상관관계로 보는것이 적절하지 않을 수 있다.

# 상관관계가 없다고 상관성이 전혀 없다고 보는건 옳지 않다.



















