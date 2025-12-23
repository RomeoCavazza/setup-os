;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(doom! :input
       ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
       ;;chinese
       ;;japanese
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       (corfu +orderless)  ; Completion ultra-rapide et moderne
       vertico             ; Interface de recherche moderne (remplace ivy/helm)

       :ui
       doom              ; Le thème
       doom-dashboard    ; L'écran d'accueil
       hl-todo           ; Highlight TODO/FIXME/NOTE/DEPRECATED
       modeline          ; La barre d'état
       ophints           ; Indices visuels
       (popup +defaults) ; Gestion des fenêtres popups
       (vc-gutter +pretty) ; Indicateurs Git dans la marge
       vi-tilde-fringe   ; Marqueurs de fin de fichier (~)
       workspaces        ; Gestion des espaces de travail
       zen               ; Mode sans distraction

       :editor
       (evil +everywhere); Vim bindings partout
       file-templates    ; Snippets automatiques pour nouveaux fichiers
       fold              ; Pliage de code
       (format +onsave)  ; Formatage auto à la sauvegarde
       snippets          ; Templates de code
       multiple-cursors  ; Édition multiple

       :emacs
       dired             ; Gestionnaire de fichiers puissant
       electric          ; Indentation intelligente
       undo              ; Historique d'annulation avancé (undo-tree)
       vc                ; Version control

       :term
       vterm             ; Terminal intégré rapide (Nécessite le module système emacs.nix)

       :checkers
       syntax            ; Vérification de syntaxe (Flycheck)
       (spell +flyspell) ; Correction orthographique

       :tools
       (eval +overlay)   ; REPL et exécution de code inline
       lookup            ; Documentation (K)
       lsp               ; Language Server Protocol (Moteur d'intelligence)
       magit             ; Interface Git suprême
       pdf               ; Lecteur PDF (pour les papiers de recherche)
       tree-sitter       ; Parsing de code ultra-rapide
       docker            ; Gestion Docker

       :os
       (:if (featurep :system 'macos) macos)
       tty

       :lang
       emacs-lisp        ; Pour configurer Emacs
       markdown          ; Pour la documentation
       nix               ; Pour NixOS
       (org +roam +dragndrop +present) ; Le second cerveau (Notes, Agenda, Zettelkasten)
       sh                ; Scripting shell (Bash)
       (python +lsp +pyright) ; Data Science & IA (Support lourd)
       (rust +lsp)       ; Embedded haute perf
       (cc +lsp)         ; C/C++ (Arduino/ESP32)
       latex             ; Pour les formules scientifiques
       yaml              ; Config Docker/K8s
       json              ; Data

       :config
       (default +bindings +smartparens))
