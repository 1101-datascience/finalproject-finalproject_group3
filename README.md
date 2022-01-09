# [Group 3] Sberbank Russian Housing Market

### Groups
* 柯敦瀚	統計四	107304050
* 陳羿丞	資科碩一	110753138
* 蘇俊憲	資科碩一	110753158
* 朱進益	資科碩一	110753144
* 洪丞桀	資科三	108703045


### Goal
Sberbank, Russia’s oldest and largest bank, helps their customers by making predictions about realty prices so renters, developers, and lenders are more confident when they sign a lease or purchase a building.

Giving us dataset, our goal is predicting the price of those asset.

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

* Source:
    * Sberbank Russian Housing Market
    * [Sberbank Russian Housing Market](https://www.kaggle.com/c/sberbank-russian-housing-market)
* Input format:
    * Three .csv file:
        * train.csv
        * test.csv
        * macro.csv
    * Features of dataset:

        Our predict target is "predict_doc" variable.
    This dataset provide large number of data, including house feature like area, floors and location.
    
        It also give us environmental data like green land, coffee shop nearby and how many road near this asset.
    One file call "macro.csv" even provide the government economic data like GDP in Russia or labor income, etc
    
        We find out that most of the data are useless, we've try a lot to fill up those missing data, but it comes out that it better to drop those data. 
    
* Any preprocessing?
  * Handle missing data
      * Remove those data missing rate greater than 35%
      * Fill up some incorrect or odd value with common sense
      * Remove those variables with low correlation coefficient

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
    * [Data Pre-processing](https://www.kaggle.com/arathee2/creating-some-useful-additional-features)
    * [Data Pre-processing 2](https://www.kaggle.com/creatrol/basic-time-series-analysis-feature-selection)
    * [Data Pre-processing 3](https://www.kaggle.com/captcalculator/a-very-extensive-sberbank-exploratory-analysis)
* Packages you use
* Related publications
