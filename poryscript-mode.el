;;; poryscript-mode.el --- Major mode for editing Poryscript
;;; Commentary:
;; Rudamentry hyntax highlighting of types and keywords for Poryscript, along with the event macros found in PokeEmerald: https://github.com/pret/pokeemerald/blob/master/asm/macros/event.inc
;; Based off the tutorials at:
;; - http://xahlee.info/emacs/emacs/elisp_syntax_coloring.html
;; - https://www.emacswiki.org/emacs/ModeTutorial
;;; Code:

(defvar poryscript-mode-hook nil)

(setq poryscript-keywords
      (let* (
             (x-types '("script" "text" "movement" "mart" "mapscript" "raw"))
             (x-keywords '("if" "while" "do" "switch" "case"))
             (x-constants '("TRUE" "FALSE" "true" "false"))
             (x-macros '("nop" "nop1" "end" "return" "call" "goto" "goto_if" "call_if" "gotostd" "callstd" "gotostd_if" "callstd_if" "returnram" "endram" "setmysteryeventstatus" "loadword" "loadbyte" "setptr" "loadbytefromptr" "setptrbyte" "copylocal" "copybyte" "setvar" "addvar" "subvar" "copyvar" "setorcopyvar" "compare_local_to_local" "compare_local_to_value" "compare_local_to_ptr" "compare_ptr_to_local" "compare_ptr_to_value" "compare_ptr_to_ptr" "compare_var_to_value" "compare_var_to_var" "compare" "callnative" "gotonative" "special" "specialvar" "waitstate" "delay" "setflag" "clearflag" "checkflag" "initclock" "dotimebasedevents" "gettime" "playse" "waitse" "playfanfare" "waitfanfare" "playbgm" "savebgm" "fadedefaultbgm" "fadenewbgm" "fadeoutbgm" "fadeinbgm" "formatwarp" "warp" "warpsilent" "warpdoor" "warphole" "warpteleport" "setwarp" "setdynamicwarp" "setdivewarp" "setholewarp" "getplayerxy" "getpartysize" "additem" "removeitem" "checkitemspace" "checkitem" "checkitemtype" "addpcitem" "checkpcitem" "adddecoration" "removedecoration" "checkdecor" "checkdecorspace" "applymovement" "waitmovement" "removeobject" "addobject" "setobjectxy" "showobjectat" "hideobjectat" "faceplayer" "turnobject" "trainerbattle" "trainerbattle_single" "trainerbattle_double" "trainerbattle_rematch" "trainerbattle_rematch_double" "trainerbattle_no_intro" "dotrainerbattle" "gotopostbattlescript" "gotobeatenscript" "checktrainerflag" "settrainerflag" "cleartrainerflag" "setobjectxyperm" "copyobjectxytoperm" "setobjectmovementtype" "waitmessage" "message" "closemessage" "lockall" "lock" "releaseall" "release" "waitbuttonpress" "yesnobox" "multichoice" "multichoicedefault" "multichoicegrid" "drawbox" "erasebox" "drawboxtext" "showmonpic" "hidemonpic" "showcontestpainting" "braillemessage" "brailleformat" "givemon" "giveegg" "setmonmove" "checkpartymove" "stringvar" "bufferspeciesname" "bufferleadmonspeciesname" "bufferpartymonnick" "bufferitemname" "bufferdecorationname" "buffermovename" "buffernumberstring" "bufferstdstring" "bufferstring" "pokemart" "pokemartdecoration" "pokemartdecoration2" "playslotmachine" "setberrytree" "choosecontestmon" "startcontest" "showcontestresults" "contestlinktransfer" "random" "addmoney" "removemoney" "checkmoney" "showmoneybox" "hidemoneybox" "updatemoneybox" "getpokenewsactive" "fadescreen" "fadescreenspeed" "setflashlevel" "animateflash" "messageautoscroll" "dofieldeffect" "setfieldeffectargument" "waitfieldeffect" "setrespawn" "checkplayergender" "playmoncry" "setmetatile" "resetweather" "setweather" "doweather" "setstepcallback" "setmaplayoutindex" "setobjectsubpriority" "resetobjectsubpriority" "createvobject" "turnvobject" "opendoor" "closedoor" "waitdooranim" "setdooropen" "setdoorclosed" "addelevmenuitem" "showelevmenu" "checkcoins" "addcoins" "removecoins" "setwildbattle" "dowildbattle" "setvaddress" "vgoto" "vcall" "vgoto_if" "vcall_if" "vmessage" "vbuffermessage" "vbufferstring" "showcoinsbox" "hidecoinsbox" "updatecoinsbox" "incrementgamestat" "setescapewarp" "waitmoncry" "bufferboxname" "textcolor" "loadhelp" "unloadhelp" "signmsg" "normalmsg" "comparehiddenvar" "setmodernfatefulencounter" "checkmodernfatefulencounter" "trywondercardscript" "setworldmapflag" "warpspinenter" "setmonmetlocation" "moverotatingtileobjects" "turnrotatingtileobjects" "initrotatingtilepuzzle" "freerotatingtilepuzzle" "warpmossdeepgym" "selectapproachingtrainer" "lockfortrainer" "closebraillemessage" "messageinstant" "fadescreenswapbuffers" "buffertrainerclassname" "buffertrainername" "pokenavcall" "warpwhitefade" "buffercontestname" "bufferitemnameplural" "goto_if_unset" "goto_if_set" "trycompare" "goto_if_lt" "goto_if_eq" "goto_if_gt" "goto_if_le" "goto_if_ge" "goto_if_ne" "call_if_unset" "call_if_set" "call_if_lt" "call_if_eq" "call_if_gt" "call_if_le" "call_if_ge" "call_if_ne" "vgoto_if_eq" "vgoto_if_ne" "vgoto_if_unset" "vgoto_if_set" "goto_if_defeated" "goto_if_not_defeated" "call_if_defeated" "call_if_not_defeated" "switch" "case" "msgbox" "giveitem" "finditem" "givedecoration" "register_matchcall" "dofieldeffectsparkle" "braillemsgbox" "seteventmon"))
             (x-types-regexp (regexp-opt x-types 'words))
             (x-keywords-regexp (regexp-opt x-keywords 'words))
             (x-constants-regexp (regexp-opt x-constants 'words))
             (x-macros-regexp (regexp-opt x-macros 'words)))
        `(
          (, x-types-regexp . 'font-lock-type-face)
          (, x-keywords-regexp . 'font-lock-keyword-face)
          (, x-constants-regexp . 'font-lock-constant-face)
          (, x-macros-regexp . 'font-lock-function-name-face))))


(define-derived-mode poryscript-mode fundamental-mode
  (setq font-lock-defaults '((poryscript-keywords))))

(add-to-list 'auto-mode-alist '("\\.pory\\'" . poryscript-mode))
(provide 'poryscript-mode)

;;; poryscript-mode.el ends here
