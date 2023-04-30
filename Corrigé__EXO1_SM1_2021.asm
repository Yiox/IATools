;-----------------------------------------------------------------------------
;  FILE NAME   :  EXO_SM1.asm
;  TARGET MCU  :  C8051F020 
;  DESCRIPTION :  Cette suite d'exercices de base est destinée à faire
;                 découvrir le jeu d'instruction de la famille 8051.
;                 Insérez votre code sous chaque exercice.
;                 A la fin de la séance, vous rendrez ce fichier via E-campus
;                 ou par Email à l'adresse que l'on vous communiquera
;                 
;******************************************************************************
;******************************************************************************
; NE PAS MODIFIER LES DIRECTIVES et INSTRUCTIONS SUIVANTES:
;******************************************************************************
$include (c8051f020.inc)               ; Include register definition file.
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
GREEN_LED      equ   P1.6              ; Port I/O pin connected to Green LED.
;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

               ; Reset Vector
               cseg AT 0
               ljmp Main               ; Locate a jump to the start of code at 
                                       ; the reset vector.

;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------
Blink          segment  CODE

               rseg     Blink        ; Switch to this code segment.
               using    0            ; Specify register bank for the following
                                     ; program code.

Table_ex:          db  'VOILA UN EXEMPLE DE CHAINE A COPIER!!!'

;Initialisations de périphériques - Fonctionnalités Microcontroleur

Main:          ; Disable the WDT. (IRQs not enabled at this point.)
               ; If interrupts were enabled, we would need to explicitly disable
               ; them so that the 2nd move to WDTCN occurs no more than four clock 
               ; cycles after the first move to WDTCN.
               mov   WDTCN, #0DEh
               mov   WDTCN, #0ADh
               ; Enable the Port I/O Crossbar
               mov   XBR2, #40h
               ; Set P1.6 (LED) as digital output in push-pull mode.  
               orl   P1MDIN, #40h	 
               orl   P1MDOUT,#40h 
; Programme Principal
;******************************************************************************
;******************************************************************************
; VOUS POUVEZ FAIRE des MODIFICATIONS A PARTIR D'ICI
;******************************************************************************


;EXO 1 : INSTRUCTIONS DE TRANSFERT DE DONNEES

;1.	Initialiser l'accumulateur à 0, le registre R0 à FFh et la case d'adresse mémoire 40h de la mémoire RAM interne à 55h.
	CLR A
	MOV R0,#0FFH
	MOV 40H,#55H
	
 
;2.	Copier le contenu de l'accumulateur dans le registre R1.
	MOV R1,A

;3.	Copier le contenu de la mémoire 40h de la RAM interne dans la case 42h de la RAM Interne.
	MOV 42H,40H

;4.	Copier le contenu de la mémoire 40h de la RAM interne dans la case D0h de la RAM Interne à accès indirect. Que se passe-t-il si on utilise par erreur l'adressage direct sur D0h?
	MOV R1,#0D0H
	MOV @R1,40H
;	Solution fausse
	MOV R1,#040H
	MOV 0D0H,@R1   ; Cette solution ne fait pas ce qui est demandé. On accède la mémoire 40H en indirect (pourquoi pas...) mais on on accède ici à D0H en direct. En direct, on fait 
	               ; référence au registre D0H dans l'espace SFR, ce qui correspond au registre PSW ( on n'accède donc pas à la mémoire RAM d'adresse  0D0H)   


;EXO 2 : MANIPULATION DES ESPACES MEMOIRES

;1.	Copier le contenu de 20h (DATA) dans la case mémoire 2FFh en mémoire RAM externe (XDATA).
	MOV DPTR,#2FFH
	MOV A,20H
	MOVX @DPTR,A

;2.	Copier le contenu de 0000h (CODE) dans la case mémoire 82h en mémoire RAM interne.
MOV DPTR,#0
	MOV A,#0
	MOVC A,@A+DPTR
	MOV R0,#82H 
	MOV @R0,A    ; Adressage indirect car 82H en RAM n'est accessible qu'en adressage indirect
;   MOV 82H,A    Solution fausse: on écrit dans la case mémoire 82H de l'espace SFR!
 
;3.	Copier le contenu de la mémoire 0100h de la XDATA dans la case 43h de la RAM Interne.
MOV DPTR,#100H
	MOVX A,@DPTR
	MOV 43H,A
;4.	Copier le contenu de la mémoire 1234h de la mémoire CODE dans la case 0102h de la mémoire XDATA.
    MOV DPTR,#1234H
	MOV A,#0
	MOVC A,@A+DPTR  ; lecture dans la mémoire CODE
	MOV DPTR,#102H
	MOVX @DPTR,A    ; Ecriture dans la mémoire XDATA


;EXO 3 : INSTRUCTIONS ARITHMETIQUES - ARITHMETIQUE NON SIGNEE

;1.	Incrémenter l'accumulateur de 1.
	INC A

;2.	Décrémenter de 1 l'octet d'adresse 33h de la RAM Interne.
    DEC 33H

