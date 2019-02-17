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



## 2. 내용
1. 소개
    1) 희소성 인식 알고리즘(sparse data and weighted quantile sketch for approximate tree learning)
    2) 캐시 엑세스 패턴, 데이터 압축 및 샤딩(cache access patterns, data compression and sharding to build a scalable tree boosting system)
    3) using far fewer resources than existing systems

2. Tree boosting

    ![image](https://user-images.githubusercontent.com/40379485/52908920-4853b380-32c2-11e9-9ff4-8d93c06f0a3a.png)
    1) Tree boosting
    2) We design and build a highly scalable end-to-end tree boosting system(확장성이 뛰어나다, end-to-end system design)
    3) We introduce a novel sparsity-aware algorithm for parallel tree learning(병렬 트리 학습을 위한 새로우 희소성 인식 알고리즘)
    4) We propose a theoretically justified weighted quantile sketch for efficient proposal calculation(이론적으로 정당화 된 가중치가 있는 분위수)
    5) We propose an effective cache-aware block structure for out-of-core tree learning(효과적인 캐시 인식 블록 구조)
    
    
3. Tree boosting in a nutshell
1) Regularized learning objective
```
(1) sum
(2) The second term Ω penalizes the complexity of the model
```

2) gradient tree bossting
```
(1) greedy algorithm
(2) taylor expansion
(3) first and second order gradient statistics on the loss function
```

3) shrinkage and column subsampling

![image](https://user-images.githubusercontent.com/40379485/52909251-1a25a200-32c9-11e9-836a-85a78b98a0ce.png)

```
(1) 수축은 새로 추가 된 가중치를 요인에 의해 조절합니다. η는 트리 부스팅의 각 단계 후에 나타납니다. 학습률과 유사 확률 적 최적화에서 수축은 영향을 감소시킨다.

(2) 두 번째 기술은 열 (피쳐) 서브 샘플링입니다.
이 기법은 RandomForest에서 일반적으로 사용되지만, 전에 트리 부스팅에 적용되지 않았습니다. 사용자 피드백에 대해 열 서브 샘플링을 사용하면 기존 행 서브 샘플링보다 훨씬 많은 오버 피팅을 방지 할 수 있습니다(또한 지원됩니다).
```





