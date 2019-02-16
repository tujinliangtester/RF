import requests

class InterfaceRequest(object):
    def __init__(self):
        print(1)
    def get(self,url,params,headers):
        response=requests.get(url,headers=headers,params=params)
        print(response)


if __name__=='__main__':
    IR=InterfaceRequest()
    params={'from':'en','to':'zh','query':'happy'}
    IR.get(url='https://fanyi.baidu.com/v2transapi',headers=None,params=params)
