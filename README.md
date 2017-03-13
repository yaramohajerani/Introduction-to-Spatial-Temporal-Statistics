TO DO:
- Clickable table of contents for notes
- Stats notes in Python and R simultaneously? Maybe just list give .stan files as character string inside notes?
- Pre-workshop installation instructions - run a basic model?


# *An Introduction to Environmental Statistics using Stan*
Instructors: <br />
Gregory Britten (gbritten@uci.edu) <br />
Yara Mohajerani (ymohajer@uci.edu) <br />
Department of Earth System Science <br />
University of California, Irvine 



# Welcome!
This course is intended to introduce students to the statistical aspects of environmental data from the Bayesian perspective. It's geared toward students who want to make scientific inference and quantity uncertainty from observed data.

To implement Bayesian models on the computer we will use the software Stan, which is a C++ package specifically designed for the analysis of Bayesian statistical models. It is an easy-to-use program that is rapidly becoming the go-to tool for Bayesian modelers due to its simplicity, generality, and computational efficiency. 

The schedule of the course is as follows:

### Pre-morning (7:30am-8:30am)
- Installation: Please come if ... 

### Morning (8:30am-12:00pm)
- Introduction to environmental data and spatial autocorrelation
- Overview of the Bayesian approach to statistical modeling

Coffee Break 

- Crash course in Stan with a linear regression example

### Lunch (12:00pm-1:00pm)

### Afternoon (1:00pm-5:00pm)
- Hands-on analysis of Southern California air quality using Stan





# Data
The data used in the course are available via the following link: https://www.dropbox.com/sh/wiedyfa4dwjgkfs/AABG83cC9k7QK1StHMMkPHjpa?dl=0. You have access to both the raw data as available from the EPA website, along with the processed data that we'll be working with in class. The processing operations involve geographically subsetting for the Southern California region, and combining covariate files (temperature, wind speed, etc.) that are downlaoded separately from the EPA website. For those interested, the R and Python code to perform the processing is available in the folders /R/ and /Python/ as makdat.R and makdat.py files, respectively. 
*Insert Description*

The files in the folder are as follows:
### Data Files
1. XXX
2. YYY





# GitHub Table of Contents

## /Models/
Here you'll find background notes and Stan code. There are two sets of notes related to background material

### Background Material
1. **Introduction to Bayesian Statistics**
2. **Introduction to Spatial Statistics**

### Models
1. **Simple linear regression**
2. **Simple linear regression with spatial autocorrelation**
3. **Multiple linear regression with spatial autocorrelation**
4. **Spatial interpolation**

## /R/ and /Python/
The R and Python code to fit and analyze the models above are contained in separate folders labeled /R/ and /Python/, respectively. Each folder contains a copies of the *.ipynb* files as specific to the language of your choice. 

Each model notebook contains the basic code to fit the model and plot the results, some brief explanatory background along the way, and a number of exercises exercises of varying complexity that extend the basic analysis.  
