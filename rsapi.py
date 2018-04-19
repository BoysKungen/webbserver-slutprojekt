import requests
from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as Soup
import json


jsondata = "http://mooshe.pw/files/items_osrs.json"
plyrurl = "http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player="
geurl = "http://services.runescape.com/m=itemdb_oldschool/viewitem?obj="
STATS = ["Total: ", "Attack: ", "Defense: ", "Strength: ",
 		"Hitpoints: ", "Ranged: ", "Prayer: ", "Magic: ", 
 		"Cooking: ", "Woodcutting: ", "Fletching: ", 
 		"Fishing: ", "Firemaking: ", "Crafting: ","Smithing: ","Mining: ",
 		"Herblore: ","Agility: ","Thieving: ", "Slayer: ", "Farming: ", "Runecrafting: " ,"Hunter: ", "Construction: "]

def getStats(name : str):
	data = requests.get(plyrurl + name)
	soup = str(Soup(data.content, "html.parser"))
	arr = soup.split(',')
	statarray = []
	i = 1
	statindex = 0
	for i in range(len(arr)):
		if i%2 == 1:
			try:
				statarray.append(STATS[statindex]+arr[i])
				statindex += 1
				i += 2
				#returns array of all the levels of a player(name)
			except:
				pass
	return statarray

def getRawStats(name : str):
	data = requests.get(plyrurl + name)
	soup = str(Soup(data.content, "html.parser"))
	arr = soup.split(',')
	statarray = []
	i = 1
	for i in range(len(arr)):
		if i%2 == 1:
			try:
				if int(arr[i]) >= 0:
					statarray.append(int(arr[i]))
					i += 2
			except:
				pass
	return statarray


def getItemInfo(itemname):
	data = requests.get(jsondata)
	soup = Soup(data.content, "html.parser")
	arr = []
	try:
		jsonfile = json.loads(str(soup))
	except:
		pass
	for i in range(len(jsonfile)):
		try:
			if itemname.lower() in jsonfile[str(i)]["name"].lower():
				arr.append(str(i))
				arr.append(jsonfile[str(i)])
				#each even position is the ID for the jsondict
				#each odd position is the jsondict with the information
				#you can access the information in the dict by writing something like:
				#getIteminfo("copper")[1]["name"]
				break
		except:
			pass
	return arr


def getStatList():
	return [ "Total: ", "Attack: ", "Defense: ", "Strength: ",
 		"Hitpoints: ", "Ranged: ", "Prayer: ", "Magic: ", 
 		"Cooking: ", "Woodcutting: ", "Fletching: ", 
 		"Fishing: ", "Firemaking: ", "Crafting: ","Smithing: ","Mining: ",
 		"Herblore: ","Agility: ","Thieving: ", "Slayer: ", "Farming: ", "Runecrafting: " ,"Hunter: ", "Construction: "]
