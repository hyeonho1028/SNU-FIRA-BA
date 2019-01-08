#!/usr/bin/env python
# coding: utf-8

# In[183]:


import pandas as pd
import datetime
from math import *
import collections
import numpy as np


# In[88]:


df1 = pd.read_csv('../../Downloads/clustering.csv')


# In[89]:


df2 = df1[['ETA', 'MMSI3', 'LAT', 'LON', 'SPEED']]
df2.columns = ['ETA', 'MMSI', 'LAT', 'LON', 'SPEED']


# In[90]:


df3 = df2[df2['MMSI'].isin(df2.groupby('MMSI').count()[list(df2.groupby('MMSI').count()['ETA']>100)].reset_index()['MMSI'])].reset_index(drop=True)
df3['ETA'] = df3['ETA'].astype(str).apply(lambda x: x[0:16]+':00')
df3['ETA'] = df3['ETA'].apply(lambda x: datetime.datetime.strptime(x, "%Y-%m-%d %H:%M:%S"))


# In[91]:


df3.to_csv('../../Downloads/clustering_2.csv', index=False)


# In[ ]:





# ### 도착지(어떤 항구)를 기준으로 5km이내 모든 경로 가져오기

# In[97]:


def port_5km(data, lat, lon):
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


# In[99]:


df4 = port_5km(df3, 33.754929, -118.214344)


# In[109]:


def representative_value(data):
    L1 = list()
    for i, j in data.groupby('MMSI').agg({'MMSI': 'unique', 'SPEED': 'count'}).reset_index(drop=True).apply(lambda x: (x['MMSI'][0], x['SPEED']), axis=1).tolist():
        for k in range(0, 11, 1):
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
    
    df.columns = ['MMSI', 'Start_LAT', 'Start_LON', 'rpst_value_LAT1', 'rpst_value_LON1', 'rpst_value_LAT2', 'rpst_value_LON2',
                 'rpst_value_LAT3', 'rpst_value_LON3', 'rpst_value_LAT4', 'rpst_value_LON4', 'rpst_value_LAT5', 'rpst_value_LON5',
                 'rpst_value_LAT6', 'rpst_value_LON6', 'rpst_value_LAT7', 'rpst_value_LON7', 'rpst_value_LAT8', 'rpst_value_LON8',
                 'rpst_value_LA9', 'rpst_value_LON9', 'End_LAT', 'End_LON']
    
    return df


# In[215]:


df5 = representative_value(df4)


# ### scaling

# In[152]:


from sklearn.preprocessing import scale


# In[216]:


df6 = pd.concat([df5[['MMSI']], pd.DataFrame(scale(df5.drop(columns=['MMSI'])))], axis=1)
df6.columns = df5.columns


# In[ ]:





# ### kmeans result sqrt(nrow) iteration

# In[217]:


from sklearn.cluster import KMeans


# In[220]:


# for i in range(2,np.sqrt(df5.shape[0]).astype(int)):
for i in range(2,11):
    kmeans = KMeans(n_clusters=i, random_state=1028).fit(df6.drop(columns=['MMSI']))
    df6['cluster'] = kmeans.labels_
#     print(df6)


# ### 최적의 k 찾는 방법에 대한 고찰

# In[ ]:


1. sqrt(nrow/2)
2. elbow
3. 정보 기준 접근법 (Information Criterion Approach)


# ### elbow

# In[308]:


# SHIPS DATA
X = np.array(df6.iloc[:, 1:])  # extract only the features

ks = range(2,20)

# SSE
SSE = [cluster.KMeans(n_clusters = i, init="k-means++").fit(X).inertia_ for i in ks] 


# In[310]:


from matplotlib import pyplot as plt
plt.plot(list(range(1,len(SSE)+1)), SSE, color='green', marker='o', linestyle='solid')
plt.title('k')
plt.ylabel("SSE")
plt.show()


# ### BIC

# In[304]:


from sklearn import cluster
from scipy.spatial import distance
import sklearn.datasets
from sklearn.preprocessing import StandardScaler
import numpy as np

def compute_bic(kmeans,X):
    """
    Computes the BIC metric for a given clusters

    Parameters:
    -----------------------------------------
    kmeans:  List of clustering object from scikit learn

    X     :  multidimension np array of data points

    Returns:
    -----------------------------------------
    BIC value
    """
    # assign centers and labels
    centers = [kmeans.cluster_centers_]
    labels  = kmeans.labels_
    #number of clusters
    m = kmeans.n_clusters
    # size of the clusters
    n = np.bincount(labels)
    #size of data set
    N, d = X.shape

    #compute variance for all clusters beforehand
    cl_var = (1.0 / (N - m) / d) * sum([sum(distance.cdist(X[np.where(labels == i)], [centers[0][i]], 
             'euclidean')**2) for i in range(m)])

    const_term = 0.5 * m * np.log(N) * (d+1)

    BIC = np.sum([n[i] * np.log(n[i]) -
               n[i] * np.log(N) -
             ((n[i] * d) / 2) * np.log(2*np.pi*cl_var) -
             ((n[i] - 1) * d/ 2) for i in range(m)]) - const_term

    return BIC



# IRIS DATA
iris = sklearn.datasets.load_iris()
X = iris.data[:, :4]  # extract only the features
#Xs = StandardScaler().fit_transform(X)
Y = iris.target

ks = range(2,30)

# run 9 times kmeans and save each result in the KMeans object
KMeans = [cluster.KMeans(n_clusters = i, init="k-means++").fit(X) for i in ks]

# now run for each cluster the BIC computation
BIC = [compute_bic(kmeansi,X) for kmeansi in KMeans]

print(BIC)


# In[305]:


# SHIPS DATA
X = np.array(df6.iloc[:, 1:])  # extract only the features
#Xs = StandardScaler().fit_transform(X)
# Y = iris.target

ks = range(2,20)

# run 9 times kmeans and save each result in the KMeans object
KMeans = [cluster.KMeans(n_clusters = i, init="k-means++").fit(X) for i in ks]

# now run for each cluster the BIC computation
BIC = [compute_bic(kmeansi,X) for kmeansi in KMeans]

# print(BIC)


# In[307]:


from matplotlib import pyplot as plt
plt.plot(list(range(1,len(BIC)+1)), BIC, color='green', marker='o', linestyle='solid')
plt.title('k')
plt.ylabel("BIC")
plt.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




