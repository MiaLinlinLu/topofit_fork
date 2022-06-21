# TopoFit

TopoFit is a learning-based tool that rapidly fits a topologically-correct surface to cerebral cortex in brain MRI. This code base implements the model described in the following [paper](https://openreview.net/forum?id=-JiHeZNDY3a):

> TopoFit: Rapid Reconstruction of Topologically-Correct Cortical Surfaces<br>
> Andrew Hoopes, Juan Eugenio Iglesias, Bruce Fischl, Douglas Greve, Adrian V. Dalca<br>
> Medical Imaging with Deep Learning. 2022.<br>

To evaluate a pretrained TopoFit model, you can [download the development version](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall) of FreeSurfer and run the `mris_estimate_wm` command line tool. However, to develop and train a TopoFit model using custom data, clone this repository and follow the instructs below.

### Download file requirement

The guided (or neighborhood-based) training loss requires a 500MB neighorhood mapping file that is too large to store on GitHub. In order to train a model, you must download [neighorhoods.npz](https://surfer.nmr.mgh.harvard.edu/ftp/data/topofit/neighborhoods.npz) and move it to the `topofit` subdirectory of this repository.

### Preprocessing

Brain surface data needs to be preprocessed so that all 'ground-truth' meshes share the same template topology. First, FreeSurfer's `recon-all` command must be run on each subject's T1w brain MRI. Following this, the `preprocess` script must be run on each recon output:

```
./preprocess /path/to/recon/subject
```

This will generate additional surface files in the subject's `surf` subdirectory.

### Training

Once surfaces have been preprocessed, a TopoFit model is trained for a given brain hemisphere (`lr` or `rh`) with:

```
./train --hemi lh \
        --outdir /path/to/output/directory \
        --training-subjs /path/to/train.txt \
        --validation-subjs /path/to/validation.txt
```

In this example, `train.txt` and `validation.txt` are line-by-line lists of full paths to preprocessed recon subjects. Subjects will be randomly sampled from this list during training. Only 5-20 validation subjects are necessary. This script implements a learning-rate decay strategy based on the validation distance metric. Training will exit automatically once accuracy plateaus. In general, training should complete between 2000-3000 epochs. Logging and model weight checkpoints will be saved to the specified output directory.

### Evaluation

Once a model has been trained, it can be evaluated on any set of recon-all subjects by running:

```
./evaluate --hemi lh \
           --model /path/to/output/directory/2000.pt \
           --subjs /path/to/recon/subject ...
```

This will save the predicted FreeSurfer-formatted surface as `lh.white.topofit` in the subject's `surf` subdirectory.

# Docker and singularity
A Dockerfile recipe exists in the docker folder of this repository build commands for docker and singularity exist in the readme in that folder. A more specific readme exists in that directory.

Several singularity example run scripts exist in the singularity_run folder of this repository. A more specific readme exists in that folder as well. 
