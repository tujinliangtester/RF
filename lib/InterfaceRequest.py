import requests
import config.ConfigReader

class InterfaceRequest(object):
    def __init__(self):
        print(1)
    def interface_get(self,url,params,headers):
        url=config.ConfigReader.get('interface','baseurl')+'/'+url
        response=requests.get(url,headers=headers,params=params)
        print(response.text)


if __name__=='__main__':
    IR=InterfaceRequest()
    params={'from':'en','to':'zh','query':'happy'}
    IR.interface_get(url='v2transapi',headers=None,params=params)
