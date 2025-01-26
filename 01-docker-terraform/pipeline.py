import pip
import sys
import pandas as pd

message = sys.argv[1]

print(f"Test Docker pipeline. Message: {message}")
print(f"pip version: {pip.__version__}")
