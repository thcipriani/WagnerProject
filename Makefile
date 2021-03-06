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

pages:
	./scripts/make_pages
	./scripts/add_links

build: clean
	# cp -Lr big_images/*.jpg _site/assets/images/
	bundle exec jekyll build --destination '_site'

serve: clean
	bundle exec jekyll serve

clean:
	bundle exec jekyll clean

text: $(addprefix text/, $(notdir $(addsuffix .txt, $(basename $(wildcard flash/*.swf))))) text/raw_text.txt

text/%.txt: flash/%.swf
	swfstrings $< > $@

# use tail rather than cat here to get seperators of the format ==> filename <==
text/raw_text.txt: text/200.txt
	tail -n +1 text/*.txt > raw_text.txt

thumbs:
	s3cmd sync --acl-public thumbs/ s3://wagnercollection.org/images/

deploy: thumbs
	s3cmd sync --exclude '.git/*' --acl-public _site/ s3://wagnercollection.org/
	s3cmd modify --add-header='Content-type:text/css' s3://wagnercollection.org/assets/css/main.css

.PHONY: help text setup build serve pages clean thumbs
