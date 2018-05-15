#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 30 16:24:13 2018
@author: Prashant Verma
"""
import pandas as pd
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot
from plotly.graph_objs import *
from plotly import tools
import cgi
#from fcgi import WSGIServer
dataset = pd.read_csv('zvesta.Amenity_Rating.csv' )
dataset2 = pd.read_csv('project-locations-11may2018.csv')
#rand = random.choice(['Gurugram', 'others'])
form  = cgi.FieldStorage()
location = form.getvalue('loc')
print(location)
df_gur, Y_data = pd.DataFrame(), pd.DataFrame()
#rand ='Gurugram'
if location is not None:
    for n in range(len(dataset2)):
        X_data =dataset2[dataset2['city_name'].str.contains(location)]
        project_id = X_data['project_id']
        for k in range(len(dataset)):
            try:
                if (dataset.iloc[:, 0]==project_id[k]).any():
                    Y_data = dataset[dataset.iloc[:, 0]==project_id[k]]
                    df_gur =pd.concat([df_gur, Y_data], axis =0, ignore_index =True)
            except:
                print('Project_id _Missing')
        break
          
    X= df_gur.iloc[:, 1]
    y = df_gur.iloc[:, 2]
    trace1 = Scatter(x =X[:], y = y[:], name = 'Project wise Rating', mode = 'markers', fill = 'tonexty'  )  
    layout = Layout(title = 'Project wise Rating')
    data =[trace1]
    frames=[dict(data= [dict(x=X[:(k*20)+1], y=y[:(k*20)+1])], traces= [0], name='frame{}'.format(k) 
    ) for k  in  range(1, len(X))]
    config={'showLink': False}
    fig = Figure(data =data, layout = layout, frames =frames)
    plot(fig, config =config, filename = 'bar-line.html')

else:
    X = dataset.iloc[:, 1]
    y = dataset.iloc[:, 2]
    trace1 = Scatter( x =X[:], y = y[:], name = 'Project wise Rating', mode = 'markers', fill = 'tonexty')  
    layout = Layout(title = 'Project wise Rating')
    data =[trace1]
    frames=[dict(data= [dict(x=X[:(k*20)+1],
                         y=y[:(k*20)+1])], traces= [0], name='frame{}'.format(k) ) for k  in  range(1, len(X))]
    config={'showLink': False}
    fig = Figure(data =data, layout = layout, frames =frames)
    plot(fig, config =config, filename = 'bar-line.html')

