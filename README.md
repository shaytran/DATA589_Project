# Spatial Point Analysis on Bald Eagle Occurrences in British Columbia
Authors: [Shayla Tran](https://github.com/shaytran), [Kyle Deng](https://github.com/kt1720), and [Matthew Angoh](https://github.com/mattangoh)

### Materials
1. [Final Report](https://docs.google.com/document/d/1DklH4858WhwPIeSn-WrS2D9ETP8_NYhxy3HKNeKvrLc/edit?usp=sharing)

## Table of Contents
1. [Introduction](#introduction)
2. [Methodology](#methodology)
3. [Results & Discussion](#results--discussion)
4. [Conclusion](#conclusion)

## Introduction
This study leverages a dataset of bald eagle (Haliaeetus leucocephalus) occurrences in Canada, obtained from the [Global Biodiversity Information Facility](https://www.gbif.org/occurrence/download/0190555-240321170329656) and aims to analyze bald eagle occurrences to identify potential patterns and trends in their distribution across British Columbia. The study also utilizes environmental covariates specific to BC, including Distance to Water, Human Footprint Index, Forest Coverage, and Elevation to hopefully uncover the underlying relationship between these covariates and the distribution of bald eagles across BC. And hopefully develop a model that can potentially predict eagle occurcences with these covariates to better inform targeted conservation strategies and land-use planning to support habitat protection.

## Methodology
**Data Preparation**
The initial dataset comprises 1,049,411 observations of bald eagles across Canada. After pre-processing the dataset through filtering to BC only observations and removing observations without coordinate information. The dataset size was shrinked to 451,160 observations. Then random sampling without replacement was applied to ensure that subsequent analyses in R could proceed smoothly. Detail of the data pre-processing can be found in the [data_sampling_script.R](https://github.com/shaytran/DATA589_Project/blob/main/data/data_sampling_script.R) file under the data folder. 

**Exploratory data analysis**
The analysis begins with first moment statistics, which includes: 
1. `Intensity Calculation`: The intensity of occurrences, a first moment measure, was computed to estimate the average density of eagle sightings per square kilometer.
2. `Quadrat Testing`: The study area was divided into a 10x10 grid of quadrats to evaluate the spatial uniformity of eagle occurrences using a quadrat test to identify potential clustering.
3. `Kernel Density Estimation`: Using bandwidth selection via likelihood cross-validation, a density map of occurrences was created to visualize and identify hotspots within the region.
4. `Hotspot Analysis`: A scan test was conducted to determine significant clusters of occurrences using a likelihood ratio test statistic.
5. `Spatial correlation (rhohat)`: Estimates the correlation function rho indicating how each covariate influences the spatial pattern of occurrences.

Then proceeds with second moment statistics, which includes:
1. `Ripley’s K-Function`: To examine spatial autocorrelation and aggregation patterns, followed by simulations to create confidence envelopes, allowing for the identification of significant spatial interactions at multiple scales.

Lastly, a Poisson point process model was fit on the eagle point patterns using the covariates to explore the relationship between these covariates and eagle occurrence intensity.

## Results & Discussion
Visual inspection revealed spatial variation in eagle occurrences, with clusters observed in certain areas. Quadrat testing indicated significant deviations from homogeneity, supporting the presence of spatial variation.
![](https://github.com/shaytran/DATA589_Project/blob/main/images/point data.png)
![](https://github.com/shaytran/DATA589_Project/blob/main/images/quadrat.png)

The kernel estimation intensity plot further supports the observed deviation from homogeneity.
![](https://github.com/shaytran/DATA589_Project/blob/main/images/kernel.png)

From the estimation of rhohat, we can see that eagles don't seem to stay around high elevated areas and they typically prefer lower forest coverage (ie. 20%). Interestingly, we can see that there is some elevated intensity of eagle occurrences in areas of higher HFI. As for distance to water, there isn't any notable evidence on whether eagles prefer to be closer to water or not, it seems as if they are rather spread out in areas close and not so close to water. 
![](https://github.com/shaytran/DATA589_Project/blob/main/images/rhohat.png)

The Ripley's K-function corrected for inhomogeneity assumption shows no significant evidence of clustering between eagle occurrences. 
![](https://github.com/shaytran/DATA589_Project/blob/main/images/ripleyk.png)

## Model Comparison and Interpretation
From the analysis of first moment descriptive statistics on bald eagle occurrences, we found that the intensity is inhomogeneous, which indicates that intensity is not constant in space but rather a function of some covariate(s). 
From the estimate of rhohat in the analysis of first moment descriptive statistics, it appears that elevation, HFI and forest coverage exhibit a non-linear relationship with the number of bald eagles. There isn't a relationship between distance to water and the number of bald eagles. So our initial guess of the model is a Poisson process model with both linear and quadratic terms of elevation, HFI and forest coverage. The resulting partial residuals are displayed below:
![](https://github.com/shaytran/DATA589_Project/blob/main/images/initial_pr.png)

The initial guess was fairly decent for HFI levels, but there are some clear complex patterns that are not being captured by the model for elevation and forest coverage. Since the partial residuals suggest a more complex relationships, an appropriate measure we propose is to use splines with some degrees of freedom. The complex model includes a spline function of elevation with 20 degrees of freedom and forest coverage with 10 degrees of freedom, while keeping the HFI parameters the same as the previous model. The resulting partial residuals from the more complex model are displayed below:
![](https://github.com/shaytran/DATA589_Project/blob/main/images/complex_pr.png)

Based on the new partial residuals plot, we can see that this more complex model better captures the trends seen in the data, at least from a visual perspective. There is more of an overlap of the dashed line and the curve.

However, further validation is required in the form of a quadrat test and visualization of all the residuals. After conducting a quadrat test, the p-value was small which indicates that the data significantly deviates from the model. This test indicates that there is definitely some room for improving the model fit.

## Conclusion
The results from this study contribute to our understanding of bald eagle spatial ecology and underscore the importance of considering complex interactions between environmental factors when assessing wildlife distributions. This insight is important for tailoring conservation strategies that accommodate the dynamic nature of wildlife habitats and the varying impacts of human activities. Our research also shows the utility of spatial statistical modeling in ecological studies, giving a framework that can be adapted for similar studies on other species. Future research could expand on this work by adding different environmental variables, such as prey availability or more detailed hydrological data, to further refine our understanding of the factors influencing bald eagle distributions in British Columbia or even beyond.
In conclusion, while our model has demonstrated significant insights into the habitat preferences of bald eagles, the identification of areas where model predictions deviate from observed occurrences suggests areas for improvement. Such efforts will enhance the predictive accuracy of spatial models and the effectiveness of conservation measures tailored to the needs of bald eagles in their natural habitats.


