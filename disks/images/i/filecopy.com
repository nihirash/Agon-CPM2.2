Ë
Livepo	� � �	>" > !>&!>! > !>p A???????'�� >&> >y ` C>  > 8&	?'��"!>8 !> >  '��  0!> >y !>` C>  > 8&	'��& 8 > >y !>` C>  > 8&	'��08 >  >"!'��  >> 8&!>"!'
350 PRINT CHR$(12)
360 FOR X=1 TO 4
370 STD(X)=INT(RND(X)*10)
380 NEXT X
390 G=0
400 G=G+1
410 IF G>20*S1 THEN 750
420 FOR I=1 TO 4
430 TRAN(I)=STD(I)
440 NEXT I
450 B=0
460 C=0
470 PRINT "Guess";G;
480 INPUT;"= ",X: X=X+.5
490 FOR I=1 TO 4180,180,820,1400
180 PRINT "Instructions";
190 AL$=INPUT$(1)
200 IF AL$="Y" OR AL$="y" THEN 230
210 IF AL$="N" OR AL$="n" THEN 350
220 GOTO 190
230 PRINT:PRINT
235 PRINT "Guess my 4-digit number by putting in such numbers, e.g. 1012."
240 PRINT "(P00 WRITE#2,DT,DF(1),DF(2),CA1%,CA2$,TI%,SUM,SA(DF(1)),SA(DF(2))
1210 FOR I=1 TO DP
1220 IF C1%(I)=CA1% THEN 123�>B`��>q!I	 py!f f	��>Hc>I>N`C>HB?2F8>	9ѕɹ���ɕ��ɐ��ɥ�ЁѼ����B~D$@ p$g��2&>|"2� "2�   ���2&>|�& �