# 클러스터링을 사용한 분류 및 분류 별 모델링
## - 도착지가 Long Beach 항구인 선박들의 베이스라인 선정 및 선박 도착시간 예측

---

## 분석배경
### 시나리오
 - 해상물류 운송 담당자인 은선씨는 선박의 정시성을 위해 Long Beach 항구로 도착하는 선박의 운항경로와 도착시간을 예측하고자 한다. 선박의 운항경로는 과거에 이용했던 항로들을 클러스터링하여 파악하고, 도착시간 예측은 출발지와 도착지 기준 약 70%지점에서 도착지까지 남은 시간을 예측하고자 한다. 

### 목표
- 먼저 도착지점이 Long Beach 항구인 선박들만 필터링하고, 16년 ~ 17년은 Train Data, 18년은 Test Data로 Split한다.

- UDF를 이용하여 두 지점간의 위도와 경도를 km로, DB-SCAN과 K-Means를 사용하여 클러스터링을 수행한다.

- Test Data와 유사한 클러스터링을 찾고 해당하는 클러스터링의 선박들로 XGB Regression Model을 만들고, 도착예정시간을 예측한다.

- 예측값과 실제값으로 모델을 평가한다. 평가 기준은 실제 도착시간의 $\pm​$ 10시간 이내에 예측시간이 존재한다면 맞은 것으로 생각하여 모델을 평가한다.

---

## Brightics 프로세스
<p style = "overflow:auto"><img src="s1.0/tutorial-resources/clustering_classification_regression/001.png" width = "800" > </p>

### Data Load
- AIS 데이터를 Load 한다. (<a href="s1.0/tutorial-resources/input/clustering_classification_regression.csv" download>clustering_classification_regression.csv.</a>)

- 각 선박들은 동일한 시간 간격을 가지지 않는다.

- Columns
  - ETA (String) : 기록된 시간
  - MMSI (String) : 선박의 고유 번호
  - LAT (Double) : 선박의 위치(위도)
  - LON (Double) : 선박의 위치(경도)
  - SPEED (Double) : 선박의 속도


|         ETA         |     MMSI      |   LAT   |    LON    | SPEED |
| :-----------------: | :-----------: | :-----: | :-------: | :---: |
| 2017-11-10 05:56:00 | 209087000_4_1 | 19.0743 | -104.2921 |   1   |
| 2017-11-10 06:07:00 | 209087000_4_1 | 19.0617 | -104.2988 |   6   |
| 2017-11-10 07:46:00 | 209087000_4_1 | 18.8178 | -104.2454 |  16   |
| 2017-11-10 09:12:00 | 209087000_4_1 | 18.5236 | -103.983  |  16   |
| 2017-11-10 10:21:00 | 209087000_4_1 | 18.2813 | -103.7795 |  16   |

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/002.PNG" width="800">


### Pre-processing
- 도착지가 Long Beach 항구인 선박들을 추출한다.

- XGB Regression 모델 학습과 예측을 위해 학습용 데이터와 검증용 데이터로 분리한다.

#### Add Row Number <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.extraction$add_row_number" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- 각 선박 별로 시간의 순서에 따라 Row Number Column을 추가한다.

- Parameter
  - Inputs : table
  - Group By : MMSI


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/003.PNG" width="800">

#### Statistic Summary <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.statistics$statistic_summary" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- 요약통계량을 사용하여 각 선박 별로 add_row_number의 max, 최댓값을 가져온다.

- 각 선박의 add_row_number 최댓값은 선박의 도착지점인 것을 알 수 있다.

- Parameter
  - Inputs : out_table
  - Input Columns : add_row_number
  - Target statistic : Max
  - Group By : MMSI

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/004.PNG" width="800">
<br><img src="s1.0/tutorial-resources/clustering_classification_regression/005.PNG" width="140">

#### Join <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$join" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- Join을 사용하여 각 선박의 위도와 경도 컬럼을 가져온다.

- Key의 역할을 하는 컬럼은 1번 테이블의 경우 MMSI, add_row_number, 2번 테이블의 경우 MMSI, max를 사용한다.

- Type을 Right로 설정하여 Right join을 실행한다.

- 완료하면, 선박의 도착지점의 위도와 경도를 알 수 있다.

- Parameter
  - Inputs : left_table(out_table), right_table(out_table)
  - Left Columns : MMSI, add_row_number
  - Right Columns : MMSI, max
  - Type : Right

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/006.PNG" width="800">
<br><img src="s1.0/tutorial-resources/clustering_classification_regression/007.PNG" width="140">

#### UDF

- 기존에 존재하지 않는 함수를 사용자가 만들어 사용할 수 있다.

- 위도와 경도를 입력하면, 사용자가 입력한 위치와 데이터의 위치간의 거리를 구할 수 있다.

