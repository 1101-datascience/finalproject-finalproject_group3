# [Group 3] Sberbank Russian Housing Market

### Groups
*?Ÿ¯?•¦?€?	çµ±è?ˆå??	107304050
*?™³ç¾¿ä??	è³‡ç?‘ç¢©ä¸€	110753138
*??‡ä?Šæ†²	è³‡ç?‘ç¢©ä¸€	110753158
*?œ±?€²ç??	è³‡ç?‘ç¢©ä¸€	110753144
*æ´ªä?žæ?€	è³‡ç?‘ä??	108703045


### Goal
Housing costs demand a significant investment from both consumers and developers. And when it comes to planning a budget?€”whether personal or corporate?€”the last thing anyone needs is uncertainty about one of their biggets expenses. Sberbank, Russia?€™s oldest and largest bank, helps their customers by making predictions about realty prices so renters, developers, and lenders are more confident when they sign a lease or purchase a building.

Although the housing market is relatively stable in Russia, the country?€™s volatile economy makes forecasting prices as a function of apartment characteristics a unique challenge. Complex interactions between housing features such as number of bedrooms and location are enough to make pricing predictions complicated. Adding an unstable economy to the mix means Sberbank and their customers need more than simple regression models in their arsenal.

### Demo 
You should provide an example commend to reproduce your result
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```
* any on-line visualization

## Folder organization and its related information

### docs
* Your presentation, 1101_datascience_FP_<yourID|groupName>.ppt/pptx/pdf, by **Jan. 13**
* Any related document for the final project
  * papers
  * software user guide

### data

* Source
    *Sberbank Russian Housing Market
    *[Sberbank Russian Housing Market](https://www.kaggle.com/c/sberbank-russian-housing-market)
* Input format
    *Three .csv file
    *Features of dataset:
    Our predict target is "predict_doc" variable.
    This dataset provide large number of data, including house feature like area, floors and location.
    It also give us environmental data like green land, coffee shop nearby and how many road near this asset.
    One file call "macro.csv" even provide the government economic data like GDP in Russia or labor income, etc
    We find out that most of the data are useless, we've try a lot to fill up those missing data, but it comes out that it better to drop those data. 
    
* Any preprocessing?
  * Handle missing data
      *1) Remove those data missing rate greater than 35%
      *2) Fill up some incorrect or odd value with common sense

### code

* Which method do you use?
* What is a null model for comparison?
* How do your perform evaluation? ie. cross-validation, or addtional indepedent data set

### results

* Which metric do you use 
  * precision, recall, R-square
* Is your improvement significant?
* What is the challenge part of your project?

## References
* Code/implementation which you include/reference (__You should indicate in your presentation if you use code for others. Otherwise, cheating will result in 0 score for final project.__)
* Packages you use
* Related publications