;3.	Echanger le contenu de B avec le contenu de la mémoire 07FFh en mémoire externe (XDATA).
    MOV DPTR,#7FFH
	MOVX A,@DPTR
	XCH  A,B
    MOVX @DPTR,A
	
;4.	En une ligne de code, échanger le contenu de A avec le contenu de la mémoire 60h.
    XCH  A,60H


;EXO 4 : INSTRUCTIONS LOGIQUES - MANIPULATION de BITS

;1.	Complémenter le bit d'adresse 10h. Ou se trouve-t-il ? (c'est le bit X de l'octet d'adresse YY dans la mémoire DATA).
    CPL 10H  ; l'espace accessible bit à bit comence à l'adresse octet 20H. 10H (16 en décimal) correspond donc  au 
	         ; dix-septième bit de l'espace adressable bit à bit: 
			 ; adresse octet 20H -->Adresses bit de 0 à 07H 
			 ; adresse octet 21H -->Adresses bit de 08H à 0FH 
			 ; adresse octet 22H -->Adresses bit de 10H à 17H 
			; --> 10H correspond donc au bit 0 (bit de poids faible) de l'adresse octet 22H 



;2.	Mettre à 1, les bits 0 et 7  de l'octet d'adresse 22h de la RAM interne (sans changer les autres bits).
    SETB 10H
	SETB 17H

;3.	Mettre à 1, les bits 0 et 7 du registre R0 (sans changer les autres bits).
;  Solution par déplacement dans un registre accessible bit à bit
    MOV A,R0
	SETB ACC.0
	SETB ACC.7
	MOV R0,A
; Solution par masquage avec l'instruction ORL direct,#data
    ORL  AR0,#10000001B ;l'adressage direct de l'opérande de destination ne permet pas d'écrire "R0". On écrit "AR0" pour signifier
                          ; au programme assembleur que l'opérande de destination (adressage direct) est l'adresse occupée par le registre R0 du banc en cours d'utilisation	
;4.	Mettre à 1, les bits 0 et 7 de l'octet d'adresse 07ffh de la XDATA (sans changer les autres bits)

	MOV DPTR,#07FFH
	MOVX A,@DPTR
	SETB ACC.0
	SETB ACC.7
	MOVX @DPTR,A	


;EXO 5 : INSTRUCTIONS DE SAUT CONDITIONNEL ET INCONDITIONNE

;1.	Placez une valeur quelconque dans R3, incrémentez la jusqu'à ce qu'elle atteigne la valeur B6h (pensez à initialiser R3).
    MOV R3,#0B0H
BCL_EX05_1:	
	INC R3
	CJNE R3,#0B6H,BCL_EX05_1

;2.	Remplir la mémoire RAM interne de l'adresse 20h à 40h avec des codes ASCII égrainant l'alphabet.
	MOV  A,#'A'
	MOV  R0,#20H
BCL_EX05_2:	
	MOV  @R0,A
	INC  R0
	INC A
	CJNE A,#'Z'+1,BCL_EX05_2b
	MOV  A,#'A'
BCL_EX05_2b:	
	CJNE R0,#41H,BCL_EX05_2

;3.	Lire le contenu de l'adresse 0000h à 0002h dans l'espace code et le copier à l'adresse 0000h à 0002h de l'espace XDATA.
	MOV DPTR,#0000H
	MOV R3,#03H
BCL_EX05_3:
    CLR A
	MOVC A,@A+DPTR
	MOVX @DPTR,A
	INC  DPTR
	DJNZ R3,BCL_EX05_3
    


;EXO 6 : MANIPULATION DES BANCS de REGISTRES R0-R7

;1.	Commuter le banc de registres R0-R7 sur le banc 2 et copier le contenu de A dans le registre R4 sans utiliser "R4" dans l'instruction.
	CLR PSW.3   ; bit RS0 de PSW
	SETB PSW.4  ; bit RS0 de PSW
	MOV  14H,ACC  ; Car l'adresse de R4 dans le bac 2 est 14H

;2.	Mettre à zéro la case d'adresse 08h de la ram interne en utilisant un adressage par registre (utiliser un registre R0...R7).
	SETB PSW.3   ; Commutation banc 1
	CLR  PSW.4  ;
	MOV R0,#0



;EXO 7 : INSTRUCTIONS LOGIQUES - MANUIPULATION de BITS 

;1.	Décaler le registre B d'une case vers la gauche, le bit6 devient bit7, le bit5 devient bit6, etc. le bit7 devient bit0.
	MOV A,B
	RLC A
	MOV B,A

;2.	Exécuter une rotation logique gauche sur le DPTR, le bit 15 devient le bit 0. (Initialiser auparavant le DPTR avec la valeur 0F0Fh).
    MOV DPTR,#0F0FH
	CLR CY
	MOV A,DPL
	RLC A
	MOV DPL,A
	MOV A,DPH
	RLC A
	MOV DPH,A

;EXO 8 : INSTRUCTIONS ARITHMETIQUES - Arithmétique non signée 

;1.	Incrémenter de 2 la case mémoire RAM externe d'adresse 100h.
	MOV DPTR,#100H
	MOVX A,@DPTR
	ADD A,#2H
	MOVX @DPTR,A