- Long Beach 항구에 해당하는 위도와 경도를 입력하고 실행한다..

- distance라는 columns이 추가되며, 입력한 항구와 배들의 도착지점간의 거리의 값을 가지고 있다.

- PALETTE에 있는 Create UDF를 통해 UDF를 만들 수 있다.


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/008.PNG" width="300">

- Spec Generator
  - Label : Distance calculate using Latitude and Longitude
  - Script Type : Python
  - Input Configuration : Key(table), Type(Table)
  - Output Configuration : Key(out_table), Type(Table)
  - Python Script


```
import pandas as pd
from math import *

# Input Data
df1 = table[0]

# Function Definition
def distance(data, lat, lon):
    
    data['distance'] = 0
    L = []
	
	# Distance calculate
    for i,j,k in zip(data.index, data['LAT'], data['LON']):
        R = 6373.0 
        lat1 = radians(j) 
        lon1 = radians(k) 
        lat2 = radians(lat) 
        lon2 = radians(lon)
        dlon = lon2 - lon1 
        dlat = lat2 - lat1 
        a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2 
        c = 2 * atan2(sqrt(a), sqrt(1 - a)) 
        distance = R * c
        L.append(distance)
    else:
        data['distance'] = L

    return data

# Using function and output df
out_table = distance(df1, input_lat, input_lon)
```

  - Parameter
    1. Input_lat 
        - Label : Latitude
        - Control : Input
        - Mandatory : True
        - Value Type : Double
        - Min/Max : [-90, 90]
    
    2. Input_lon
        - Label : Longitude
        - Control : Input
        - Mandatory : True
        - Value Type : Double
        - Min/Max : [-180, 180]

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/009.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/010.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/011.PNG" width="800">

- Download JSON을 통해 만든 UDF를 다운로드한다.

- Import UDF를 통해 다운로드 받은 JSON파일을 Import한다.

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/012.PNG" width="300">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/013.PNG" width="800">

- Parameter
  - Inputs : table
  - Input_lat : 33.754929
  - Input_lon : -118.214344

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/014.PNG" width="800">

#### Filter <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.manipulation$simple_filter" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- 도착지점이 Long Beach 항구인 선박들만 필터링하기 위해 distance가 5km 이하인 row만 가져온다.

- Parameter
  - Inputs : out_table
  - Filter


```
distance <= 5
```


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/015.PNG" width="800">

#### Join <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$join" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- 도착지에 대한 데이터만 있기 때문에 조인을 통해서 각 선박에 해당하는 모든 data를 가져온다.

- Parameter
  - Inputs : left_table(table), right_table(out_table)
  - Left Columns : MMSI
  - Right Columns : MMSI
  - Type : Left

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/016.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/017.PNG" width="130">

#### Delete Missing Data <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$delete_missing_data" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- join으로 생성된 null value를 제거 한다.

- Parameter
  - Inputs : table
  - Input Column : 모든 컬럼을 선택한다.

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/018.PNG" width="800">

#### Select Column <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$select_column" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 
- 사용할 Columns만 선택함으로써 도착지가 Long Beach 항구인 데이터만 가져오는 것을 마무리한다.

- 다른 항구의 도착지를 원할 경우 UDF에서 위도, 경도만 변경해주면 된다.

- Parameter
  - Selected Column : ETA_left, MMSI, LAT_left, LON_left, SPEED_left


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/019.PNG" width="800">

#### Python Script <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 학습용 데이터와 검증용 데이터를 분리한다. 2016~2017년은 학습용 데이터로, 2018년은 검증용 데이터로 분리한다. 

- 단, 출발시점을 기준으로 삼는다.

- Parameter
  - Script

```
import pandas as pd

# Input Data
df = inputs[0]

# First Value Select
df1 = df.groupby('MMSI').first().reset_index()

# Year Slicing
df1['ETA_year'] = df1['ETA'].apply(lambda x: x[:4])
df1 = df1[['MMSI', 'ETA_year']]

# Output Data
df = pd.merge(df, df1, how='left', on='MMSI')
```

  - Outputs : df

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/020.PNG" width="800">

#### Filter <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.manipulation$simple_filter" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 2016~2017년을 Train Data로 사용하기 위해 필터링한다. 

- Parameter
  - Filter : ETA_year =’2016’ or ETA_year=’2017’


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/021.PNG" width="800">

- Test Data은 2018년으로 필터링한다.

- Parameter
  - Filter : ETA_year =’2018’

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/022.PNG" width="800">

#### Select Column  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$select_column" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- Train Data, Test Data로 나누는데 사용한 연도에 대한 컬럼을 빼고 선택한다.

- Parameter
  - Inputs : out_table
  - Select Column : ETA, MMSI, LAT, LON, SPEED


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/023.PNG" width="800">

