# Xgboost
> 2016년 논문 : [XGBoostArxiv.pdf](http://dmlc.cs.washington.edu/data/pdf/XGBoostArxiv.pdf)

> 공식 문서 : [XGBoost Documents](https://xgboost.readthedocs.io/en/latest/)

###### 1. 기본
    1. 분산형 그라디언트 부스팅 알고리즘
    2. 부스팅 알고리즘이란?
      1) 부스팅 알고리즘은 약한 예측모형들을 결합하여 강한 예측모형을 만드는 알고리즘
      2) 배깅과 유사하게 초기 샘플데이터로 다수의 분류기를 만들지만 배깅과 다르게 순차적이다.
      3) 랜덤포레스트의 배깅과는 다르게 이전 트리의 오차를 보완하는 방식으로 순차적으로 트리를 만듦
      4) 결정트리(Decision Tree) 알고리즘의 연장선에 있음
      5) 여러 개의 결정트리를 묶어 강력한 모델을 만드는 앙상블 방법
      6) 분류와 회귀에 사용할 수 있음
      7) 무작위성이 없으며 강력한 사전 가지치기를 사용
