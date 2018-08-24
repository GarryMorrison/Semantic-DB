# Semantic-DB Installation instructions

Currently, these instructions have only been tested on ubuntu bionic.

The Semantic DB requires tkinter, an external dependency. To install tkinter
on ubuntu bionic, do:

```bash
sudo apt install python3-tk
```

The Semanic DB needs to be cloned from github to be used as of now:

```bash
git clone https://github.com/GarryMorrison/Semantic-DB.git
cd Semantic-DB
pip3 install .
```

Graphviz can be used to plot sw files as dot graphs.
If you need this feature, graphviz can be installed using [this guide](https://enterprise-architecture.org/downloads?id=208),
(The guide is from another project, but is still applicable to our case),
and the python binding can be installed by running:
```bash
pip3 install .[Graph]
```
(Do note the dot before [Graph])

The sdb-console should now be usable
