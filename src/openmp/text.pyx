from cython.parallel import prange
import pandas as pd
from timeit import default_timer as timer


def countWord(artLine,word):
    cdef int i
    cdef int count = 0
    words = artLine.split(" ")
    for i in prange(len(words), nogil=True):
        if(words[i] == word):
            count += 1

def text_analysis():
    try:
        word = ""
        while(word != "/"):
            word = input("Ingrese la palabra, para salir ingrese \"/\" : " )
            if word == "/":
                return 0
            start = timer()
            articles = pd.read_csv("/opt/datasets/articles1.csv",usecols=[1,2,9])
            articles1 = pd.read_csv("/opt/datasets/articles2.csv",usecols=[1,2,9])
            articles2 = pd.read_csv("/opt/datasets/articles3.csv",usecols=[1,2,9])
            articlesFinal = pd.concat([articles, articles1, articles2])
            #Normalizing the words
            lowerCount = articlesFinal["content"].str.count(word.lower())
            upperCount = articlesFinal["content"].str.count(word.upper())
            capitalizeCount = articlesFinal["content"].str.count(word.capitalize())
            #Reducing the results
            articlesFinal["frec"] = lowerCount+upperCount+capitalizeCount    
            #Sort
            articlesFinal = articlesFinal.sort_values(by='frec',ascending=False)
            end = timer()
            calculationTime = end-start
            print(articlesFinal.iloc[0:10,[3,0,1]])
            print("Time for word "+word+" is :" + str(calculationTime) + " seconds")
    except Exception as e:
        print("ERROR "+str(e))
        text_analysis()

text_analysis()