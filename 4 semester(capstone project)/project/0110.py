def users_kmeans(data, cluster_name):
    
    if data.shape[0] == 1:
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

            df2_sse = round(sum([i**2 for i in df2.iloc[:, 1:].loc[0] - df2.iloc[:, 1:].describe().loc['mean']]), 2)
            df3_sse = round(sum([i**2 for i in df3.iloc[:, 1:].loc[0] - df3.iloc[:, 1:].describe().loc['mean']]), 2)


            if df2_sse < prune_criteria and df3_sse < prune_criteria:
                data[cluster_name] = 2
                return data

            elif df2_sse < prune_criteria:
                df2[cluster_name] = 2
                return df1

            elif df3_sse < prune_criteria:
                df3[cluster_name] = 2
                return df1

            else:
                return df1




def auto_clustering(mmsi_data):
    
    data = copy.deepcopy(mmsi_data)
    
    iter = 1
    cluster_rt = pd.DataFrame()
    
    while True:
        if iter == 1:
            cluster_pd = pd.DataFrame()
            cluster_name = 'cluster'+ str(iter)
            
            df1 = users_kmeans(data, cluster_name)
            
            cluster_pd = pd.concat([cluster_pd, df1[[cluster_name]]], axis=1)
            cluster_pd = cluster_pd.astype('str').apply(lambda x: ''.join(x), axis=1)
            
            cluster_rt = pd.DataFrame({cluster_name : cluster_pd}) 
            
        elif iter > 1:
            cluster_pd = pd.DataFrame()
            cluster_name = 'cluster'+ str(iter)
            data['cluster_prediction'] = cluster_rt
            
            for i in np.unique(cluster_rt):
                df1 = users_kmeans(data[data['cluster_prediction'] == i].drop(columns=['cluster_prediction']), cluster_name)
                
                cluster_pd = pd.concat([cluster_pd, df1[[cluster_name]]], axis=1)
                
            else:
                cluster_rt = pd.concat([cluster_rt, cluster_pd.astype(str).apply(lambda x: ''.join(x), axis=1).apply(lambda x: x.replace('nan', '')).astype(float).astype(int).astype(str)], axis=1).apply(lambda x: ''.join(x), axis=1)
                
            
            if all(cluster_rt.apply(lambda x: x[-1]=='2')):
                break
            
            
        iter+=1
    
    unique_cluster = np.unique(data.cluster_prediction)
    data = pd.merge(data, pd.DataFrame({'cluster_prediction':unique_cluster, 'b':range(1, len(unique_cluster)+1)}), how='left', on='cluster_prediction')
    data['cluster_prediction'] = data['b']
    data = data.drop(columns='b')
    
    return data

out_table = auto_clustering(table[0])
