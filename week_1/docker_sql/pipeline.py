import sys # in order to make it self-sufficient and not go inside docker to run it

import pandas as pd

print(sys.argv)

day = sys.argv[1]

#something with pandas

print(
    f'job finished successfully for day = {day}!'
)

#from the notebook to a script....in a dirty way