- Test Data도 동일한 처리를 한다.

- Parameter
  - Inputs : out_table
  - Select Column : ETA, MMSI, LAT, LON, SPEED


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/024.PNG" width="800">

#### Python Script  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 클러스터링을 하기 위해 각 경로의 대푯값을 추출한다.

- 출발점, 도착점, 9개의 중간지점을 일정한 비율로 추출함으로써 각 경로의 대푯값을 가져온다.

- 일정한 비율로 추출하면 모든 경로의 차원이 동일해 지므로 클러스터링이 가능해 진다.

- Parameter
  - Script
```
import pandas as pd
import numpy as np
from itertools import chain

# Representative Value Extraction Function Definition
def representative_value(data):
	
	# Check y_value
    if 'y_value' not in data.columns:
        L1 = list()
        for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        
        	# Representative Value Extraction
            for k in range(0, 11):
                k = k/10
                df1 = data[data['MMSI'] == i][['MMSI', 'LAT', 'LON']].reset_index()

                if k == 0:
                    L2 = list()
                    L2.extend(list(df1[['MMSI', 'LAT', 'LON']].iloc[0, :]))
                    
                elif 0 < k < 1:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[int(round(j*k)), :]))

                else:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[-1, :]))
                    
            L1.append(L2)

        df = pd.DataFrame(L1)
        
        # columns name set
        a = [['MMSI', 'Start_LAT', 'Start_LON'], chain.from_iterable([['rpst_value_LAT'+str(i), 'rpst_value_LON'+str(i)] for i in range(1,10)]), ['End_LAT', 'End_LON']]
        a = list(chain.from_iterable(a))
        
        df.columns = a
        
        # Scaling latitude for longitude
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]]*2

        # -Latitude, -Longitude +TRANSPOSE
        df[df.columns[['LON' in i for i in df.columns]]] = df[df.columns[['LON' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))

        # start, end point weight
        df.iloc[:, 3:11] = df.iloc[:, 3:11]*3
        df.iloc[:, 17:-3] = df.iloc[:, 17:-3]*1.5

        return df

    else:
        L1 = list()
        for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        
        	# Representative Value Extraction
            for k in range(0, 11, 1):
                k = k/10
                df1 = data[data['MMSI'] == i][['MMSI', 'LAT', 'LON', 'y_value']].reset_index()

                if k == 0:
                    L2 = list()
                    L2.extend(list(df1[['MMSI', 'LAT', 'LON', 'y_value']].iloc[0, :]))
                elif 0 < k < 1:
                    L2.extend(list(df1[['LAT', 'LON', 'y_value']].iloc[int(round(j*k)), :]))
                else:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[-1, :]))
            L1.append(L2)

        df = pd.DataFrame(L1)

        # columns name set
        a = [['MMSI', 'Start_LAT', 'Start_LON', 'Start_y_value'], chain.from_iterable([['rpst_value_LAT'+str(i), 'rpst_value_LON'+str(i), 'y_value'+str(i)] for i in range(1,10)]), ['End_LAT', 'End_LON']]
        a = list(chain.from_iterable(a))
        
        df.columns = a

        # Scaling latitude for longitude
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]]*2

        # -Latitude, -Longitude +TRANSPOSE
        df[df.columns[['LON' in i for i in df.columns]]] = df[df.columns[['LON' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))

        # start, end point weight
        df[df.columns[['LAT' in i for i in df.columns]][:4]] = df[df.columns[['LAT' in i for i in df.columns]][:4]]*3
        df[df.columns[['LON' in i for i in df.columns]][:4]] = df[df.columns[['LON' in i for i in df.columns]][:4]]*3

        return df

# Using function and output df
df = representative_value(inputs[0].iloc[:, :5])
```
  - Outputs : df


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/025.PNG" width="800">

#### Python Script  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 모델링을 위해 Train Data를 변환한다.

- 선박이 출발지점과 도착지점을 기준으로 약 70% 지점에 도착하였을 때, 몇 시간 후에 도착하는 지를 예측 할 것이므로, X는 대푯값추출 Python Script를 이용하여 추출하고 Y는 도착지점에서의 ETA - 70%지점에서의 ETA로 계산한다.

- 계산은 Python Script를 사용한다

- 예측을 위해 TestData도 동일한 변환을 한다.

- Parameter
  - Script
