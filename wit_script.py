# Preparing pywit
import wit
import time
import webbrowser
import json

def get_response():
	wit.init()
	wit.voice_query_start('I5FO3XJWG7M5NYLBTDIN44VUQ6YEOBGI') # start recording
	time.sleep(2) # let's speak for 2 seconds
	a = json.loads(wit.voice_query_stop())
	wit.close()
	print(a)
	#return json.loads(a)["outcomes"][0]["entries"]["wikipedia_search_query"][0]["value"]

def search(url):
	url = "https://www.google.com/#q=" + url
	webbrowser.open(url,new=0,autoraise=True)

def main():
	search(get_response())
