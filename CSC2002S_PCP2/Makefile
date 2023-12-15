# Makefile
# Rector Ratsaka
# RTSREC001
# 15 August 2023

BINDIR = bin
SRCDIR = src
JAVAC = javac

# Define a rule to compile Java classes
$(BINDIR)/%.class: $(SRCDIR)/%.java
	@mkdir -p $(dir $@)
	$(JAVAC) -d $(BINDIR) -cp $(BINDIR) -sourcepath $(SRCDIR) $<

# List of Java classes to compile
CLASSES = clubSimulation/GridBlock.java clubSimulation/PeopleLocation.java clubSimulation/PeopleCounter.java clubSimulation/ClubGrid.java clubSimulation/Clubgoer.java clubSimulation/CounterDisplay.java clubSimulation/ClubView.java clubSimulation/ClubSimulation.java

# Convert .java filenames to .class targets
CLASS_TARGETS = $(CLASSES:%.java=$(BINDIR)/%.class)

# default rule(make)
all: $(CLASS_TARGETS)

# clean docs and class files(make clean)
clean:
	rm -rf $(BINDIR)/clubSimulation/*.class

# run ClubSimulation main class
run:
	java -cp $(BINDIR) clubSimulation/ClubSimulation $(ARGS)