```
import pandas as pd
import numpy as np
from itertools import chain

# Representative Value Extraction Function Definition
def representative_value(data):
	
	# Check y_value
    if 'y_value' not in data.columns:
        L1 = list()
        for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        
        	# Representative Value Extraction
            for k in range(0, 11):
                k = k/10
                df1 = data[data['MMSI'] == i][['MMSI', 'LAT', 'LON']].reset_index()

                if k == 0:
                    L2 = list()
                    L2.extend(list(df1[['MMSI', 'LAT', 'LON']].iloc[0, :]))
                    
                elif 0 < k < 1:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[int(round(j*k)), :]))

                else:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[-1, :]))
                    
            L1.append(L2)

        df = pd.DataFrame(L1)
        
        # columns name set
        a = [['MMSI', 'Start_LAT', 'Start_LON'], chain.from_iterable([['rpst_value_LAT'+str(i), 'rpst_value_LON'+str(i)] for i in range(1,10)]), ['End_LAT', 'End_LON']]
        a = list(chain.from_iterable(a))
        
        df.columns = a
        
        # Scaling latitude for longitude
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]]*2

        # -Latitude, -Longitude +TRANSPOSE
        df[df.columns[['LON' in i for i in df.columns]]] = df[df.columns[['LON' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))

        # start, end point weight
        df.iloc[:, 3:11] = df.iloc[:, 3:11]*3
        df.iloc[:, 17:-3] = df.iloc[:, 17:-3]*1.5

        return df

    else:
        L1 = list()
        for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        
        	# Representative Value Extraction
            for k in range(0, 11, 1):
                k = k/10
                df1 = data[data['MMSI'] == i][['MMSI', 'LAT', 'LON', 'y_value']].reset_index()

                if k == 0:
                    L2 = list()
                    L2.extend(list(df1[['MMSI', 'LAT', 'LON', 'y_value']].iloc[0, :]))
                elif 0 < k < 1:
                    L2.extend(list(df1[['LAT', 'LON', 'y_value']].iloc[int(round(j*k)), :]))
                else:
                    L2.extend(list(df1[['LAT', 'LON']].iloc[-1, :]))
            L1.append(L2)

        df = pd.DataFrame(L1)

        # columns name set
        a = [['MMSI', 'Start_LAT', 'Start_LON', 'Start_y_value'], chain.from_iterable([['rpst_value_LAT'+str(i), 'rpst_value_LON'+str(i), 'y_value'+str(i)] for i in range(1,10)]), ['End_LAT', 'End_LON']]
        a = list(chain.from_iterable(a))
        
        df.columns = a

        # Scaling latitude for longitude
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]]*2

        # -Latitude, -Longitude +TRANSPOSE
        df[df.columns[['LON' in i for i in df.columns]]] = df[df.columns[['LON' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))
        df[df.columns[['LAT' in i for i in df.columns]]] = df[df.columns[['LAT' in i for i in df.columns]]].apply(lambda x: x.apply(lambda x: np.abs(x) if x<0 else x))

        # start, end point weight
        df[df.columns[['LAT' in i for i in df.columns]][:4]] = df[df.columns[['LAT' in i for i in df.columns]][:4]]*3
        df[df.columns[['LON' in i for i in df.columns]][:4]] = df[df.columns[['LON' in i for i in df.columns]][:4]]*3

        return df
	  
# Y_Value Calculate Function Definition
def Y_Value(data) : 
	
    data['ETA'] = data['ETA'].apply(lambda x: datetime.datetime.strptime(x, "%Y-%m-%d %H:%M:%S"))
    lastTime = data.groupby('MMSI').last()['ETA'].reset_index()
    lastTime.columns = ['MMSI','LAST_ETA']
    data = pd.merge(data, lastTime , on = 'MMSI')
    data['y_value'] = round((data['LAST_ETA'] - data['ETA']) /np.timedelta64(1, 'h'),1)
    data = data.drop(columns=['LAST_ETA'])
    data['ETA'] = data['ETA'].astype(str)
	
    return data

# Using function and output df
df = Y_Value(inputs[0])
df = representative_value(df)
```
  - Outputs : df


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/026.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/027.PNG" width="800">



### Clustering using UDF

#### UDF 

- Distance calculate using Latitude and Longitude UDF와 동일한 과정을 거친다.

- Parameter
  - Inputs : df
  - Seed : 1028
  - SSE : 8
  - Combine Criteria : 42

- Spec Generator
  - Label : K-Means(non input K)
  - Script Type : Python
  - Inputs Configuration : Key(table), Type(Table)
  - Output Configuration : Key(out_table), Type(Table)
  - Python Script
