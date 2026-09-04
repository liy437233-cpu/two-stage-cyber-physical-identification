# Two-Stage Cyber-Physical Source Identification

Reference implementation of the two-stage cyber–physical source-identification framework described in the associated paper.

## Scope

This repository contains:

- two-stage classification;
- class-run weighting;
- grouped out-of-fold logistic calibration;
- hierarchical probability fusion; and
- five-state prediction.

The feature-ranking order is supplied externally; this reference implementation does not attribute the ranking to an unverified named algorithm.

For Stage 2, the motor-fault coefficient is supplied explicitly. The paper evaluated values of 1.0 and 1.5 within fold-local model selection. The example setting uses one permitted value only to run the code and does not represent a universal frozen value across the reported outer folds.

## Exclusions

The repository does not include experimental data, derived datasets, trained model artifacts, proprietary CAN mappings, or vehicle-specific signal definitions.

## Reproducibility boundary

The repository provides the method implementation only. The numerical experimental results reported in the paper cannot be reproduced without the restricted experimental dataset.

## Example input

The example input is an illustrative numeric matrix used only to exercise the software pipeline. It is not experimental data and does not represent the automotive HIL system. It has generic features `F001` through `F264`, generic group and run identifiers, and no external file input.

Run from the repository root:

```matlab
cd('path_to_repository')
output = main_example;
```

`output.evaluation` contains class names, predicted labels, and a confusion matrix. It is provided only for software-path validation.

## MATLAB requirements

- MATLAB R2023b or later
- Statistics and Machine Learning Toolbox

## License

This repository is distributed under the MIT License.
