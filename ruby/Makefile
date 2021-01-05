.PHONY: test repl shell

test:
	docker run -it \
	-w /var/app \
	-v `pwd`:/var/app \
	ruby:alpine \
	ruby -I lib:test test_election.rb -p

repl:
	docker run -it \
	-w /var/app \
	-v `pwd`:/var/app \
	ruby:alpine \
	irb -I lib:test

shell:
	docker run -it \
	-w /var/app \
	-v `pwd`:/var/app \
	ruby:alpine \
	sh
