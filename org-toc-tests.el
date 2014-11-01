;;; org-toc-tests.el --- Tests for org-toc

;; Copyright (C) 2014 Sergei Nosov

;; Author: Sergei Nosov <sergei.nosov [at] gmail.com>

;;; Code

(require 'org-toc)
(require 'ert)

(ert-deftest org-toc-test-raw-toc ()
  "Test the `org-toc-raw-toc' function"

  (defun org-toc-test-raw-toc-gold-test (content gold)
    (should (equal
             (with-temp-buffer
               (insert content)
               (org-toc-raw-toc))
             gold)))

  (let ((beg "* About\n:TOC:\n drawer\n:END:\n\norg-toc is a utility to have an up-to-date table of contents in the\norg files without exporting (useful primarily for readme files on\nGitHub).\n\nIt is similar to the [[https://github.com/ardumont/markdown-toc][markdown-toc]] package, but works for org files.\n:TOC:\n  drawer\n:END:\n\n* Table of Contents                                                     ")
        (gold "* About\n"))

    ;; different TOC styles
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC:"         ) gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC_1:"       ) gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC_1_qqq:"   ) gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC@1:"       ) gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC@1@cxv:"   ) gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC@1_hello:" ) gold)

    ;; trailing symbols
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC@1_hello:" "\n\n\n") gold)
    (org-toc-test-raw-toc-gold-test (concat beg ":TOC@1_hello:" "\n\n\nsdfd") gold))

  ;; more complex case
  (org-toc-test-raw-toc-gold-test
   "* About\n:TOC:\n drawer\n:END:\n\norg-toc is a utility to have an up-to-date table of contents in the\norg files without exporting (useful primarily for readme files on\nGitHub).\n\nIt is similar to the [[https://github.com/ardumont/markdown-toc][markdown-toc]] package, but works for org files.\n:TOC:\n  drawer\n:END:\n\n* Table of Contents                                                     :TOC:\n - [[#about][About]]\n - [[#use][Use]]\n - [[#different-href-styles][Different href styles]]\n - [[#example][Example]]\n\n* Installation\n** via package.el\nThis is the simplest method if you have the package.el module\n(built-in since Emacs 24.1) you can simply use =M-x package-install=\nand then put the following snippet in your ~/.emacs file\n#+BEGIN_SRC elisp\n  (eval-after-load \"org-toc-autoloads\"\n    '(progn\n       (if (require 'org-toc nil t)\n           (add-hook 'org-mode-hook 'org-toc-enable)\n         (warn \"org-toc not found\"))))\n#+END_SRC\n** Manual                                                             :Hello:\n- Create folder ~/.emacs.d if you don't have it\n- Go to it and clone org-toc there\n  #+BEGIN_SRC sh\n    git clone https://github.com/snosov1/org-toc.git\n  #+END_SRC\n- Put this in your ~/.emacs file\n  #+BEGIN_SRC elisp\n    (add-to-list 'load-path \"~/.emacs.d/org-toc\")\n    (when (require 'org-toc nil t)\n      (add-hook 'org-mode-hook 'org-toc-enable))\n  #+END_SRC\n\n* Use\n\nAfter the installation, every time you'll be saving an org file, the\nfirst headline with a :TOC: tag will be updated with the current table\nof contents.\n\nTo add a TOC tag, you can use the command =org-set-tags-command=.\n\nIn addition to the simple :TOC: tag, you can also use the following\ntag formats:\n\n- :TOC@2: - sets the max depth of the headlines in the table of\n  contents to 2 (the default)\n\n- :TOC@2@gh: - sets the max depth as in above and also uses the\n  GitHub-style hrefs in the table of contents (the default). The other\n  supported href style is 'org', which is the default org style (you\n  can use C-c C-o to go to the headline at point).\n\nYou can also use =_= as separator, instead of =@=.\n\n* Different href styles\n\nCurrently, only 2 href styles are supported: =gh= and =org=. You can easily\ndefine your own styles. If you use the tag =:TOC@2@STYLE:= (=STYLE= being a\nstyle name), then the package will look for a function named\n=org-toc-hrefify-STYLE=, which accepts a heading string and returns a href\ncorresponding to that heading.\n\nE.g. for =org= style it simply returns input as is:\n\n#+BEGIN_SRC emacs-lisp\n  (defun org-toc-hrefify-org (str)\n    \"Given a heading, transform it into a href using the org-mode\n  rules.\"\n    str)\n#+END_SRC\n\n* Example\n\n#+BEGIN_SRC org\n  * About\n  * Table of Contents                                           :TOC:\n    - [[#about][About]]\n    - [[#installation][Installation]]\n        - [[#via-packageel][via package.el]]\n        - [[#manual][Manual]]\n    - [[#use][Use]]\n  * Installation\n  ** via package.el\n  ** Manual\n  * Use\n  * Example\n#+END_SRC\n"
   "* About\n* Installation\n** via package.el\n** Manual\n* Use\n* Different href styles\n* Example\n"))

(provide 'org-toc-tests)
;;; org-toc-tests.el ends here
