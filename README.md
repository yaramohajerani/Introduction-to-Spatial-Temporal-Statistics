# Welcome to Environmental Statistics using Stan
This one-day short course will introduce students to the statistical aspects of environmental science from the Bayesian perspective. To implement Bayesian models we will use the software Stan, which is a C++ package specifically designed for estimating the parameters of Bayesian models.


# GitHub Table of Contents

## Statistics Notes for Background
Here you'll find notes providing introductory mathematical background for the material covered in the course. 
1. Introduction to (Bayesian) Statistics
2. Introduction to Spatial Statistics

## Data
This section contains links to download the ozone dataset we'll be working with in the afternoon. You have access to both the raw data as available from the EPA website, along with the processed data that we'll be working with in class. The processing operations involve geographically subsetting for the Southern California region, and combining covariate files (temperature, wind speed, etc.) that are downlaoded separately from the EPA website. For those interested, the R and Python code to perform the processing is available in the folders /R/ and /Python/ as makdat.R and makdat.py files, respectively. 

## Models
The code for fitting and analyzing Stan models are arranged as follows. The .stan files are contained separately in the /stan/ folder, while the R and Python code to fit and analyze those models are contained in separate folders labeled /R/ and /Python/, respectively.

The models we will consider are as follows

1. Simple linear regression
    
   notebook: simple_linear_regression.ipynb

2. Simple linear regression with spatial autocorrelation
2. Multiple linear regression
3. Spatial interpolation
4. Model comparison

