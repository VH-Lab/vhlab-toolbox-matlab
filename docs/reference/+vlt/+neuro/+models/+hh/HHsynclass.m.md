# CLASS vlt.neuro.models.hh.HHsynclass

```
  developed by Steve Van Hooser and Ishaan Khurana, with code from 
  _An Introductory Course in Computational Neuroscience_ by Paul Miller


```
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
| *SR* |  |
| *AMPA* |  |
| *NMDA* |  |
| *GABA* |  |
| *E_ESyn* |  |
| *E_ISyn* |  |
| *GLUT_PNQ* |  |
| *ESyn1_times* |  |
| *ESyn2_times* |  |
| *ISyn_times* |  |
| *GABA_PNQ* |  |
| *facilitation* |  |
| *facilitation_tau* |  |
| *V_recovery_time* |  |
| *Total_AMPA_G* |  |
| *Total_NMDA_G* |  |
| *Total_GABA_G* |  |
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
| *HHsynclass* | developed by Steve Van Hooser and Ishaan Khurana, with code from |
| *dsdt* | vlt.neuro.models.hh.HHsynclass/dsdt is a function. |
| *hvar* | vlt.neuro.models.hh.HHsynclass/hvar is a function. |
| *mvar* | vlt.neuro.models.hh.HHsynclass/mvar is a function. |
| *nvar* | vlt.neuro.models.hh.HHsynclass/nvar is a function. |
| *setup_command* | vlt.neuro.models.hh.HHsynclass/setup_command is a function. |
| *setup_synapses* | vlt.neuro.models.hh.HHsynclass/setup_synapses is a function. |
| *simulate* | perform a simulation |
| *statemodifier* | nothing to do in base class |
| *voltage* | vlt.neuro.models.hh.HHsynclass/voltage is a function. |


### Methods help 

**HHsynclass** - *developed by Steve Van Hooser and Ishaan Khurana, with code from*

```
_An Introductory Course in Computational Neuroscience_ by Paul Miller
```

---

**dsdt** - *vlt.neuro.models.hh.HHsynclass/dsdt is a function.*

```
[dsdt, Itot] = dsdt(HHobj, S_value)
```

---

**hvar** - *vlt.neuro.models.hh.HHsynclass/hvar is a function.*

```
h = hvar(HHobj)
```

---

**mvar** - *vlt.neuro.models.hh.HHsynclass/mvar is a function.*

```
m = mvar(HHobj)
```

---

**nvar** - *vlt.neuro.models.hh.HHsynclass/nvar is a function.*

```
n = nvar(HHobj)
```

---

**setup_command** - *vlt.neuro.models.hh.HHsynclass/setup_command is a function.*

```
neuronmodel_obj = setup_command(neuronmodel_obj, varargin)
```

---

**setup_synapses** - *vlt.neuro.models.hh.HHsynclass/setup_synapses is a function.*

```
HHobj = setup_synapses(HHobj)
```

---

**simulate** - *perform a simulation*

```
Help for vlt.neuro.models.hh.HHsynclass/simulate is inherited from superclass VLT.NEURO.MODELS.HH.NEURONMODELCLASS
```

---

**statemodifier** - *nothing to do in base class*

```
Help for vlt.neuro.models.hh.HHsynclass/statemodifier is inherited from superclass VLT.NEURO.MODELS.HH.NEURONMODELCLASS
```

---

**voltage** - *vlt.neuro.models.hh.HHsynclass/voltage is a function.*

```
V = voltage(HHobj)
```

---

