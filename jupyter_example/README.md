# Jupyter Notebook Example

## Additonal Prequisites 

You will need Python 3 installed on your machine. For install instructions specfic to your machine see: [https://www.python.org/downloads/](https://www.python.org/downloads/)

With Python 3 create and activate a virtual environment in this directory (_jupyter_example_) with:

```
	$ python -m venv env
	$ source env/bin/activate
```

Install Jupyter Notebook with:

```
	(env) $ python -m venv env
	(env) $ source env/bin/activate
```

You will also need to install operating system specific dependencies (i.e. ZeroMQ) per the instructions found on this page [https://github.com/SciRuby/iruby](https://github.com/SciRuby/iruby)

**Ubuntu 17.04 to 19.04**
```
	(env) $ sudo apt install libtool libffi-dev ruby ruby-dev make
	(env) $ sudo apt install libzmq3-dev libczmq-dev
```

**Ubuntu 16.04**
```
	(env) $ sudo apt install libtool libffi-dev ruby ruby-dev make
	(env) $ sudo apt install git libzmq-dev autoconf pkg-config
	(env) $ git clone https://github.com/zeromq/czmq
	(env) $ cd czmq
	(env) $ ./autogen.sh && ./configure && sudo make && sudo make install

	(env) $ gem install cztop
```

**Windows**
```
	(env) $ pacman -S mingw64/mingw-w64-x86_64-zeromq
```

**Mac (with [Homebrew](https://brew.sh/))**
```
	(env) $ brew install automake gmp libtool wget
	(env) $ brew install zeromq --HEAD
	(env) $ brew install czmq --HEAD
```


Finally Set up your Ruby dependencies with:
```
	(env) $ bundle install
	(env) $ bundle update
	(env) $ iruby register --force
```

## Tutorial

Next, run the following to open a notebook that will open in a browser window:

	(env) $ iruby notebook 'WorkflowTutorial.ipynb'

The text in this notebook will guide you through the rest of the tutorial.