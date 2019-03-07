import time
import xlrd,xlwt
import sys,os
class tools(object):
    def gene_mobile(self):
        s=time.strftime("%Y%m%d%H%M", time.localtime())
        s=s[-8:]
        s='199'+s
        print(s)
        return s

    def read_data(self,key):
        path=os.path.join(os.path.dirname(__file__),'../config/setting.xlsx')
        tmp_dic={}
        wb=xlrd.open_workbook(path)
        ws=wb.sheet_by_name('Sheet3')
        i=2
        try:
            while(i<20):
                tmp_key=ws.cell_value(i,1)
                if(tmp_key is None):
                    break
                tmp_dic[tmp_key]=ws.cell_value(i,2)
                i+=1
        except Exception:
            print(Exception)

        return  tmp_dic[key]
    def write_data(self,s):
        path = os.path.join(os.path.dirname(__file__), '../config/setting.xlsx')
        tmp_dic = {}
        wb = xlwt.Workbook(path)
        ws = wb.sheet_index('Sheet3')



if __name__=='__main__':
    t=tools()
    t.gene_mobile()
    print(t.read_data('mobile'))