```
from itertools import chain
from sklearn.cluster import DBSCAN
from sklearn.cluster import KMeans
import copy
import pandas as pd
import numpy as np
from math import *

# K-Means criteria calculate function
def users_kmeans(data, cluster_name, mse):
    
    if data.shape[0] == 1:
        data[cluster_name] = 2
        return data

    elif np.mean([round(np.mean([i**2 for i in (data.reset_index(drop=True).iloc[:, 1:].loc[i,] - data.reset_index(drop=True).iloc[:, 1:].describe().loc['mean',])]), 2) for i in range(0, len(data))]) < mse:
        data[cluster_name] = 2
        return data
    
    else:
        users_kmeans = KMeans(n_clusters=2, random_state=seed, init="k-means++").fit(data.iloc[:, 1:])

        if len(set(users_kmeans.labels_)) == 1:
            data[cluster_name] = 2
            return data
        
        else:
            df1 = copy.deepcopy(data)
            df1[cluster_name] = users_kmeans.labels_

            df2 = df1[df1[cluster_name]==0].reset_index(drop=True)
            df3 = df1[df1[cluster_name]==1].reset_index(drop=True)

            df2_mse = np.mean([round(np.mean([i**2 for i in df2.iloc[:, 1:].loc[i,] - df2.iloc[:, 1:].describe().loc['mean',]]), 2) for i in range(0, len(df2))])
            df3_mse = np.mean([round(np.mean([i**2 for i in df3.iloc[:, 1:].loc[i,] - df3.iloc[:, 1:].describe().loc['mean',]]), 2) for i in range(0, len(df3))])


            if df2_mse < mse and df3_mse < mse:
                df2[cluster_name] = '00'
                df3[cluster_name] = '11'

                return df1

            elif df2_mse < mse:
                df2[cluster_name] = 2
                return df1

            elif df3_mse < mse:
                df3[cluster_name] = 2
                return df1

            else:
                return df1


# Repeat Clustering
def auto_clustering(mmsi_data, mse):
    
    data = copy.deepcopy(mmsi_data)
    
    cluster_rt = pd.DataFrame()
    
    # Start point DB-SCAN
    start_cluster = DBSCAN(eps=2, min_samples=1).fit(data.iloc[:, 1:3]).labels_+1
    mmsi_data['start_cluster'] = start_cluster

    merge_data = pd.DataFrame()
    out_table = copy.deepcopy(mmsi_data)
    
    iter = np.unique(start_cluster)

    for i in iter:
        data = mmsi_data[mmsi_data['start_cluster'] == i].reset_index(drop=True)
        data = data.drop(columns='start_cluster')

        iter2 = 1
        
        while True:
	        
	        if iter2 == 1:
	            cluster_pd = pd.DataFrame()
	            cluster_name = 'cluster'+ str(iter2)
	            
	            df1 = users_kmeans(data, cluster_name, mse)
	            
	            cluster_pd = pd.concat([cluster_pd, df1[[cluster_name]]], axis=1)
	            cluster_pd = cluster_pd.astype('str').apply(lambda x: ''.join(x), axis=1)
	            
	            cluster_rt = pd.DataFrame({cluster_name : cluster_pd}) 
	            
	        elif iter2 > 1:
	            cluster_pd = pd.DataFrame()
	            cluster_name = 'cluster'+ str(iter2)
	            data['cluster_prediction'] = cluster_rt
	            
	            for i in np.unique(cluster_rt):
	                df1 = users_kmeans(data[data['cluster_prediction'] == i].drop(columns=['cluster_prediction']), cluster_name, mse)
	                
	                cluster_pd = pd.concat([cluster_pd, df1[[cluster_name]]], axis=1)
	                
	            else:
	                cluster_rt = pd.concat([cluster_rt, cluster_pd.astype(str).apply(lambda x: ''.join(x), axis=1).apply(lambda x: x.replace('nan', '')).astype(float).astype(int).astype(str)], axis=1).apply(lambda x: ''.join(x), axis=1)
	            
	            if all(cluster_rt.apply(lambda x: x[-1]=='2')):
	                break
	            
	            
	        iter2+=1
	    
        merge_data = merge_data.append(data[['MMSI', 'cluster_prediction']])

    out_table = copy.deepcopy(pd.merge(out_table, merge_data, how='left', on='MMSI'))
    out_table['cluster_prediction'] = out_table.iloc[:, -2:].astype(str).apply(lambda x: ''.join(x), axis=1)
    out_table = out_table.drop(columns=['start_cluster'])
    

    return out_table
    
    
# Not met node SSE calculate 
def re_cluster(data_, mse):
    data = copy.deepcopy(data_)
    unique_number = np.unique(data['cluster_prediction'].apply(lambda x: x[:1]))

    for i in unique_number:
        df1 = data[data['cluster_prediction'].apply(lambda x: x[:1])==i].reset_index(drop=True)
        df1 = df1.iloc[:, 1:].groupby('cluster_prediction').mean()

        df2 = pd.DataFrame()
        for idx in df1.index:
            list_a = [9999 if k == 0.0 else k for k in [round(np.mean((df1.loc[j, :] - df1.loc[idx, :])**2), 2) for j in df1.index]]
            df2 = df2.append(pd.DataFrame([idx, df1.index[np.argmin(list_a)], min(list_a)]).T)

        if df2.shape[0] > 0:
            df2 = df2[df2[2] < mse].reset_index(drop=True)
            df2[3] = df2[0]
            df2 = df2.sort_values(by=2)
            
            for p,q in enumerate(df2[1]):
                if q in df2[0].tolist():
                    df2.iloc[p, 3] = df2.iloc[df2[0].tolist().index(q), 3]
            else:
                data = pd.merge(data, df2[[0, 3]], how='left', left_on='cluster_prediction', right_on=0)
                data = data.drop(columns=0)
                data[3] = np.where(pd.notnull(data[3]), data[3], data['cluster_prediction'])
                data = data.drop(columns=['cluster_prediction'])
                data = data.rename(index=str, columns={3:'cluster_prediction'})

    return data
    

# Using function and output df
train_data_cluster = auto_clustering(table[0], input_sse)
out_table = re_cluster(train_data_cluster, input_recluster)
```

  -  Parameter
    1. seed
        - Label : Seed
        - Control : Input
        - Mandatory : False
        - Placeholder : 1028
        - Value Type : integer
        - Min/Max : [1, 100000]
    2. Input_sse
        - Label : SSE
        - Control : Input
        - Mandatory : True
        - Placeholder : 10
        - Value Type : Double
        - Min/Max : [1, 100]
    3. Input_recluster
        - Lable : Combine Criteria
        - Control : Input
        - Mandatory : True
        - Placeholder : 30
        - Value Type : Double
        - Min/Max : [1, 500]

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/028.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/029.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/030.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/031.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/032.PNG" width="800">

