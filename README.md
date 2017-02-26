TO DO:
- Clickable table of contents for notes
- Stats notes in Python and R? just math?



# *An Introduction to Environmental Statistics using Stan*
A one-day workshop sponsered by the Data Science Initiative, School of Information and Computer Science, in conjuction with the Department of Earth System Science, University of California, Irvine.

Instructors: <br />
Gregory Britten (gbritten@uci.edu) & Yara Mohajerani (ymohajer@uci.edu) <br />
Department of Earth System Science, University of California, Irvine 

# Welcome!
This course is intended to introduce students to the statistical aspects of environmental data from the Bayesian perspective. It's geared toward students who want to make scientific sense of a dataset using models. 

To implement Bayesian models on the computer we will use the software Stan, which is a C++ package specifically designed for the analysis of Bayesian statistical models. It is an easy-to-use program that is rapidly becoming the go-to tool for Bayesian modelers due to its simplicity, generality, and computational efficiency. 

The structure of the course will be as follows:

### Morning
1. Introduction to environmental data and spatial dependence
2. Overview of the Bayesian approach to statistical modeling
3. Crash course in Stan with a linear regression example

### Afternoon
4. Hands-on analysis of Southern California air quality using Stan


# GitHub Table of Contents

## /Statistics/
Here you'll find notes providing introductory mathematical background for the material covered in the course. 
1. Introduction to (Bayesian) Statistics
2. Introduction to Spatial Statistics

## /Data/
This section contains links to download the ozone dataset we'll be working with in the afternoon. You have access to both the raw data as available from the EPA website, along with the processed data that we'll be working with in class. The processing operations involve geographically subsetting for the Southern California region, and combining covariate files (temperature, wind speed, etc.) that are downlaoded separately from the EPA website. For those interested, the R and Python code to perform the processing is available in the folders /R/ and /Python/ as makdat.R and makdat.py files, respectively. 

## /Stan/
This folder contains .stan files that encode the Bayesian models we wish to fit. The models we will consider are as follows

1. **Simple linear regression**

    notebook: *simple_linear_regression.ipynb*

2. **Simple linear regression with spatial autocorrelation**
    
    notebook: *simple_linear_regression_cor.ipynb*

3. **Multiple linear regression with spatial autocorrelation**

    notebook: *simple_linear_regression_cor.ipynb*

4. **Spatial interpolation

    notebook: *interpolation.ipynb*


## /R/ and /Python/
The R and Python code to fit and analyze the models above are contained in separate folders labeled /R/ and /Python/, respectively. Each folder contains a copies of the *.ipynb* files as specific to the language of your choice. 

Each model notebook contains the basic code to fit the model and plot the results, some brief explanatory background along the way, and a number of exercises exercises of varying complexity that extend the basic analysis.  
