# CLASS vlt.neuro.models.hh.HHclass

  developed by Steve Van Hooser and Ishaan Khurana, with code from 
  _An Introductory Course in Computational Neuroscience_ by Paul Miller

## Superclasses
**[vlt.neuro.models.hh.neuronmodelclass](neuronmodelclass.m.md)**

## Properties

| Property | Description |
| --- | --- |
| *E_Na* |  |
| *V_threshold* |  |
| *spiketimes* |  |
| *spikesamples* |  |
| *E_K* |  |
| *G_L* |  |
| *G_Na* |  |
| *G_K* |  |
| *Na_Inactivation_Enable* |  |
| *TTX* |  |
| *TEA* |  |
| *Cm* |  |
| *Rm* |  |
| *E_leak* |  |
| *dt* |  |
| *t_start* |  |
| *t_end* |  |
| *f* |  |
| *samplenumber_current* |  |
| *update_method* |  |
| *S* |  |
| *I* |  |
| *t* |  |
| *command* |  |
| *step1_time* |  |
| *step2_time* |  |
| *step1_value* |  |
| *step2_value* |  |
| *involtageclamp* |  |
| *V_initial* |  |


## Methods 

| Method | Description |
| --- | --- |
| *HHclass* | developed by Steve Van Hooser and Ishaan Khurana, with code from |
| *dsdt* | vlt.neuro.models.hh.HHclass/dsdt is a function. |
| *hvar* | vlt.neuro.models.hh.HHclass/hvar is a function. |
| *mvar* | vlt.neuro.models.hh.HHclass/mvar is a function. |
| *nvar* | vlt.neuro.models.hh.HHclass/nvar is a function. |
| *setup_command* | vlt.neuro.models.hh.HHclass/setup_command is a function. |
| *simulate* | perform a simulation |
| *statemodifier* | nothing to do in base class |
| *voltage* | vlt.neuro.models.hh.HHclass/voltage is a function. |


### Methods help 

**HHclass** - *developed by Steve Van Hooser and Ishaan Khurana, with code from*

_An Introductory Course in Computational Neuroscience_ by Paul Miller


---

**dsdt** - *vlt.neuro.models.hh.HHclass/dsdt is a function.*

[dsdt, Itot] = dsdt(HHobj, S_value)


---

**hvar** - *vlt.neuro.models.hh.HHclass/hvar is a function.*

h = hvar(HHobj)


---

**mvar** - *vlt.neuro.models.hh.HHclass/mvar is a function.*

m = mvar(HHobj)


---

**nvar** - *vlt.neuro.models.hh.HHclass/nvar is a function.*

n = nvar(HHobj)


---

**setup_command** - *vlt.neuro.models.hh.HHclass/setup_command is a function.*

neuronmodel_obj = setup_command(neuronmodel_obj, varargin)


---

**simulate** - *perform a simulation*

Help for vlt.neuro.models.hh.HHclass/simulate is inherited from superclass VLT.NEURO.MODELS.HH.NEURONMODELCLASS


---

**statemodifier** - *nothing to do in base class*

Help for vlt.neuro.models.hh.HHclass/statemodifier is inherited from superclass VLT.NEURO.MODELS.HH.NEURONMODELCLASS


---

**voltage** - *vlt.neuro.models.hh.HHclass/voltage is a function.*

V = voltage(HHobj)


---