#### Select Column  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$select_column" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- Cluster결과를 Train Data에 Join하기 위해 미리 MMSI, cluster_prediction 컬럼을 선택한다.

- Parameter
  - Inputs : out_table
  - Selected Column : MMSI, cluster_prediction


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/033.PNG" width="800">

- Modeling에 사용하는 x, y컬럼을 선택한다.

- Parameter
  -	Inputs : df
  -	Selected Column : MMSI, Start_LAT, Start_LON, Start_y_value, rpst_value_LAT1, rpst_value_LON1, rpst_value_LAT2, rpst_value_LON2, rpst_value_LAT3, rpst_value_LON3, rpst_value_LAT4, rpst_value_LON4, rpst_value_LAT5, rpst_value_LON5, rpst_value_LAT6, rpst_value_LON6, rpst_value_LAT7, rpst_value_LON7, End_LAT, End_LON, y_value


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/034.PNG" width="800">

- Test Data도 동일한 처리를 한다.

- Parameter
  -	Inputs : df
  -	Selected Column : MMSI, Start_LAT, Start_LON, rpst_value_LAT1, rpst_value_LON1, rpst_value_LAT2, rpst_value_LON2, rpst_value_LAT3, rpst_value_LON3, rpst_value_LAT4, rpst_value_LON4, rpst_value_LAT5, rpst_value_LON5, rpst_value_LAT6, rpst_value_LON6, rpst_value_LAT7, rpst_value_LON7, End_LAT, End_LON, y_value


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/035.PNG" width="800">

#### Join  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.transform$join" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- Train Data에 cluster_prediction 컬럼을 조인한다.

- 각 선박 별 군집을 알 수 있다.

- Parameter
  -	Inputs : left_table(out_table), right_table(out_table)
  -	Left Columns : MMSI
  -	Right Columns : MMSI
  -	Type : Left

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/036.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/037.PNG" width="130">

### Model

- Test Data를 모델에 적합할 수 있도록 변환한다.

- Train Data를 사용하여 모델을 만들고 예측한다.

#### Python Script  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- Test Data의 선박들이 어떤 군집에 가장 가까운지 계산해서 cluster_predicion 컬럼에 값으로 나온다.

- 즉 동일한 군집에 속한 경로로 학습하고, 검증한다.

- Parameter
  - Script


```
import pandas as pd
import numpy as np


# Similarity test for test ship route and train route clustered
def route_similar(train, test):

    if 'cluster_prediction' in test.columns:
        test = test.drop(columns = ['cluster_prediction'])
    if 'MMSI' in test.columns:
        test_MMSI = test['MMSI']
        test = test.drop(columns = ['MMSI'])
    if 'y_value7' in test.columns:
        true_value = test['y_value7']
        test = test.drop(columns = ['y_value7'])

    train1 = train.drop(columns=['MMSI', 'y_value7']).groupby('cluster_prediction').mean()

    a = list()
    for i in test.index:
        b = [round(np.mean((test.loc[i,:] - train1.loc[j,:])**2),2) for j in train1.index]
        a.append(np.argmin(b))

    test['cluster_prediction'] = train1.iloc[a,:].index

    test['MMSI'] = test_MMSI
    test['y_value7'] = true_value

    return test
  
# Using function and output df
df = route_similar(inputs[0], inputs[1])
```

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/038.PNG" width="800">

