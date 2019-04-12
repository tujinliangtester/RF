import chardet
import json
s = '{"code":1,"message":"绯荤粺閿欒","data":null}'
print()

try:
    s='{"name": "tjl1441", "start_time": "2019-04-11 00:00:00", "end_time": "2019-04-13 23:59:59", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{"amt":"","zs_value":"","max_count":0}]", "coupon_item": "[{"amt":"1","coupon_id":651,"num":"1"},{"amt":"2","coupon_id":652,"num":"2"}]"}'
    j=json.loads(s)
    print(type(j))
except Exception as e:
    print(str(e))

try:
    s='{"name": "tjl1441", "start_time": "2019-04-11 00:00:00", "end_time": "2019-04-13 23:59:59", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{\"amt\":\"\",\"zs_value\":\"\",\"max_count\":0}]", "coupon_item": "[{\"amt\":\"1\",\"coupon_id\":651,\"num\":\"1\"},{\"amt\":\"2\",\"coupon_id\":652,\"num\":\"2\"}]"}'
    j=json.loads(s)
    print(j)
except Exception as e:
    print(str(e))

try:
    s="{'name': 'tjl1441', 'start_time': '2019-04-11 00:00:00', 'end_time': '2019-04-13 23:59:59', 'discount_type': '1', 'max_count': '0', 'status': '1', 'activity_type': '1', 'activity_item': '[{'amt':'','zs_value':'','max_count':0}]', 'coupon_item': '[{'amt':'1','coupon_id':651,'num':'1'},{'amt':'2','coupon_id':652,'num':'2'}]'}"
    j=json.loads(s)
    print(j)
except Exception as e:
    print(str(e))

try:
    s='{"name": "tjl1441", "start_time": "2019-04-11 00:00:00", "end_time": "2019-04-13 23:59:59", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{\\"amt\\":\\"\\",\\"zs_value\\":\\"\\",\\"max_count\\":0}]", "coupon_item": "[{\\"amt\\":\\"1\\",\\"coupon_id\\":651,\\"num\\":\\"1\\"},{\\"amt\\":\\"2\\",\\"coupon_id\\":652,\\"num\\":\\"2\\"}]"}'
    j=json.loads(s)
    print(j)
except Exception as e:
    print(str(e))