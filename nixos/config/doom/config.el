;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; --- IDENTITÉ ---
(setq user-full-name "Romeo Cavazza"
      user-mail-address "ton.email@exemple.com")

;; --- APPARENCE ---
;; Utilise la police Nerd Font installée via NixOS
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; Thème visuel
(setq doom-theme 'doom-one)

;; Affiche les numéros de ligne relatifs (style Vim)
(setq display-line-numbers-type 'relative)

;; --- ORG MODE (Le Cerveau) ---
(setq org-directory "~/org/")

;; --- CONFIGURATION IA (GPTEL + OLLAMA) ---
(use-package! gptel
  :config
  ;; CORRECTION ICI : 'mistral (Symbole) au lieu de "mistral" (String)
  (setq! gptel-model 'mistral
         gptel-backend (gptel-make-ollama "Ollama"
                         :host "localhost:11434"
                         :stream t
                         :models '(mistral llama3 gemma:2b))))

;; Raccourci pour ouvrir un chat IA : SPC o c
(map! :leader
      (:prefix ("o" . "open")
       :desc "Open AI Chat" "c" #'gptel))

;; --- PERFORMANCE ---
;; Améliore la réactivité du LSP
(setq lsp-idle-delay 0.500)