#### Python Script  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 각 위도와 경도를 도착지와의 거리로 변수화한다

- time1은 출발지점에서 도착지점까지의 남은 시간이며, time7은 60%지점에서 도착지점까지의 남은 시간이다.

- Test Data의 경우 남은 시간을 알 수 없으므로 Train Data의 가장 비슷한 경로의 시간으로 대체한다. 

- Parameter
  - Script


```
# Insert cluster_name
cluster_name = '3001'

import pandas as pd
import numpy as np
from math import *
import datetime

# Dmetrization Function Definition
def Dmetrization(raw_data, data):
    '''
    raw data and data(train, test)
    data include the y_value
    '''
    y_value = data[['MMSI', 'y_value7']]
    data1 = data
    raw_data = raw_data[raw_data['MMSI'].isin(data['MMSI'])].reset_index(drop=True)
    data = raw_data

    L1 = list()
    L_time = list()
    for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        for k in range(0, 11):
            k = k/10
            df1 = data[data['MMSI'] == i][['ETA', 'MMSI', 'LAT', 'LON']].reset_index()

            if k == 0:
                L2 = list()
                L2.extend(list(df1[['MMSI', 'LAT', 'LON']].iloc[0, :]))
                L_time2 = list()
                L_time2.extend(list(df1[['MMSI', 'ETA']].iloc[0, :]))
                
            elif 0 < k < 1:
                L2.extend(list(df1[['LAT', 'LON']].iloc[int(round(j*k)), :]))
                L_time2.extend(list(df1[['ETA']].iloc[int(round(j*k)), :]))

            else:
                L2.extend(list(df1[['LAT', 'LON']].iloc[-1, :]))
                L_time2.extend(list(df1[['ETA']].iloc[-1, :]))
        else:        
            L1.append(L2)
            L_time.append(L_time2)
    else:
        df = pd.DataFrame(L1)
        df_time = pd.DataFrame(L_time)
    
    a = [['MMSI', 'Start_LAT', 'Start_LON'], chain.from_iterable([['rpst_value_LAT'+str(i), 'rpst_value_LON'+str(i)] for i in range(1,10)]), ['End_LAT', 'End_LON']]
    a = list(chain.from_iterable(a))
    
    df.columns = a
    df = pd.merge(df, data1, how='left', on='MMSI')
    df = df.drop(columns=['rpst_value_LAT8', 'rpst_value_LON8', 'rpst_value_LAT9', 'rpst_value_LON9'])

    data = df.drop(columns=['MMSI']).reset_index(drop=True)
    end_lat = data.columns.tolist().index('End_LAT')
    
    df2 = pd.DataFrame()

    for idx2 in range(len([data.iloc[:, [i, i+1]] for i in range(0, len(data.iloc[:, :end_lat].columns), 2)])):
        L = []
        
        # Distance calculate
        for idx in data.index: 

            lat1, lon1 = [data.iloc[:, [i, i+1]] for i in range(0, len(data.iloc[:, :end_lat].columns), 2)][idx2].apply(lambda x: x[idx])
            lat2, lon2 = data.iloc[:, [end_lat, end_lat+1]].apply(lambda x: x[idx])

            R = 6373.0 
            lat1 = radians(lat1) 
            lon1 = radians(lon1) 
            lat2 = radians(lat2) 
            lon2 = radians(lon2)
            dlon = lon2 - lon1 
            dlat = lat2 - lat1 
            a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2 
            c = 2 * atan2(sqrt(a), sqrt(1 - a)) 
            distance = R * c
            L.append(distance)
        else:
            df2 = pd.concat([df2, pd.DataFrame({'distance{}'.format(idx2+1) : L})], axis=1)
    else:
        df2 = pd.concat([df2, df[['MMSI']]], axis=1)
        df_time2 = df_time.drop(columns=[0]).apply(lambda x: x.apply(lambda x: datetime.datetime.strptime(x, "%Y-%m-%d %H:%M:%S")))
        time1 = round((df_time2[11]-df_time2[1]) / np.timedelta64(1, 'h'), 1)
        time7 = round((df_time2[11]-df_time2[7]) / np.timedelta64(1, 'h'), 1)
        df_time = pd.concat([df_time[[0]], time1, time7], axis=1)
        df_time.columns = ['MMSI', 'time1', 'time7']

        df2 = pd.merge(df2, df_time, how='left', on='MMSI')
        df2 = pd.merge(df2, y_value, how='left', on='MMSI')
        df2['y_value'] = df2['y_value7']
        df2 = df2.drop(columns='y_value7')
        # df2 = pd.concat([df2, pd.DataFrame({'time_start': time1, 'time_last_point': time8, 'y_value': y_value.reset_index(drop=True)})], axis=1)

    return df2.drop(columns='MMSI')

# time1 and time7 column calculate
def test_receive_t1t7(train, test):
    train1 = train.iloc[:, :8]
    test1 = test.iloc[:, :8]
    
    for ii, idx in enumerate([test1.iloc[:, :8].loc[i] for i in test1.index]):
        test.loc[ii, 'time1'] = train.loc[np.argmin([np.mean((idx-train1.loc[j])**2) for j in train1.index]), 'time1']
        test.loc[ii, 'time7'] = train.loc[np.argmin([np.mean((idx-train1.loc[j])**2) for j in train1.index]), 'time7']
    
    return test

train = inputs[0][inputs[0]['cluster_prediction']==cluster_name][['MMSI', 'y_value7']]
test = inputs[2][inputs[2]['cluster_prediction']==cluster_name][['MMSI', 'y_value7']]

train_final = Dmetrization(inputs[1], train) # raw data path
test_final = Dmetrization(inputs[1], test) # raw data path

# Using function and output df
test_final = test_receive_t1t7(train_final, test_final)
```


  -	Outputs : Train_final, Test_final

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/039.PNG" width="800">

