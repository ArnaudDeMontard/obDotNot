//%attributes = {"lang":"en"} comment added and reserved by 4D.
//MACRO_OBtoDot 
//macro pour remplacer les OB FIXER et OB lire 
//  par la notation à point
//Conserve la version précédente en commentaires
//  au dessous de celle ré écrite
//Raccourci clavier = alt+cmde+o

//µ Arnaud * 23/07/2019 * gestion de OB FIXER TABLEAU
//© Arnaud * 17/07/2019 
//  partage : https://forums.4d.com/Post/FR/30700090/0/0/

GET MACRO PARAMETER:C997(Highlighted method text:K5:18;$find_t)

ARRAY LONGINT:C221($pos_al;0)
ARRAY LONGINT:C221($len_al;0)
$rxOBsetArray_t:=Command name:C538(1227)+"\\((.*);\"(.*)\";(.*)\\)"  //:C1227 = OB FIXER TABLEAU
$rxOBset_t:=Command name:C538(1220)+"\\((.*);\"(.*)\";(.*)\\)"  //:C1120 = OB FIXER
$rxOBget_t:="^(.*):="+Command name:C538(1224)+"\\((.*);\"(.*)\"(;(.*))?\\)"  //:C1224 = OB Lire
$replace_t:=""

Case of 
	: (Match regex:C1019($rxOBsetArray_t;$find_t;1;$pos_al;$len_al))
		$objet_t:=Substring:C12($find_t;$pos_al{1};$len_al{1})
		$propriete_t:=Substring:C12($find_t;$pos_al{2};$len_al{2})
		$valeur_t:=Substring:C12($find_t;$pos_al{3};$len_al{3})
		$replace_t:=$objet_t+"."+$propriete_t+":="+Command name:C538(1472)+"\r"  //New collection
		$replace_t:=$replace_t+Command name:C538(1563)+"("+$objet_t+"."+$propriete_t+";"+$valeur_t+")"  //ARRAY TO COLLECTION
		$replace_t:=$replace_t+"\r//"+$find_t
		
	: (Match regex:C1019($rxOBset_t;$find_t;1;$pos_al;$len_al))
		$objet_t:=Substring:C12($find_t;$pos_al{1};$len_al{1})
		$propriete_t:=Substring:C12($find_t;$pos_al{2};$len_al{2})
		$valeur_t:=Substring:C12($find_t;$pos_al{3};$len_al{3})
		$replace_t:=$objet_t+"."+$propriete_t+":="+$valeur_t
		$replace_t:=$replace_t+"\r//"+$find_t
		
	: (Match regex:C1019($rxOBget_t;$find_t;1;$pos_al;$len_al))
		$resultat_t:=Substring:C12($find_t;$pos_al{1};$len_al{1})
		$objet_t:=Substring:C12($find_t;$pos_al{2};$len_al{2})
		$propriete_t:=Substring:C12($find_t;$pos_al{3};$len_al{3})
		$conversion_t:=""
		If (Size of array:C274($pos_al)>4)  //constante de conversion
			$typage_t:=Substring:C12($find_t;$pos_al{5};$len_al{5})
			Case of 
				: ($typage_t="Est un texte") | ($typage_t="Is text")
					$conversion_t:=Command name:C538(10)  //Chaine
				: ($typage_t="Est un entier long") | ($typage_t="Est un numérique") | ($typage_t="Is longint") | ($typage_t="Is real")
					$conversion_t:=Command name:C538(11)  //Num
				: ($typage_t="Est un booléen") | ($typage_t="Is Boolean")
					$conversion_t:=Command name:C538(1537)  //Bool
				: ($typage_t="Est une date") | ($typage_t="Is date")
					$conversion_t:=Command name:C538(102)  //Date
				Else 
					//TRACE
			End case 
		End if 
		
		If ($conversion_t#"")
			$replace_t:=$resultat_t+":="+$conversion_t+"("+$objet_t+"."+$propriete_t+")"
		Else 
			$replace_t:=$resultat_t+":="+$objet_t+"."+$propriete_t
		End if 
		$replace_t:=$replace_t+"\r//"+$find_t
		
	Else 
		BEEP:C151  //motif non trouvé dans la sélection
		
End case 

If ($replace_t#"")
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18;$replace_t)
End if 
