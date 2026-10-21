import csv,sys,re
from collections import Counter,defaultdict
def cls(h):
    r,g,b=(int(h[i:i+2],16) for i in (1,3,5))
    if h in('#f8f2e4',) or (r-b>=10 and r>=240): return 'ivory'
    if max(r,g,b)-min(r,g,b)<=4 and r<=245: return 'gray'
    if r>=248 and g>=250 and b>=250: return 'white'
    if g-r>=5 and g-b>=3: return 'green'
    if b-r>=5: return 'blue'
    return 'other:'+h
t=defaultdict(Counter)
for row in csv.DictReader(open(sys.argv[1])):
    y=re.search(r'_NS_(\d{4})',row['file']).group(1); c=cls(row['field']); t[y][c]+=1; t['all'][c]+=1
    print(row['file'],c,file=open(sys.argv[2],'a'))
for y in sorted(t): print(y,dict(t[y]))
