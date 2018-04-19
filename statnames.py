import rsapi as rs
import sys


with open('stats.txt', "w") as f:
	f.write(str(rs.getRawStats(sys.argv[1])))