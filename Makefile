# Use bash script to grab swfs 1..100
# Commented out because I don't want this to run everytime and I don't feel
# like adding sometihng fancy in all:
#
# PHONY: swfs

# swfs:
# 	bash ./scripts/grab_swfs
# 	bash ./scripts/move_swfs
help:
	@echo Usage: make <setup|text|build|serve>

setup:
	bundle || gem install bundler --no-rdoc --no-ri
	bundle install

build:
	# cp -Lr big_images/*.jpg _site/assets/images/
	bundle exec jekyll build --destination '_site'

serve:
	bundle exec jekyll serve

text: $(addprefix text/, $(notdir $(addsuffix .txt, $(basename $(wildcard flash/*.swf))))) text/raw_text.txt

text/%.txt: flash/%.swf
	swfstrings $< > $@

# use tail rather than cat here to get seperators of the format ==> filename <==
text/raw_text.txt: text/200.txt
	tail -n +1 text/*.txt > raw_text.txt

.PHONY: help text setup build serve
