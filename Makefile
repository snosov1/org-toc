test:
	emacs -Q --batch -l ert -l org-toc.el -l org-toc-tests.el -f ert-run-tests-batch-and-exit
