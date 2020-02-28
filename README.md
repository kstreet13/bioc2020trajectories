# Trajectory inference and differential expression between conditions in scRNA-seq

# Instructors

 - Kelly Street (kstreet@ds.dfci.harvard.edu)
 - Koen Van den Berge (koenvdberge@berkeley.edu)
 
# Workshop Description

In single-cell RNA-sequencing (scRNA-seq), gene expression is assessed at the level of single cells. In dynamic biological systems, it may not be appropriate to assign cells to discrete groups, but rather a continuum of cell states may be observed, e.g. the differentiation of a stem cell population into mature cell types. This is often represented as a trajectory in reduced dimension.

Many methods have been suggested for trajectory inference. However, in this setting, it is often unclear how one should handle multiple biological groups or conditions, e.g. constructing and comparing the differentiation trajectory of a wild type versus a knock-out stem cell population.

In this workshop, we will explore methods for comparing multiple conditions in a trajectory inference analysis. We start by integrating datasets from multiple conditions into a single trajectory. By comparing the conditions along the trajectory's path, we can detect large-scale changes, indicative of differential progression. We also demonstrate how to detect subtler changes by finding genes that exhibit different behaviors between these conditions along a differentiation path.


## Pre-requisites

Software:

* Basic knowledge of _R_ syntax
* Familiarity with single-cell RNA-sequencing
* Familiarity with the `SingleCellExperiment` class

Background reading:

* The textbook "Orchestrating Single-Cell Analysis with Bioconductor" is a great reference for single-cell analysis using Bioconductor packages.


## Workshop Participation

The workshop will start with an introduction to the problem and the dataset using presentation slides. Following this, we will have a lab session on how one may tackle the problem of handling multiple conditions in trajectory inference and in downstream differential expression analysis.

## _R_ / _Bioconductor_ packages used

* The workshop will focus on Bioconductor packages [SingleCellExperiment](https://bioconductor.org/packages/release/bioc/html/SingleCellExperiment.html), [Slingshot](https://bioconductor.org/packages/release/bioc/html/slingshot.html), and [tradeSeq](https://bioconductor.org/packages/release/bioc/html/tradeSeq.html) 

## Time outline


| Activity                     | Time |
|------------------------------|------|
| Introduction                     | 15m  |
| Data Integration and Trajectory Inference   | 10m  |
| Differential Progression                    | 15m  |
| Differential Expression          | 15m  |
| Wrap-up and Conclusions          | 5m  |


# Workshop goals and objectives

Participants will learn how to reason about trajectories in single-cell RNA-seq data and how they may be used for interpretation of complex scRNA-seq datasets.


## Learning goals


* Reason about dynamic biological systems
* Grasp the complexity of analyzing large scRNA-seq datasets with the goal of extracting relevant biological information 
* Understand the concepts of differential progression and differential expression along a trajectory path

## Learning objectives


* Learn how to analyze single-cell RNA-seq data using Bioconductor packages.
* Import and explore large scRNA-seq datasets.
* Understand the challenges of trajectory inference.
* Compose analysis pipeline that allows interpretation of complex scRNA-seq datasets.
* Assess the added complexity of handling multiple conditions in these dynamic studies and how it influences the analysis pipeline.
* Discuss how the analysis pipeline can incorporate this change and evaluate it.
