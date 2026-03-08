# env_loader.py
from dotenv import load_dotenv
import os

def load_environment_variables():
    load_dotenv()
    # You can also return a dictionary of variables if needed,
    # but loading them to os.environ allows direct access in Robot Framework