;2.	Multiplier les données en RAM interne d'adresse 22h et 23h. Placer le résultat en 24h(LSB) et 25h(MSB).
    MOV A,22H
	MOV B,23H
	MUL AB
	MOV 25H,B
	MOV 24H,A



;EXO 9 : INSTRUCTIONS DE SAUT CONDITIONNEL ET INCONDITIONNEL 

;1.	Remplir la mémoire RAM externe (XDATA) de l'adresse 120h à 140h avec des codes ASCII égrainant l'alphabet.
BCL_CP SET 140H - 120H
	MOV DPTR,#120H
	MOV R3,#BCL_CP
	MOV A,#'A'
BCL_EX09_1:
    MOVX @DPTR,A
	INC A
	INC DPTR
	DJNZ R3,BCL_EX09_1
	
	
	

;2.	Incrémentez le DPTR initialisé avec une valeur quelconque jusqu'à la valeur de A B C D h.
	MOV DPTR,#1234H
BCL_EX09_2:
	INC DPTR
	MOV A,DPL
	CJNE A,#0CDH,BCL_EX09_2
	MOV A,DPH
	CJNE A,#0ABH,BCL_EX09_2	


;EXO 10 : FACULTATF, (A FAIRE A LA MAISON)

;1.	Additionner les registres R6 et R7, stocker le résultat dans R5. Quelles sont les limitations ? Pour s'affranchir des limitations précédentes, refaire la même opération mais stocker le résultat dans R4 (LSB) et R5(MSB).
    
	MOV A,R6
	ADD A,R7
	MOV R5,A
	
	MOV A,R6
	ADD A,R7
	MOV R4,A ;LSB
	CLR A
	RLC A
	MOV R5,A
	
;2.	Faire l'opération R0 moins R1 et placer le résultat dans R7. Que se passe t'il si R1>R0 ?
    CLR CY
    MOV R0,#022H
	MOV R1,#034H
	MOV A,R0
	SUBB A,R1

;3.	Complémenter le demi-octet de pds faible de l'adresse 2Ah de la RAM interne.
    CPL 2AH.0    ; Ecriture permise par le programme assembleur: Adresse octet.Numéro du bit 
	CPL 2AH.1	
	CPL 2AH.2
	CPL 2AH.3

;4.	Placez une valeur quelconque dans R3, décrémentez la, jusqu'à ce qu'elle atteigne une valeur contenue dans R6 (pensez à initialiser R3 et R6).
    CLR RS0
	CLR RS1
	MOV R3,#22H
	MOV R6,#18H
BCL_EX010_4:
	DEC R3
	MOV A,R3
	CJNE A,AR6,BCL_EX010_4
	
;5.	Initialiser les registres R4 et R5 respectivement avec les valeurs 0Fh et F5h. Faites un OU Exclusif entre ces deux registres et placez le résultat dans l'accumulateur.
    MOV R4,#0FH 
	MOV R5,#0F5H
	MOV A,R4
	XRL A,R5
	
;6.	Stocker le demi-octet de poids faible de la case mémoire d'adresse 44h de la RAM interne dans les deux demi-octets du registre R4 (si la case 44h contient 17h, alors R4 devra contenir 77h).
	MOV A,44H
	ANL A,#0FH
	MOV R4,A
	SWAP A
	ADD A,R4
	MOV R4,A
	
;7.	Elever au carré le contenu de l'octet 12h, placer le résultat dans R0 (pds fort) et R1 (pds faible).
    MOV A,#12H
	MOV B,#12H
	MUL AB
	MOV R0,B
	MOV R1,A

;8.	Soit 2 nombres BCD de 16 bits (valeur 0 à 9999) stockés respectivement dans R0(MSB)-R1(LSB) et R2(MSB)-R3(LSB). Faire l'addition BCD de ces deux nombres, et stocker le résultat dans R4(MSB)-R5(LSB). La retenue sera dans le bit Carry du registre PSW.
	MOV R0,#12H
	MOV R1,#34H
	MOV R2,#09H
	MOV R3,#99H
	CLR CY
	MOV A,R1
	ADDC A,R3
	DA A
	MOV R5,A
	MOV A,R0
	ADDC A,R2
	DA A
	MOV R4,A
	
;9.	Compter le nombre de bits à 1 dans le registre B et stocker le résultat dans R5.
	MOV A,B
	MOV R0,#8H
	MOV R5,#0
BCL_EX010_9:
	RLC A
	JNC  SUIT_EX010_9
	INC R5
 SUIT_EX010_9:
    DJNZ R0,BCL_EX010_9

;10.	Diviser le contenu du registre R7 par le nombre 10, placer le quotient dans R5 et le reste dans R6.
    MOV A,R7
	MOV B,#10
	DIV AB
	MOV R5,A
	MOV R6,B



;******************************************************************************
;******************************************************************************
; NE PAS MODIFIER LES DIRECTIVES et INSTRUCTIONS SUIVANTES:
;******************************************************************************
  
bcl:   jmp bcl
;-----------------------------------------------------------------------------
; End of file.

END



