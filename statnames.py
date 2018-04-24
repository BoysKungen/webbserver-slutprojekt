import rsapi as rs
import sys


with open('stats.txt', "w") as f:
	string = ""
	print(sys.argv)
	for x in sys.argv:
		if sys.argv.index(x) == 0:
			continue
		elif sys.argv.index(x) != len(sys.argv):
			string += x + " "
		else:
			string += x
	f.write(str(rs.getRawStats(string)))