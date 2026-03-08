import os
from dotenv import load_dotenv

project_root = os.path.abspath(os.path.join(os.getcwd()))
dotenv_path = os.path.join(project_root, '.env')
print("project_root =", project_root)
print("dotenv_path =", dotenv_path)

load_dotenv(dotenv_path=dotenv_path)
# print("JIRA_TOKEN =", os.getenv("JIRA_TOKEN"))
