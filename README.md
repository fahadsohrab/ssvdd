# Subspace Support Vector Data Description

This repository is for Subspace Support Vector Data Description (S-SVDD). The codes are provided as .m (matlab) files to be executed in matlab. The codes are provided without any warranty or gurantee. Download the package from [HERE](https://github.com/fahadsohrab/ssvdd/archive/main.zip), unzip and add the folder **ssvdd-main** to the path in matlab. see **SSVDDdemo.m** for exmaple usage.
```text
Possible inputs to ssvddtrain()
The first input argument is Training data
other options (input arguments) include

 'maxIter' :Maximim iteraions, Default=100
 'C'       :Value of hyperparameter C, Default=0.1
 'd'       :data in lower dimension, make sure that input d<D, Default=1
 'eta'     :Used as step size for gradient, Default=0.1
 'psi'     :regularization term, Default=1 i.e., No regularization term
           :Other options for psi are 2,3,4 (Please refer to paper for more details)
 'B'       :Default=0.1, Controling the importance of regularization term
 ```
# Example 
```text
ssvddmodel=ssvddtrain(Traindata,'C',0.12,'d',2,'eta',0.02,'psi',3);
[predicted_labels,accuracy,sensitivity,specificity]=ssvddtest(Testdata,testlabels,ssvddmodel); 
```

Please contact fahad.sohrab@tuni.fi for any issues.

# Citation
Please consider citing the following paper.

@inproceedings{sohrab2018subspace,
  title={Subspace support vector data description},
  author={Sohrab, Fahad and Raitoharju, Jenni and Gabbouj, Moncef and Iosifidis, Alexandros},
  booktitle={2018 24th International Conference on Pattern Recognition (ICPR)},
  pages={722--727},
  year={2018},
  organization={IEEE}
}