#### Python Script  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/PythonScript" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 파이썬 스크립트를 사용하여 Brightics Studio에서 제공하는 Parameter보다 더 많은 Parameter을 사용할 수 있다.

- Parameter
  - Script


```
from brightics.function.regression import xgb_regression_train
# XGB Regression

df = inputs[0]
res = xgb_regression_train(df, feature_cols = df.drop(columns='y_value').columns.tolist(), 
						   label_col = ['y_value'], 
						   max_depth=8, learning_rate=0.15, n_estimators=1000,
						   silent=True, objectibe='reg:linear', booster='gbtree',
						   n_jobs=1, nthread=None, gamma=0.1, min_child_weight=13, 
						   max_delta_step=0, subsample=1, colsample_bytree=0.8, 
						   colsample_bylevel=0.3, reg_alpha=0.1, reg_lambda=1, 
						   scale_pos_weight=1, base_score=0.5, random_state=1, 
						   seed=1028, missing=None, sample_weight=None, eval_set=None, 
						   eval_metric=None, early_stopping_rounds=None, 
						   verbose=True, xgb_model=None, sample_weight_eval_set=None)
df = res['model']
```

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/040.PNG" width="800">
</br><img src="s1.0/tutorial-resources/clustering_classification_regression/041.PNG" width="800">


#### XGB Regression Prediction  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.regression$xgb_regression_predict" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 만든 모델과 Test Data를 사용해서 예측을 한다.

- Parameter
  - Inputs : table(test_final), model(df)
  - Prediction Column Name : prediction


</br><img src="s1.0/tutorial-resources/clustering_classification_regression/042.PNG" width="800">


### Model Evaluation

#### Evaluate Regression  <a href="http://dev.brightics.ai/docs/ai/v3.6/function_reference/python/brightics.function.evaluation$evaluate_regression" target="_blank"><img src="s1.0/tutorial-resources/tool-help.png"></a> 

- 실제값과 예측값으로 모델의 성능을 평가한다.

- MSE, MAE 등의 값을 비교해 봤을 때, 낮은 Error를 볼 수 있다.  목표였던 $\pm$ 10시간 이내에 모든 예측치가 있으므로, 높은 정확도를 가진 모델이라고 평가할 수 있다.​​

- Parameter
  - Inputs : out_table
  - Label Column : y_value
  - Prediction Column : prediction

</br><img src="s1.0/tutorial-resources/clustering_classification_regression/043.PNG" width="800">

---

## Comment

- 분석 결과 은선은 Long Beach 항구로 가는 경로들을 클러스터링을 통해 ....개의 경로로 분류하였으며, 검증 데이터와 가장 비슷한 군집을 찾아서 모델을 만들었고, 해당 모델의 평가 결과 높은 정확도를 가지고 있는 것으로 판단하였다.

------

## Data & Model 다운로드

### 입력 데이터

- <a href="s1.0/tutorial-resources/input/clustering_classification_regression.csv" download>clustering_classification_regression.csv</a>

### 참고 모델 

- <a href="s1.0/tutorial-resources/model/Clustering classification regression.json" download>Clustering classification regression.json</a>

- <a href="s1.0/tutorial-resources/model/Distance calculate using Latitude and Longitude.json" download>Distance calculate using Latitude and Longitude.json</a>

- <a href="s1.0/tutorial-resources/model/K-Means(non input K).json" download>K-Means(non input K).json</a>

------

 **#K-means** **#SSE** **#Clustering** **#UDF** **#XGB** **#XGB Evaluation**

