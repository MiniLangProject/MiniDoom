/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

//! Supplies the French replacements for Doom's menu prompts, status messages, pickups, keys, and level titles.


/// Defines the d devstr text used by the d french subsystem.
const D_DEVSTR = "MODE DEVELOPPEMENT ON.\n"
/// Defines the d cdrom text used by the d french subsystem.
const D_CDROM = "VERSION CD-ROM: DEFAULT.CFG DANS C:\\DOOMDATA\n"
/// Defines the input key code for presskey.
const PRESSKEY = "APPUYEZ SUR UNE TOUCHE."
/// Defines the pressyn text used by the d french subsystem.
const PRESSYN = "APPUYEZ SUR Y OU N"
/// Defines the quitmsg text used by the d french subsystem.
const QUITMSG = "VOUS VOULEZ VRAIMENT\nQUITTER CE SUPER JEU?"
/// Defines the loadnet text used by the d french subsystem.
const LOADNET = "VOUS NE POUVEZ PAS CHARGER\nUN JEU EN RESEAU!\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the qloadnet text used by the d french subsystem.
const QLOADNET = "CHARGEMENT RAPIDE INTERDIT EN RESEAU!\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the qsavespot text used by the d french subsystem.
const QSAVESPOT = "VOUS N'AVEZ PAS CHOISI UN EMPLACEMENT!\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the savedead text used by the d french subsystem.
const SAVEDEAD = "VOUS NE POUVEZ PAS SAUVER SI VOUS NE JOUEZ PAS!\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the qsprompt text used by the d french subsystem.
const QSPROMPT = "SAUVEGARDE RAPIDE DANS LE FICHIER \n\n'%s'?\n\nAPPUYEZ SUR Y OU N"
/// Defines the qlprompt text used by the d french subsystem.
const QLPROMPT = "VOULEZ-VOUS CHARGER LA SAUVEGARDE\n\n'%s'?\n\nAPPUYEZ SUR Y OU N"
/// Defines the newgame text used by the d french subsystem.
const NEWGAME = "VOUS NE POUVEZ PAS LANCER\nUN NOUVEAU JEU SUR RESEAU.\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the nightmare text used by the d french subsystem.
const NIGHTMARE = "VOUS CONFIRMEZ? CE NIVEAU EST\nVRAIMENT IMPITOYABLE!nAPPUYEZ SUR Y OU N"
/// Defines the swstring text used by the d french subsystem.
const SWSTRING = "CECI EST UNE VERSION SHAREWARE DE DOOM.\n\nVOUS DEVRIEZ COMMANDER LA TRILOGIE COMPLETE.\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the msgoff text used by the d french subsystem.
const MSGOFF = "MESSAGES OFF"
/// Defines the msgon text used by the d french subsystem.
const MSGON = "MESSAGES ON"
/// Defines the netend text used by the d french subsystem.
const NETEND = "VOUS NE POUVEZ PAS METTRE FIN A UN JEU SUR RESEAU!\n\nAPPUYEZ SUR UNE TOUCHE."
/// Defines the endgame text used by the d french subsystem.
const ENDGAME = "VOUS VOULEZ VRAIMENT METTRE FIN AU JEU?\n\nAPPUYEZ SUR Y OU N"
/// Defines the dosy text used by the d french subsystem.
const DOSY = "(APPUYEZ SUR Y POUR REVENIR AU OS.)"
/// Defines the detailhi text used by the d french subsystem.
const DETAILHI = "GRAPHISMES MAXIMUM "
/// Defines the detaillo text used by the d french subsystem.
const DETAILLO = "GRAPHISMES MINIMUM "
/// Defines the gammalvl0 text used by the d french subsystem.
const GAMMALVL0 = "CORRECTION GAMMA OFF"
/// Defines the gammalvl1 text used by the d french subsystem.
const GAMMALVL1 = "CORRECTION GAMMA NIVEAU 1"
/// Defines the gammalvl2 text used by the d french subsystem.
const GAMMALVL2 = "CORRECTION GAMMA NIVEAU 2"
/// Defines the gammalvl3 text used by the d french subsystem.
const GAMMALVL3 = "CORRECTION GAMMA NIVEAU 3"
/// Defines the gammalvl4 text used by the d french subsystem.
const GAMMALVL4 = "CORRECTION GAMMA NIVEAU 4"
/// Defines the emptystring text used by the d french subsystem.
const EMPTYSTRING = "EMPLACEMENT VIDE"
/// Defines the gotarmor text used by the d french subsystem.
const GOTARMOR = "ARMURE RECUPEREE."
/// Defines the gotmega text used by the d french subsystem.
const GOTMEGA = "MEGA-ARMURE RECUPEREE!"
/// Defines the goththbonus text used by the d french subsystem.
const GOTHTHBONUS = "BONUS DE SANTE RECUPERE."
/// Defines the gotarmbonus text used by the d french subsystem.
const GOTARMBONUS = "BONUS D'ARMURE RECUPERE."
/// Defines the gotstim text used by the d french subsystem.
const GOTSTIM = "STIMPACK RECUPERE."
/// Defines the gotmedineed text used by the d french subsystem.
const GOTMEDINEED = "MEDIKIT RECUPERE. VOUS EN AVEZ VRAIMENT BESOIN!"
/// Defines the gotmedikit text used by the d french subsystem.
const GOTMEDIKIT = "MEDIKIT RECUPERE."
/// Defines the gotsuper text used by the d french subsystem.
const GOTSUPER = "SUPERCHARGE!"
/// Defines the gotbluecard text used by the d french subsystem.
const GOTBLUECARD = "CARTE MAGNETIQUE BLEUE RECUPEREE."
/// Defines the gotyelwcard text used by the d french subsystem.
const GOTYELWCARD = "CARTE MAGNETIQUE JAUNE RECUPEREE."
/// Defines the gotredcard text used by the d french subsystem.
const GOTREDCARD = "CARTE MAGNETIQUE ROUGE RECUPEREE."
/// Defines the gotblueskul text used by the d french subsystem.
const GOTBLUESKUL = "CLEF CRANE BLEUE RECUPEREE."
/// Defines the gotyelwskul text used by the d french subsystem.
const GOTYELWSKUL = "CLEF CRANE JAUNE RECUPEREE."
/// Defines the gotredskull text used by the d french subsystem.
const GOTREDSKULL = "CLEF CRANE ROUGE RECUPEREE."
/// Defines the gotinvul text used by the d french subsystem.
const GOTINVUL = "INVULNERABILITE!"
/// Defines the gotberserk text used by the d french subsystem.
const GOTBERSERK = "BERSERK!"
/// Defines the gotinvis text used by the d french subsystem.
const GOTINVIS = "INVISIBILITE PARTIELLE "
/// Defines the gotsuit text used by the d french subsystem.
const GOTSUIT = "COMBINAISON ANTI-RADIATIONS "
/// Defines the gotmap text used by the d french subsystem.
const GOTMAP = "CARTE INFORMATIQUE "
/// Defines the gotvisor text used by the d french subsystem.
const GOTVISOR = "VISEUR A AMPLIFICATION DE LUMIERE "
/// Defines the gotmsphere text used by the d french subsystem.
const GOTMSPHERE = "MEGASPHERE!"
/// Defines the gotclip text used by the d french subsystem.
const GOTCLIP = "CHARGEUR RECUPERE."
/// Defines the gotclipbox text used by the d french subsystem.
const GOTCLIPBOX = "BOITE DE BALLES RECUPEREE."
/// Defines the gotrocket text used by the d french subsystem.
const GOTROCKET = "ROQUETTE RECUPEREE."
/// Defines the gotrockbox text used by the d french subsystem.
const GOTROCKBOX = "CAISSE DE ROQUETTES RECUPEREE."
/// Defines the gotcell text used by the d french subsystem.
const GOTCELL = "CELLULE D'ENERGIE RECUPEREE."
/// Defines the gotcellbox text used by the d french subsystem.
const GOTCELLBOX = "PACK DE CELLULES D'ENERGIE RECUPERE."
/// Defines the gotshells text used by the d french subsystem.
const GOTSHELLS = "4 CARTOUCHES RECUPEREES."
/// Defines the gotshellbox text used by the d french subsystem.
const GOTSHELLBOX = "BOITE DE CARTOUCHES RECUPEREE."
/// Defines the gotbackpack text used by the d french subsystem.
const GOTBACKPACK = "SAC PLEIN DE MUNITIONS RECUPERE!"
/// Defines the gotbfg9000 text used by the d french subsystem.
const GOTBFG9000 = "VOUS AVEZ UN BFG9000!  OH, OUI!"
/// Defines the gotchaingun text used by the d french subsystem.
const GOTCHAINGUN = "VOUS AVEZ LA MITRAILLEUSE!"
/// Defines the gotchainsaw text used by the d french subsystem.
const GOTCHAINSAW = "UNE TRONCONNEUSE!"
/// Defines the gotlauncher text used by the d french subsystem.
const GOTLAUNCHER = "VOUS AVEZ UN LANCE-ROQUETTES!"
/// Defines the gotplasma text used by the d french subsystem.
const GOTPLASMA = "VOUS AVEZ UN FUSIL A PLASMA!"
/// Defines the gotshotgun text used by the d french subsystem.
const GOTSHOTGUN = "VOUS AVEZ UN FUSIL!"
/// Defines the gotshotgun2 text used by the d french subsystem.
const GOTSHOTGUN2 = "VOUS AVEZ UN SUPER FUSIL!"
/// Defines the pd blueo text used by the d french subsystem.
const PD_BLUEO = "IL VOUS FAUT UNE CLEF BLEUE"
/// Defines the pd redo text used by the d french subsystem.
const PD_REDO = "IL VOUS FAUT UNE CLEF ROUGE"
/// Defines the pd yellowo text used by the d french subsystem.
const PD_YELLOWO = "IL VOUS FAUT UNE CLEF JAUNE"
/// Defines the pd bluek text used by the d french subsystem.
const PD_BLUEK = "IL VOUS FAUT UNE CLEF BLEUE"
/// Defines the pd redk text used by the d french subsystem.
const PD_REDK = "IL VOUS FAUT UNE CLEF ROUGE"
/// Defines the pd yellowk text used by the d french subsystem.
const PD_YELLOWK = "IL VOUS FAUT UNE CLEF JAUNE"
/// Defines the ggsaved text used by the d french subsystem.
const GGSAVED = "JEU SAUVEGARDE."
/// Defines the hustr msgu text used by the d french subsystem.
const HUSTR_MSGU = "[MESSAGE NON ENVOYE]"
/// Defines the hustr e1 m1 text used by the d french subsystem.
const HUSTR_E1M1 = "E1M1: HANGAR"
/// Defines the hustr e1 m2 text used by the d french subsystem.
const HUSTR_E1M2 = "E1M2: USINE NUCLEAIRE "
/// Defines the hustr e1 m3 text used by the d french subsystem.
const HUSTR_E1M3 = "E1M3: RAFFINERIE DE TOXINES "
/// Defines the hustr e1 m4 text used by the d french subsystem.
const HUSTR_E1M4 = "E1M4: CENTRE DE CONTROLE "
/// Defines the hustr e1 m5 text used by the d french subsystem.
const HUSTR_E1M5 = "E1M5: LABORATOIRE PHOBOS "
/// Defines the hustr e1 m6 text used by the d french subsystem.
const HUSTR_E1M6 = "E1M6: TRAITEMENT CENTRAL "
/// Defines the hustr e1 m7 text used by the d french subsystem.
const HUSTR_E1M7 = "E1M7: CENTRE INFORMATIQUE "
/// Defines the hustr e1 m8 text used by the d french subsystem.
const HUSTR_E1M8 = "E1M8: ANOMALIE PHOBOS "
/// Defines the hustr e1 m9 text used by the d french subsystem.
const HUSTR_E1M9 = "E1M9: BASE MILITAIRE "
/// Defines the hustr e2 m1 text used by the d french subsystem.
const HUSTR_E2M1 = "E2M1: ANOMALIE DEIMOS "
/// Defines the hustr e2 m2 text used by the d french subsystem.
const HUSTR_E2M2 = "E2M2: ZONE DE CONFINEMENT "
/// Defines the hustr e2 m3 text used by the d french subsystem.
const HUSTR_E2M3 = "E2M3: RAFFINERIE"
/// Defines the hustr e2 m4 text used by the d french subsystem.
const HUSTR_E2M4 = "E2M4: LABORATOIRE DEIMOS "
/// Defines the hustr e2 m5 text used by the d french subsystem.
const HUSTR_E2M5 = "E2M5: CENTRE DE CONTROLE "
/// Defines the hustr e2 m6 text used by the d french subsystem.
const HUSTR_E2M6 = "E2M6: HALLS DES DAMNES "
/// Defines the hustr e2 m7 text used by the d french subsystem.
const HUSTR_E2M7 = "E2M7: CUVES DE REPRODUCTION "
/// Defines the hustr e2 m8 text used by the d french subsystem.
const HUSTR_E2M8 = "E2M8: TOUR DE BABEL "
/// Defines the hustr e2 m9 text used by the d french subsystem.
const HUSTR_E2M9 = "E2M9: FORTERESSE DU MYSTERE "
/// Defines the hustr e3 m1 text used by the d french subsystem.
const HUSTR_E3M1 = "E3M1: DONJON DE L'ENFER "
/// Defines the hustr e3 m2 text used by the d french subsystem.
const HUSTR_E3M2 = "E3M2: BOURBIER DU DESESPOIR "
/// Defines the hustr e3 m3 text used by the d french subsystem.
const HUSTR_E3M3 = "E3M3: PANDEMONIUM"
/// Defines the hustr e3 m4 text used by the d french subsystem.
const HUSTR_E3M4 = "E3M4: MAISON DE LA DOULEUR "
/// Defines the hustr e3 m5 text used by the d french subsystem.
const HUSTR_E3M5 = "E3M5: CATHEDRALE PROFANE "
/// Defines the hustr e3 m6 text used by the d french subsystem.
const HUSTR_E3M6 = "E3M6: MONT EREBUS"
/// Defines the hustr e3 m7 text used by the d french subsystem.
const HUSTR_E3M7 = "E3M7: LIMBES"
/// Defines the hustr e3 m8 text used by the d french subsystem.
const HUSTR_E3M8 = "E3M8: DIS"
/// Defines the hustr e3 m9 text used by the d french subsystem.
const HUSTR_E3M9 = "E3M9: CLAPIERS"
/// Defines the hustr 1 text used by the d french subsystem.
const HUSTR_1 = "NIVEAU 1: ENTREE "
/// Defines the hustr 2 text used by the d french subsystem.
const HUSTR_2 = "NIVEAU 2: HALLS SOUTERRAINS "
/// Defines the hustr 3 text used by the d french subsystem.
const HUSTR_3 = "NIVEAU 3: LE FEU NOURRI "
/// Defines the hustr 4 text used by the d french subsystem.
const HUSTR_4 = "NIVEAU 4: LE FOYER "
/// Defines the hustr 5 text used by the d french subsystem.
const HUSTR_5 = "NIVEAU 5: LES EGOUTS "
/// Defines the hustr 6 text used by the d french subsystem.
const HUSTR_6 = "NIVEAU 6: LE BROYEUR "
/// Defines the hustr 7 text used by the d french subsystem.
const HUSTR_7 = "NIVEAU 7: L'HERBE DE LA MORT"
/// Defines the hustr 8 text used by the d french subsystem.
const HUSTR_8 = "NIVEAU 8: RUSES ET PIEGES "
/// Defines the hustr 9 text used by the d french subsystem.
const HUSTR_9 = "NIVEAU 9: LE PUITS "
/// Defines the hustr 10 text used by the d french subsystem.
const HUSTR_10 = "NIVEAU 10: BASE DE RAVITAILLEMENT "
/// Defines the hustr 11 text used by the d french subsystem.
const HUSTR_11 = "NIVEAU 11: LE CERCLE DE LA MORT!"
/// Defines the hustr 12 text used by the d french subsystem.
const HUSTR_12 = "NIVEAU 12: L'USINE "
/// Defines the hustr 13 text used by the d french subsystem.
const HUSTR_13 = "NIVEAU 13: LE CENTRE VILLE"
/// Defines the hustr 14 text used by the d french subsystem.
const HUSTR_14 = "NIVEAU 14: LES ANTRES PROFONDES "
/// Defines the hustr 15 text used by the d french subsystem.
const HUSTR_15 = "NIVEAU 15: LA ZONE INDUSTRIELLE "
/// Defines the hustr 16 text used by the d french subsystem.
const HUSTR_16 = "NIVEAU 16: LA BANLIEUE"
/// Defines the hustr 17 text used by the d french subsystem.
const HUSTR_17 = "NIVEAU 17: LES IMMEUBLES"
/// Defines the hustr 18 text used by the d french subsystem.
const HUSTR_18 = "NIVEAU 18: LA COUR "
/// Defines the hustr 19 text used by the d french subsystem.
const HUSTR_19 = "NIVEAU 19: LA CITADELLE "
/// Defines the hustr 20 text used by the d french subsystem.
const HUSTR_20 = "NIVEAU 20: JE T'AI EU!"
/// Defines the hustr 21 text used by the d french subsystem.
const HUSTR_21 = "NIVEAU 21: LE NIRVANA"
/// Defines the hustr 22 text used by the d french subsystem.
const HUSTR_22 = "NIVEAU 22: LES CATACOMBES "
/// Defines the hustr 23 text used by the d french subsystem.
const HUSTR_23 = "NIVEAU 23: LA GRANDE FETE "
/// Defines the hustr 24 text used by the d french subsystem.
const HUSTR_24 = "NIVEAU 24: LE GOUFFRE "
/// Defines the hustr 25 text used by the d french subsystem.
const HUSTR_25 = "NIVEAU 25: LES CHUTES DE SANG"
/// Defines the hustr 26 text used by the d french subsystem.
const HUSTR_26 = "NIVEAU 26: LES MINES ABANDONNEES "
/// Defines the hustr 27 text used by the d french subsystem.
const HUSTR_27 = "NIVEAU 27: CHEZ LES MONSTRES "
/// Defines the hustr 28 text used by the d french subsystem.
const HUSTR_28 = "NIVEAU 28: LE MONDE DE L'ESPRIT "
/// Defines the hustr 29 text used by the d french subsystem.
const HUSTR_29 = "NIVEAU 29: LA LIMITE "
/// Defines the hustr 30 text used by the d french subsystem.
const HUSTR_30 = "NIVEAU 30: L'ICONE DU PECHE "
/// Defines the hustr 31 text used by the d french subsystem.
const HUSTR_31 = "NIVEAU 31: WOLFENSTEIN"
/// Defines the hustr 32 text used by the d french subsystem.
const HUSTR_32 = "NIVEAU 32: LE MASSACRE"
/// Defines the hustr chatmacro1 text used by the d french subsystem.
const HUSTR_CHATMACRO1 = "JE SUIS PRET A LEUR EN FAIRE BAVER!"
/// Defines the hustr chatmacro2 text used by the d french subsystem.
const HUSTR_CHATMACRO2 = "JE VAIS BIEN."
/// Defines the hustr chatmacro3 text used by the d french subsystem.
const HUSTR_CHATMACRO3 = "JE N'AI PAS L'AIR EN FORME!"
/// Defines the hustr chatmacro4 text used by the d french subsystem.
const HUSTR_CHATMACRO4 = "AU SECOURS!"
/// Defines the hustr chatmacro5 text used by the d french subsystem.
const HUSTR_CHATMACRO5 = "TU CRAINS!"
/// Defines the hustr chatmacro6 text used by the d french subsystem.
const HUSTR_CHATMACRO6 = "LA PROCHAINE FOIS, MINABLE..."
/// Defines the hustr chatmacro7 text used by the d french subsystem.
const HUSTR_CHATMACRO7 = "VIENS ICI!"
/// Defines the hustr chatmacro8 text used by the d french subsystem.
const HUSTR_CHATMACRO8 = "JE VAIS M'EN OCCUPER."
/// Defines the hustr chatmacro9 text used by the d french subsystem.
const HUSTR_CHATMACRO9 = "OUI"
/// Defines the hustr chatmacro0 text used by the d french subsystem.
const HUSTR_CHATMACRO0 = "NON"
/// Defines the hustr talktoself1 text used by the d french subsystem.
const HUSTR_TALKTOSELF1 = "VOUS PARLEZ TOUT SEUL "
/// Defines the hustr talktoself2 text used by the d french subsystem.
const HUSTR_TALKTOSELF2 = "QUI EST LA?"
/// Defines the hustr talktoself3 text used by the d french subsystem.
const HUSTR_TALKTOSELF3 = "VOUS VOUS FAITES PEUR "
/// Defines the hustr talktoself4 text used by the d french subsystem.
const HUSTR_TALKTOSELF4 = "VOUS COMMENCEZ A DELIRER "
/// Defines the hustr talktoself5 text used by the d french subsystem.
const HUSTR_TALKTOSELF5 = "VOUS ETES LARGUE..."
/// Defines the hustr messagesent text used by the d french subsystem.
const HUSTR_MESSAGESENT = "[MESSAGE ENVOYE]"
/// Defines the hustr plrgreen text used by the d french subsystem.
const HUSTR_PLRGREEN = "VERT: "
/// Defines the hustr plrindigo text used by the d french subsystem.
const HUSTR_PLRINDIGO = "INDIGO: "
/// Defines the hustr plrbrown text used by the d french subsystem.
const HUSTR_PLRBROWN = "BRUN: "
/// Defines the hustr plrred text used by the d french subsystem.
const HUSTR_PLRRED = "ROUGE: "
/// Defines the hustr keygreen text used by the d french subsystem.
const HUSTR_KEYGREEN = "g"
/// Defines the hustr keyindigo text used by the d french subsystem.
const HUSTR_KEYINDIGO = "i"
/// Defines the hustr keybrown text used by the d french subsystem.
const HUSTR_KEYBROWN = "b"
/// Defines the hustr keyred text used by the d french subsystem.
const HUSTR_KEYRED = "r"
/// Defines the amstr followon text used by the d french subsystem.
const AMSTR_FOLLOWON = "MODE POURSUITE ON"
/// Defines the amstr followoff text used by the d french subsystem.
const AMSTR_FOLLOWOFF = "MODE POURSUITE OFF"
/// Defines the amstr gridon text used by the d french subsystem.
const AMSTR_GRIDON = "GRILLE ON"
/// Defines the amstr gridoff text used by the d french subsystem.
const AMSTR_GRIDOFF = "GRILLE OFF"
/// Defines the amstr markedspot text used by the d french subsystem.
const AMSTR_MARKEDSPOT = "REPERE MARQUE "
/// Defines the amstr markscleared text used by the d french subsystem.
const AMSTR_MARKSCLEARED = "REPERES EFFACES "
/// Defines the ststr mus text used by the d french subsystem.
const STSTR_MUS = "CHANGEMENT DE MUSIQUE "
/// Defines the ststr nomus text used by the d french subsystem.
const STSTR_NOMUS = "IMPOSSIBLE SELECTION"
/// Defines the ststr dqdon text used by the d french subsystem.
const STSTR_DQDON = "INVULNERABILITE ON "
/// Defines the ststr dqdoff text used by the d french subsystem.
const STSTR_DQDOFF = "INVULNERABILITE OFF"
/// Defines the ststr kfaadded text used by the d french subsystem.
const STSTR_KFAADDED = "ARMEMENT MAXIMUM! "
/// Defines the ststr faadded text used by the d french subsystem.
const STSTR_FAADDED = "ARMES (SAUF CLEFS) AJOUTEES"
/// Defines the ststr ncon text used by the d french subsystem.
const STSTR_NCON = "BARRIERES ON"
/// Defines the ststr ncoff text used by the d french subsystem.
const STSTR_NCOFF = "BARRIERES OFF"
/// Defines the ststr behold text used by the d french subsystem.
const STSTR_BEHOLD = " inVuln, Str, Inviso, Rad, Allmap, or Lite-amp"
/// Defines the ststr beholdx text used by the d french subsystem.
const STSTR_BEHOLDX = "AMELIORATION ACTIVEE"
/// Defines the ststr choppers text used by the d french subsystem.
const STSTR_CHOPPERS = "... DOESN'T SUCK - GM"
/// Defines the ststr clev text used by the d french subsystem.
const STSTR_CLEV = "CHANGEMENT DE NIVEAU..."
/// Defines the e1 text text used by the d french subsystem.
const E1TEXT = "APRES AVOIR VAINCU LES GROS MECHANTS\nET NETTOYE LA BASE LUNAIRE, VOUS AVEZ\nGAGNE, NON? PAS VRAI? OU EST DONC VOTRE\n RECOMPENSE ET VOTRE BILLET DE\nRETOUR? QU'EST-QUE CA VEUT DIRE?CEN'EST PAS LA FIN ESPEREE!\n\nCA SENT LA VIANDE PUTREFIEE, MAIS\nON DIRAIT LA BASE DEIMOS. VOUS ETES\nAPPAREMMENT BLOQUE AUX PORTES DE L'ENFER.\nLA SEULE ISSUE EST DE L'AUTRE COTE.\n\nPOUR VIVRE LA SUITE DE DOOM, JOUEZ\nA 'AUX PORTES DE L'ENFER' ET A\nL'EPISODE SUIVANT, 'L'ENFER'!\n"
/// Defines the e2 text text used by the d french subsystem.
const E2TEXT = "VOUS AVEZ REUSSI. L'INFAME DEMON\nQUI CONTROLAIT LA BASE LUNAIRE DE\nDEIMOS EST MORT, ET VOUS AVEZ\nTRIOMPHE! MAIS... OU ETES-VOUS?\nVOUS GRIMPEZ JUSQU'AU BORD DE LA\nLUNE ET VOUS DECOUVREZ L'ATROCE\nVERITE.\n\nDEIMOS EST AU-DESSUS DE L'ENFER!\nVOUS SAVEZ QUE PERSONNE NE S'EN\nEST JAMAIS ECHAPPE, MAIS CES FUMIERS\nVONT REGRETTER DE VOUS AVOIR CONNU!\nVOUS REDESCENDEZ RAPIDEMENT VERS\nLA SURFACE DE L'ENFER.\n\nVOICI MAINTENANT LE CHAPITRE FINAL DE\nDOOM! -- L'ENFER."
/// Defines the e3 text text used by the d french subsystem.
const E3TEXT = "LE DEMON ARACHNEEN ET REPUGNANT\nQUI A DIRIGE L'INVASION DES BASES\nLUNAIRES ET SEME LA MORT VIENT DE SE\nFAIRE PULVERISER UNE FOIS POUR TOUTES.\n\nUNE PORTE SECRETE S'OUVRE. VOUS ENTREZ.\nVOUS AVEZ PROUVE QUE VOUS POUVIEZ\nRESISTER AUX HORREURS DE L'ENFER.\nIL SAIT ETRE BEAU JOUEUR, ET LORSQUE\nVOUS SORTEZ, VOUS REVOYEZ LES VERTES\nPRAIRIES DE LA TERRE, VOTRE PLANETE.\n\nVOUS VOUS DEMANDEZ CE QUI S'EST PASSE\nSUR TERRE PENDANT QUE VOUS AVEZ\nCOMBATTU LE DEMON. HEUREUSEMENT,\nAUCUN GERME DU MAL N'A FRANCHI\nCETTE PORTE AVEC VOUS..."
/// Defines the c1 text text used by the d french subsystem.
const C1TEXT = "VOUS ETES AU PLUS PROFOND DE L'ASTROPORT\nINFESTE DE MONSTRES, MAIS QUELQUE CHOSE\nNE VA PAS. ILS ONT APPORTE LEUR PROPRE\nREALITE, ET LA TECHNOLOGIE DE L'ASTROPORT\nEST AFFECTEE PAR LEUR PRESENCE.\n\nDEVANT VOUS, VOUS VOYEZ UN POSTE AVANCE\nDE L'ENFER, UNE ZONE FORTIFIEE. SI VOUS\nPOUVEZ PASSER, VOUS POURREZ PENETRER AU\nCOEUR DE LA BASE HANTEE ET TROUVER \nL'INTERRUPTEUR DE CONTROLE QUI GARDE LA \nPOPULATION DE LA TERRE EN OTAGE."
/// Defines the c2 text text used by the d french subsystem.
const C2TEXT = "VOUS AVEZ GAGNE! VOTRE VICTOIRE A PERMIS\nA L'HUMANITE D'EVACUER LA TERRE ET \nD'ECHAPPER AU CAUCHEMAR. VOUS ETES \nMAINTENANT LE DERNIER HUMAIN A LA SURFACE \nDE LA PLANETE. VOUS ETES ENTOURE DE \nMUTANTS CANNIBALES, D'EXTRATERRESTRES \nCARNIVORES ET D'ESPRITS DU MAL. VOUS \nATTENDEZ CALMEMENT LA MORT, HEUREUX \nD'AVOIR PU SAUVER VOTRE RACE.\nMAIS UN MESSAGE VOUS PARVIENT SOUDAIN\nDE L'ESPACE: \"NOS CAPTEURS ONT LOCALISE\nLA SOURCE DE L'INVASION EXTRATERRESTRE.\nSI VOUS Y ALLEZ, VOUS POURREZ PEUT-ETRE\nLES ARRETER. LEUR BASE EST SITUEE AU COEUR\nDE VOTRE VILLE NATALE, PRES DE L'ASTROPORT.\nVOUS VOUS RELEVEZ LENTEMENT ET PENIBLEMENT\nET VOUS REPARTEZ POUR LE FRONT."
/// Defines the c3 text text used by the d french subsystem.
const C3TEXT = "VOUS ETES AU COEUR DE LA CITE CORROMPUE,\nENTOURE PAR LES CADAVRES DE VOS ENNEMIS.\nVOUS NE VOYEZ PAS COMMENT DETRUIRE LA PORTE\nDES CREATURES DE CE COTE. VOUS SERREZ\nLES DENTS ET PLONGEZ DANS L'OUVERTURE.\n\nIL DOIT Y AVOIR UN MOYEN DE LA FERMER\nDE L'AUTRE COTE. VOUS ACCEPTEZ DE\nTRAVERSER L'ENFER POUR LE FAIRE?"
/// Defines the c4 text text used by the d french subsystem.
const C4TEXT = "LE VISAGE HORRIBLE D'UN DEMON D'UNE\nTAILLE INCROYABLE S'EFFONDRE DEVANT\nVOUS LORSQUE VOUS TIREZ UNE SALVE DE\nROQUETTES DANS SON CERVEAU. LE MONSTRE\nSE RATATINE, SES MEMBRES DECHIQUETES\nSE REPANDANT SUR DES CENTAINES DE\nKILOMETRES A LA SURFACE DE L'ENFER.\n\nVOUS AVEZ REUSSI. L'INVASION N'AURA.\nPAS LIEU. LA TERRE EST SAUVEE. L'ENFER\nEST ANEANTI. EN VOUS DEMANDANT OU IRONT\nMAINTENANT LES DAMNES, VOUS ESSUYEZ\nVOTRE FRONT COUVERT DE SUEUR ET REPARTEZ\nVERS LA TERRE. SA RECONSTRUCTION SERA\nBEAUCOUP PLUS DROLE QUE SA DESTRUCTION.\n"
/// Defines the c5 text text used by the d french subsystem.
const C5TEXT = "FELICITATIONS! VOUS AVEZ TROUVE LE\nNIVEAU SECRET! IL SEMBLE AVOIR ETE\nCONSTRUIT PAR LES HUMAINS. VOUS VOUS\nDEMANDEZ QUELS PEUVENT ETRE LES\nHABITANTS DE CE COIN PERDU DE L'ENFER."
/// Defines the c6 text text used by the d french subsystem.
const C6TEXT = "FELICITATIONS! VOUS AVEZ DECOUVERT\nLE NIVEAU SUPER SECRET! VOUS FERIEZ\nMIEUX DE FONCER DANS CELUI-LA!\n"
/// Defines the cc zombie text used by the d french subsystem.
const CC_ZOMBIE = "ZOMBIE"
/// Defines the cc shotgun text used by the d french subsystem.
const CC_SHOTGUN = "TYPE AU FUSIL"
/// Defines the cc heavy text used by the d french subsystem.
const CC_HEAVY = "MEC SUPER-ARME"
/// Defines the cc imp text used by the d french subsystem.
const CC_IMP = "DIABLOTIN"
/// Defines the cc demon text used by the d french subsystem.
const CC_DEMON = "DEMON"
/// Defines the cc lost text used by the d french subsystem.
const CC_LOST = "AME PERDUE"
/// Defines the cc caco text used by the d french subsystem.
const CC_CACO = "CACODEMON"
/// Defines the cc hell text used by the d french subsystem.
const CC_HELL = "CHEVALIER DE L'ENFER"
/// Defines the cc baron text used by the d french subsystem.
const CC_BARON = "BARON DE L'ENFER"
/// Defines the cc arach text used by the d french subsystem.
const CC_ARACH = "ARACHNOTRON"
/// Defines the cc pain text used by the d french subsystem.
const CC_PAIN = "ELEMENTAIRE DE LA DOULEUR"
/// Defines the cc reven text used by the d french subsystem.
const CC_REVEN = "REVENANT"
/// Defines the cc mancu text used by the d french subsystem.
const CC_MANCU = "MANCUBUS"
/// Defines the cc arch text used by the d french subsystem.
const CC_ARCH = "ARCHI-INFAME"
/// Defines the cc spider text used by the d french subsystem.
const CC_SPIDER = "L'ARAIGNEE CERVEAU"
/// Defines the cc cyber text used by the d french subsystem.
const CC_CYBER = "LE CYBERDEMON"
/// Defines the cc hero text used by the d french subsystem.
const CC_HERO = "NOTRE HEROS"

// (end)



