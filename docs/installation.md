# Installation:

## Recommended method:

vhlab-toolbox-matlab is installed as a part of the Neuroscience Data Interface ([NDI](http://neurodatainterface.org)). The easiest way is to install it with the
NDI installer as described here. 

1. Make sure `git` is installed on your machine. If it is not, on Windows, go [here](https://git-scm.com/download/win). On Mac, open a terminal, and type xcode-select --install . Accept the license and wait for install. On Linux, consult your Linux distribution's package manager.

2. Download the file [ndi_install.m](https://raw.githubusercontent.com/VH-Lab/NDI-matlab/master/ndi_install.m) to your Desktop.
 
3. Run the following in Matlab: 

    `cd ~/Desktop`

    `ndi_install`


## Manual method:

1. Run the following on your terminal command line: `git clone http://github.com/VH-Lab/vhlab-toolbox-matlab`

2. You'll need a Matlab startup.m file. Add the command `vlt_Init` to that file, after ensuring that the directory for vhlab-toolbox-matlab is on your Matlab path. (All of these steps are taken care of via the automatic installation above.)




