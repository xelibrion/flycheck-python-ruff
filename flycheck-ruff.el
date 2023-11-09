;;; python-ruff.el --- Flycheck: Ruff integration -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Dmitry Kryuchkov <xelibrion@gmail.com>

;; Author: Dmitry Kryuchkov <xelibrion@gmail.com>
;; URL: https://github.com/xelibrion/flycheck-python-ruff
;; Keywords: tools, convenience
;; Version: 0.1
;; Package-Requires: ((emacs "24.1") (flycheck "28"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This Flycheck extension configures Flycheck automatically for the current
;; Python project.
;;
;; # Setup
;;
;;     (with-eval-after-load 'python-mode
;;       (add-hook 'flycheck-mode-hook #'flycheck-python-ruff-setup))
;;
;; # Usage
;;
;; Just use Flycheck as usual in your Python projects.

;;; Code:

(require 'flycheck)

(flycheck-define-checker python-ruff
  "A Python syntax and style checker using the ruff utility.
To override the path to the ruff executable, set
`flycheck-python-ruff-executable'.
See URL `http://pypi.python.org/pypi/ruff'."
  :command ("ruff"
            "--format=text"
            (eval (when buffer-file-name
                    (concat "--stdin-filename=" buffer-file-name)))
            "-")
  :standard-input t
  :error-filter (lambda (errors)
                  (let ((errors (flycheck-sanitize-errors errors)))
                    (seq-map #'flycheck-flake8-fix-error-level errors)))
  :error-patterns
  ((warning line-start
            (file-name) ":" line ":" (optional column ":") " "
            (id (one-or-more (any alpha)) (one-or-more digit)) " "
            (message (one-or-more not-newline))
            line-end))
  :modes python-mode)



(provide 'flycheck-python-ruff)
;;; flycheck-ruff.el ends here
