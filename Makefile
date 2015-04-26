# Use bash script to grab swfs 1..100
# Commented out because I don't want this to run everytime and I don't feel
# like adding sometihng fancy in all:
#
# PHONY: swfs

# swfs:
# 	bash ./scripts/grab_swfs
# 	bash ./scripts/move_swfs

all: $(addprefix text/, $(notdir $(addsuffix .txt, $(basename $(wildcard pages/*.swf))))) raw_text.txt

text/%.txt: pages/%.swf
	swfstrings $< > $@

# use tail rather than cat here to get seperators of the format ==> filename <==
raw_text.txt: text/200.txt
	tail -n +1 text/*.txt > raw_text.txt