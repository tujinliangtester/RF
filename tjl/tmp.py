
import json

a='{"code":1,"msg":"","data":[{"id":13,"growth_level":0,"growth_value":0,"growth_name":"新手上路2","score_rate_qiyou":1,"score_rate_chaiyou":2},{"id":14,"growth_level":1,"growth_value":55,"growth_name":"大众会员","score_rate_qiyou":3,"score_rate_chaiyou":4},{"id":15,"growth_level":2,"growth_value":1000,"growth_name":"白银会员","score_rate_qiyou":5,"score_rate_chaiyou":6},{"id":16,"growth_level":3,"growth_value":3000,"growth_name":"黄金会员","score_rate_qiyou":7,"score_rate_chaiyou":8},{"id":17,"growth_level":4,"growth_value":6000,"growth_name":"铂金会员1","score_rate_qiyou":9,"score_rate_chaiyou":10},{"id":18,"growth_level":5,"growth_value":11000,"growth_name":"钻石会员","score_rate_qiyou":11,"score_rate_chaiyou":12}],"ext":null,"subcode":""}'
b=json.loads(a)

print(b)