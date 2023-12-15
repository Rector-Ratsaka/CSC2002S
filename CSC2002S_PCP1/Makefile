# Makefile
# Rector Ratsaka
# RTSREC001
# 04 August 2023

BINDIR = bin
SRCDIR = src
JAVAC = javac

# Define a rule to compile Java classes
$(BINDIR)/%.class: $(SRCDIR)/%.java
	@mkdir -p $(dir $@)
	$(JAVAC) -d $(BINDIR) -cp $(BINDIR) -sourcepath $(SRCDIR) $<

# List of Java classes to compile
CLASSES = MonteCarloMini/SearchParallel.java MonteCarloMini/TerrainArea.java  MonteCarloMini/MonteCarloMinimizationParallel.java

# Convert .java filenames to .class targets
CLASS_TARGETS = $(CLASSES:%.java=$(BINDIR)/%.class)

#default rule(make)
all: $(CLASS_TARGETS)

# clean docs and class files(make clean)
clean:
	rm -rf $(BINDIR)/MonteCarloMini/*.class

#run Graph.java(make run ARGS="args[0] args[1] args[2] args[3] args[4] args[5] args[6]")
run:
	java -cp $(BINDIR) MonteCarloMini/MonteCarloMinimizationParallel $(ARGS)
