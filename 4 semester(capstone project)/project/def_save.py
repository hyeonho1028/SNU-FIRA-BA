from itertools import chain
from sklearn.cluster import DBSCAN
from sklearn.cluster import KMeans
import copy
import pandas as pd
import numpy as np
from math import *
import folium
import datetime
import xgboost as xgb



def port_5km(data, lat, lon):
    '''
    port 좌표와 data lon, lat를 이용하여 거리계산
    '''
    data1 = data.groupby(['MMSI']).last()
    L1 = []
    
    for i,j,k in zip(data1.index, data1['LAT'], data1['LON']):
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
        L1.append(distance)

    df1 = pd.DataFrame(list(zip(data1.index, L1)), columns = ['MMSI', 'distance'])
    df2 = df1[df1['distance'] <= 5]['MMSI'].tolist()
    df3 = data[data['MMSI'].isin(df2)].reset_index(drop=True)
    
    return df3


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

def test_receive_t1t7(train, test):
    train1 = train.iloc[:, :8]
    test1 = test.iloc[:, :8]
    
    for ii, idx in enumerate([test1.iloc[:, :8].loc[i] for i in test1.index]):
        test.loc[ii, 'time1'] = train.loc[np.argmin([np.mean((idx-train1.loc[j])**2) for j in train1.index]), 'time1']
        test.loc[ii, 'time7'] = train.loc[np.argmin([np.mean((idx-train1.loc[j])**2) for j in train1.index]), 'time7']
    
    return test



def representative_value(data):
    '''
    representative value 추출 / 출발점, 도착점, 9개의 대푯값 추출
    y_value가 있으면, else문 : y_value도 같이 추출한다.
    '''
    if 'y_value' not in data.columns:
        L1 = list()
        for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
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



# train data, test data split
def train_test_split(data):
    '''
    test data(2018년)
    train data(그 외)
    split exeute
    '''
    df = copy.deepcopy(data)
    df1 = df.groupby('MMSI').first().reset_index()

    df_train = df1[df1['ETA'].apply(lambda x: x[:4] != '2018')]
    df_test = df1[df1['ETA'].apply(lambda x: x[:4] == '2018')]

    df1 = df[df['MMSI'].isin(df_train['MMSI'])].reset_index(drop=True)
    df2 = df[df['MMSI'].isin(df_test['MMSI'])].reset_index(drop=True)

    df1 = Y_Value(df1)
    df2 = Y_Value(df2)

    return df1, df2


def Y_Value(data) : 

    data['ETA'] = data['ETA'].apply(lambda x: datetime.datetime.strptime(x, "%Y-%m-%d %H:%M:%S"))
    lastTime = data.groupby('MMSI').last()['ETA'].reset_index()
    lastTime.columns = ['MMSI','LAST_ETA']
    data = pd.merge(data, lastTime , on = 'MMSI')
    data['y_value'] = round((data['LAST_ETA'] - data['ETA']) /np.timedelta64(1, 'h'),1)
    data = data.drop(columns=['LAST_ETA'])

    return data


# test ship route가 어떤 train route clustered 유사한가
def route_similar(train, test):
    '''
    test data의 경우 LAT, LON은 7까지만 존재해야 한다.
    '''
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
        b = [round(np.mean((test.loc[i,:] - train1.loc[j,])**2),2) for j in train1.index]
        a.append(np.argmin(b))

    test['cluster_prediction'] = train1.iloc[a,].index

    test['MMSI'] = test_MMSI
    test['y_value7'] = true_value

    return test 


def users_kmeans(data, cluster_name, mse):
    
    if data.shape[0] == 1:
        data[cluster_name] = 2
        return data

    elif np.mean([round(np.mean([i**2 for i in (data.reset_index(drop=True).iloc[:, 1:].loc[i,] - data.reset_index(drop=True).iloc[:, 1:].describe().loc['mean',])]), 2) for i in range(0, len(data))]) < mse:
        data[cluster_name] = 2
        return data
    
    else:
        users_kmeans = KMeans(n_clusters=2, random_state=1028, init="k-means++").fit(data.iloc[:, 1:])

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


def auto_clustering(mmsi_data, mse):
    
    data = copy.deepcopy(mmsi_data)
    
    cluster_rt = pd.DataFrame()
    
    # 출발점을 기준으로 사전 클러스터링 실행
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
    
    # representative_value weight *2 release
    # data.iloc[:, 1:3] = data.iloc[:, 1:3]/1.5


    return out_table



# folium
# map painting and save
def folium_save(data):
    '''
    data를 넣으세요.
    MMSI, cluster_prediction이 존재해야 합니다.
    Folium을 사용하여 cluster별로 파일이 생성됩니다.
    '''
    unique_cluster = np.unique(data['cluster_prediction'])
    for iter in unique_cluster:
        data['LON'] = data['LON'].apply(lambda x: x-360 if x>0 else x)
        
        df1 = data[data['cluster_prediction'] == iter].reset_index(drop=True)
        
        m = folium.Map(location=[df1.loc[0,'LAT'], df1.loc[0,'LON']], zoom_start=1, tiles='Stamen Terrain')
        for i in range(df1.shape[0]):
            folium.CircleMarker(location=[df1.loc[i,'LAT'], df1.loc[i,'LON']], color = 'red', radius = 1).add_to(m)
        m.save('C:/Users/SDS/Desktop/Downloads/image(longbeach)/{}.html'.format('image'+str(iter)))
    
    return
    
    
    
    
    
    
# 재 군집화, 만나지 않은 군집에 대해 mse계산 후 낮은 mse를 가진 군집끼리 재 결합
def re_cluster(data_, mse):
    '''
    data를 넣으세요
    '''
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
    
