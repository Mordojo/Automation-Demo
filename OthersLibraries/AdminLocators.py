import json
import jsonpath

def read_locator_from_json(locatorName):
	f = open(C:/Users/Corallo/eclipse-workspace/AutomationDemo/Files/AdminElements.json,'r')
	response = json.loads(f.read())
	value = jsonpath.jsonpath(response,locatorName)
	return value[0]