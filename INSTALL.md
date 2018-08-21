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
pip3 install -r requirements.txt
```

The sdb-console should now be usable
