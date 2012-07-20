
all:
	@cd ..; perl -MTest::Harness -e '$$Test::Harness::verbose=0; runtests @ARGV;' tests/*.t

verbose:
	@cd ..; perl -MTest::Harness -e '$$Test::Harness::verbose=1; runtests @ARGV;' tests/*.t


modules: .PHONY
	./modules.sh > modules.t

files: .PHONY
	perl gnump3d-files.pl > gnump3d-files.t

.PHONY:
	true

clean:

	rm *~
