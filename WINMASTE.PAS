program MasterMind;

{$R+V+}

uses Crt, Turbo3;

type
  TComb=array[1..5] of 1..7;
  TTentativi=array[1..7] of TComb;
  TRisultati=array[1..7,1..2] of byte;
  TPunt=^TLista;
  TLista=record
           PComb:TComb;
           Next:TPunt;
         end;
  Str=string[80];

const
  CodColori:  array[1..7] of byte=(Brown,LightCyan,LightGreen,
                                   LightRed,Yellow,White,Magenta);
  NomeColori: array[1..7] of char=('M','A','V','R','G','B','W');
  SetColori:  set of char=['M','A','V','R','G','B','W'];
  X=2;
  DX=22;
  Y=2;
  DY=77;

var
  Soluzione: TComb;
  Tentativo: TTentativi;
  Risultato: TRisultati;
  PunT:TPunt;
  Loop,Npt: integer;
  Scelta:char;
  MultiColor: boolean;

{ ************************************************************************* }
{            M O D U L O   D I   G R A F I C A   W I N D O W                }
{ ************************************************************************* }

procedure  WinBoxW(X,DX,Y,DY:integer);
var
  Loop:integer;
  {
  * Disegna la cornice esterna della finestra e la sua ombra.
  * Are usabile : il rettangolo con spigoli (X+1,Y+1) e (X+DX-2,Y+DY-3)
  }
begin
  textcolor(Black);
  textbackground(LightGray);
  gotoxy(Y,X);
  write('ÉÍÍÍ¹þ³');
  gotoxy(Y+DY-6-2,X);
  write('³þÌÍÍÍ»');
  for Loop:=X+1 to X+DX-2 do
    begin
      gotoxy(Y,Loop);
      write('º');
      gotoxy(Y+DY-2,Loop);
      write('º');
    end;
  gotoxy(Y,X+DX-1);
  write('È');
  gotoxy(Y+DY-2,X+DX-1);
  write('¼');
  for Loop:=Y+1 to Y+DY-3 do
    begin
      gotoxy(Loop,X+DX-1);
      write('Í');
    end;
  for Loop:=Y+1 to Y+DY do
    begin
      gotoxy(Loop,X+DX);
      write('Û');
    end;
  for Loop:=X+1 to X+DX do
    begin
      gotoxy(Y+DY-1,Loop);
      write('ÛÛ');
    end;
end;

procedure WinBoxS(X,DX,Y,DY:integer);
var
  Loop:integer;
  {
  * Disegna uno spesore interno a una finestra.
  * Area usabile : il rettangolo di spigoli (X+1,Y+1) e (X+DX-1,Y+DY-1).
  }
begin
  textcolor(Black);
  textbackground(LightGray);
  gotoxy(Y,X);
  write('Ú');
  for Loop:=Y+1 to Y+DY-1 do
     begin
       gotoxy(Loop,X);
       write('Ä');
     end;
  for Loop:=X+1 to X+DX do
     begin
       gotoxy(Y,Loop);
       write('³');
     end;
  textcolor(White);
  gotoxy(Y,X+DX+1);
  write('À');
  gotoxy(Y+DY,X);
  write('¿');
  for Loop:=X+1 to X+DX do
     begin
       gotoxy(Y+DY,Loop);
       write('³');
     end;
  for Loop:=Y+1 to Y+DY-1 do
     begin
       gotoxy(Loop,X+DX+1);
       write('Ä');
     end;
  gotoxy(Y+DY,X+DX+1);
  write('Ù');
end;

procedure WinPre(X,DX,Y,DY:integer);
  {
  * Prepara il fondo in tinta per il bordo di una finestra.
  * Va richiamata con gli stessi parametri.
  }
begin
  textbackground(LightGray);
  window(Y+1,X+1,Y+DY-3,X+DX-2);
  clrscr;
  window(1,1,80,25);
end;

procedure WinBase;
  {
  * Disegna la maschera base con i campi standard.
  * Area usabile : in base a WinBoxS Š di spigoli (X+2,Y+3) e (X+DX-4,Y+DY-5).
  }
begin
  window(1,1,80,25);
  textmode(C80);
  textbackground(Blue);
  clrscr;
  WinPre(X,DX,Y,DY);
  WinBoxS(X+1,DX-4,Y+2,DY-6);
  WinBoxW(X,DX,Y,DY);
  textbackground(Black);
  window(1,1,80,25);
  gotoxy(Y+7,X);
  write('                                                              ');
  window(Y+3,X+3,Y+DY-5,X+DX-5);
end;

procedure WinHelp;
  {
  * Disegna la finestra di help.
  }
begin
  window(1,1,80,25);
  textmode(C80);
  textbackground(Blue);
  WinPre(6,13,7,55);
  { WinBoxS(X+1,DX-4,Y+2,DY-6);}
  WinBoxW(6,13,7,55);
  textbackground(Black);
  window(1,1,80,25);
  textcolor(Yellow);
  gotoxy(8,17);write('     ESC fine   /   PagSu,PagGi— scorre il testo    ');
  gotoxy(14,6);write('               A I U T O                ');
end;

procedure WinTes(Stringa:Str);
begin
  textcolor(Yellow);
  textbackground(Black);
  window(1,1,80,25);
  gotoxy(Y+7,X);
  write(Stringa);
  window(Y+3,X+2,Y+DY-5,X+DX-3);
  textbackground(LightGray);
  textcolor(LightCyan);
  clrscr;
end;


Procedure HelpText(x,dx,y,dy:integer;Ttesto:Str);

VAR
    Testo : Text;
    Linea : string[80];
    pos,
    rel_pos,i   : integer;
    c1,c2  : char;
    finito,
    letto  : boolean;
    pag,clc,clf : integer;

PROCEDURE Posiziona(pos:integer);
VAR
    i : integer;
BEGIN
   reset(testo);
   FOR i:=1 TO pos DO
      readln(testo,linea);
END;

BEGIN
   clc:=10;
   clf:=7;
   textcolor(clc);
   textbackground(clf);
   window(y,x,y+dy-1,x+dx-1);
   pag:=dx;
   clrscr;
   assign(Testo,Ttesto);
   reset(Testo);
   pos:=0;
   finito:=false;
   WHILE NOT finito DO
      BEGIN
         rel_pos:=pag;
         clrscr;
         WHILE NOT(eof(Testo)) AND (rel_pos>0) DO
            BEGIN
               rel_pos:=rel_pos-1;
               readln(Testo,linea);
               gotoxy(1,pag-rel_pos);
               write(linea);
            END;
         letto:=false;
         WHILE NOT letto DO
            BEGIN
               REPEAT
               UNTIL keypressed;
               read(kbd,c1);
               IF keypressed AND (ord(c1)=27) THEN
                  BEGIN
                     read(kbd,c2);
                     CASE ord(c2) OF
                        72,73 :  BEGIN
                                 pos:=pos-pag;
                                 IF pos<0 THEN
                                   pos:=0;
                                 posiziona(pos);
                                 letto:=true;
                                END;
                        80,81 :  BEGIN
                                 letto:=true;
                                 IF NOT(EOF(TESTO)) THEN
                                   pos:=pos+pag
                                 ELSE
                                   posiziona(pos);
                                END;
                     END;
                  END
               ELSE
                  IF ord(c1)=27 THEN
                     BEGIN
                        letto:=true;
                        finito:=true;
                     END;
            END;
      END;
END;


{ ************************************************************************* }
{                            P R O C E D U R E                              }
{ ************************************************************************* }

procedure InComb(var Combinazione:TComb;Mode:char;MC:boolean);

{ Inserimento controllato di una combinazione di 5 "pioli" }

var
  Loop,Loop2 :integer;
  Car        :char;
  SetComb    : set of 1..7;

begin
  SetComb:=[];
  gotoxy(33,13);
  if Mode='C'
    then write('Inserisci la Combinazione da cercare')  { gioca il computer }
    else write('    Inserisci il tuo tentativo');       { gioca un giocatore }
  gotoxy(33,14);
  write('      con le seguenti lettere.');
  gotoxy(44,15);
  for Loop:= 1 to 7 do
    begin
      textcolor(CodColori[Loop]);
      write(NomeColori[Loop],' ');
    end;
  textcolor(White);
  gotoxy(46,17);
  write('1 2 3 4 5');
  gotoxy(46,18);
  write('           ');
  gotoxy(46,18);
  Loop:=1;
  while (Loop<=5) or (Car<>#13) do
    begin
      read(kbd,Car);
      Car:=upcase(Car);
      if (Car in SetColori) and (Loop<=5) then
        begin { combinazione con colori distinti }
          for Loop2:=1 to 7 do
            if (NomeColori[Loop2]=Car) and (MC or not (Loop2 in SetComb)) then
              begin
                textcolor(CodColori[Loop2]);
                write('* ');
                Combinazione[Loop]:=Loop2;
                SetComb:=SetComb+[Loop2];
                Loop:=Loop+1;
              end;
        end
      else { combinazione con colori anche uguali }
        if (Car=#8) and (Loop>1) then
          begin
            SetComb:=SetComb-[Combinazione[Loop-1]];
            Loop:=Loop-1;
            gotoxy(wherex-2,wherey);
            write('  ');
            gotoxy(wherex-2,wherey);
          end;
    end;
  textcolor(Yellow);
end;

procedure OutComb(Numero:integer;Combinazione:Tcomb;Gpg,Gps:byte);

{ Stampa di una combinazione }

var
  Loop:integer;

begin
  gotoxy(1,4+Numero);
  write(Numero,'   ');
  for Loop:=1 to 5 do
    begin
      textcolor(CodColori[Combinazione[Loop]]);
      write('* ');
    end;
  textcolor(White);
  if Numero<>0 then
    write('    ',Gpg,'         ',Gps);
  textcolor(Yellow);
end;

procedure GeneraTentativoCasuale(var Tentativo:TComb; MC:boolean);

{ Genera una soluzione casuale se gioca il computer per effettuare il }
{ primo tentativo }

var
  Loop:integer;
  Indice: 1..7;
  ColorDisp: array [1..7] of 1..7;

begin
  if MC
    then
      for Loop:=1 to 5 do
        Tentativo[Loop]:=random(7)+1
    else
      begin
        for Loop:=1 to 7 do
          ColorDisp[Loop]:=Loop;
          for Loop:=1 to 5 do
            begin
              Indice:=random(7+1-Loop)+1;
              Tentativo[Loop]:=ColorDisp[Indice];
              ColorDisp[Indice]:=ColorDisp[7+1-Loop];
            end;
      end;



end;

procedure Confronta(Soluzione,Tentativo:Tcomb;var Gpg,Gps:byte);

{ Confronta un tentativo con la soluzione indicando i "pioli" di colore }
{ giusto al posto giusto e i "pioli" di colore giusto ma al posto errato }

var
  Sol:array[1..5] of 0..7;
  Loop,Loop2:integer;

begin
  Gpg:=0;
  Gps:=0;
  for Loop:=1 to 5 do
    Sol[Loop]:=Soluzione[Loop];
  for Loop:=1 to 5 do
    if Sol[Loop]=Tentativo[Loop]
      then
        begin
          Sol[Loop]:=0;
          Gpg:=Gpg+1;
        end
      else
       begin
         Loop2:=0;
         repeat
           Loop2:=Loop2+1;
         until ((Sol[Loop2]=Tentativo[Loop]) and
                (Sol[Loop2]<>Tentativo[Loop2])) or (Loop2=5);
         if (Sol[Loop2]=Tentativo[Loop]) and (Sol[Loop2]<>Tentativo[Loop2]) then
           begin
             Sol[Loop2]:=0;
             Gps:=Gps+1;
           end;
       end;
end;

procedure EseguiTentativo(PunT:TPunt;Num:integer;var Tentativo:TComb);

{ Quando gioca il computer per eseguire un tentativo lo cerca all'interno }
{ di una lista concatenata di possibili tentativi }

var
  Loop:integer;
  TmpPunt:TPunt;

begin
  TmpPunt:=PunT;
  Loop:=random(Num)+1;
  while Loop>1 do
    begin
      Loop:=Loop-1;
      TmpPunt:=TmpPunt^.next;
    end;
  Tentativo:=TmpPunt^.PComb;
end;

procedure GeneraListaTentativi(Var PunT:TPunt;Tentativo:TComb;Gpg,Gps:byte;
                               Var Num:integer;MC:boolean);

{ Genera una lista concatenata di tutti i possibili tentati }

var
  Loop1,Loop2,Loop3,
  Loop4,Loop5       :1..7;
  PosTent:TComb;
  TGpg,TGps         :byte;
  TmpPunt:TPunt;
  ColorDisp: array [1..7,1..7] of 1..7;

  procedure In_Lista;
  begin
    Confronta(PosTent,Tentativo,TGpg,TGps);
    if (TGps=Gps) and (TGpg=Gpg) then
      begin
        if Num=0
          then
            begin
              new(PunT);
              TmpPunt:=PunT;
            end
          else
            begin
              new(TmpPunt^.Next);
              TmpPunt:=TmpPunt^.Next;
            end;
        TmpPunt^.PComb:=PosTent;
        Num:=Num+1;
      end;
  end;

begin
  Num:=0;
  write('    .......');
  gotoxy(wherex-7,wherey);
  If MC then { con soluzioni possibili con colori anche uguali }
    for Loop1:=1 to 7 do
      begin
        PosTent[1]:=Loop1;
        for Loop2:=1 to 7 do
          begin
            PosTent[2]:=Loop2;
            for Loop3:=1 to 7 do
              begin
                PosTent[3]:=Loop3;
                for Loop4:=1 to 7 do
                  begin
                    PosTent[4]:=Loop4;
                    for Loop5:=1 to 7 do
                      begin
                        PosTent[5]:=Loop5;
                        In_Lista;
                      end;
                  end;
              end;
          end;
        write(' ');
      end
  else begin  { con soluzioni con colori distinti }
    for Loop1:=1 to 7 do
      ColorDisp[1,Loop1]:=Loop1;
    for Loop1:=1 to 7 do
      begin
        PosTent[1]:=ColorDisp[1,Loop1];
        ColorDisp[2]:=ColorDisp[1];
        ColorDisp[2,Loop1]:=ColorDisp[2,7];
        for Loop2:=1 to 6 do
          begin
            PosTent[2]:=ColorDisp[2,Loop2];
            ColorDisp[3]:=ColorDisp[2];
            ColorDisp[3,Loop2]:=ColorDisp[3,6];
            for Loop3:=1 to 5 do
              begin
                PosTent[3]:=ColorDisp[3,Loop3];
                ColorDisp[4]:=ColorDisp[3];
                ColorDisp[4,Loop3]:=ColorDisp[4,5];
                for Loop4:=1 to 4 do
                  begin
                    PosTent[4]:=ColorDisp[4,Loop4];
                    ColorDisp[5]:=ColorDisp[4];
                    ColorDisp[5,Loop4]:=ColorDisp[5,4];
                    for Loop5:=1 to 3 do
                      begin
                        PosTent[5]:=ColorDisp[5,Loop5];
                        In_Lista;
                      end;
                  end;
              end;
          end;
        write(' ');
      end;
  end;
  gotoxy(wherex-7,wherey);
  TmpPunt^.Next:=nil;
end;

procedure AggiornaListaTentativi(var PunT:TPunt;NT:integer;Tentativo:TTentativi;
                                 Risultato:TRisultati;var Num:integer);

{ Aggiorna la lista tentativi utilizzando il contenuto informativo dell'ultimo }
{ tentativo effettuato, ossia il tentativo e i "pioli" giusti al posto giusto, }
{ e i pioli "giusti" al posto errato }

var
  Gpg,Gps         :byte;
  TmpPunt,PrePunt,ToDel:TPunt;
  Primo:boolean;

 begin
  Primo:=true;
  TmpPunt:=PunT;
  while TmpPunt<>nil do
    begin
      Confronta(TmpPunt^.PComb,Tentativo[NT],Gpg,Gps);
      if (Gpg=Risultato[NT,1]) and (Gps=Risultato[NT,2])
        then
          begin
            PrePunt:=TmpPunt;
            TmpPunt:=TmpPunt^.Next;
            if Primo then Primo:=false;
          end
        else
          begin
            ToDel:=TmpPunt;
            if Primo
              then PunT:=PunT^.Next
              else PrePunt^.Next:=PrePunt^.Next^.Next;
            TmpPunt:=TmpPunt^.Next;
            dispose(ToDel);
            Num:=Num-1;
            if Num=0 then
              PunT:=nil;
          end;
    end;
 end;

procedure GiudicaTentativo(Num:integer;Tentativo:TTentativi;
                          Risultato:TRisultati);

{ Se gioca un giocatore, verifica se un tentativo da lui effettuato tiene }
{ conto o meno del contenuto informativo dei tentativi da lui prevedentemente }
{ effettuati }

var
  Loop,
  Gpg,Gps:byte;
  Giusto:boolean;
begin
  Giusto:=true;
  for Loop:=1 to Num-1 do
    begin
      Confronta(Tentativo[Num],Tentativo[Loop],Gpg,Gps);
      if (Gpg<>Risultato[Loop,1]) or (Gps<>Risultato[Loop,2]) then
        if Giusto then
          begin
            write('      No      ',Loop);
            Giusto:=false;
          end
        else
          write(',',Loop);
    end;
  if giusto then write('      Si');
end;

{ ************************************************************************* }
{ ************************************************************************* }
{                            P R I N C I P A L E                            }
{ ************************************************************************* }
{ ************************************************************************* }

begin
  repeat
  WinBase;
  WinTes('           MASTER MIND  1.01      di Minudel Luca');
  writeln;
  writeln('1 -  Per giocare; la soluzione ha tutti i colori diversi');
  writeln;
  writeln('2 -  Per giocare; la soluzione potrebbe avere colori uguali');
  writeln;
  writeln('3 -  Gioca il computer, indica la soluzione con tutti colori diversi');
  writeln;
  writeln('4 -  Gioca il computer, indica la soluzione anche con colori uguali');
  writeln;
  writeln('              5 -  Istruzioni del programma ');
  writeln;
  writeln('                        6 -  Fine');
  writeln;writeln;writeln;
  write('                            => ');
  repeat
    read(kbd,Scelta);
    Scelta:=upcase(Scelta);
  until Scelta in ['1','2','3','4','5','6'];
  write(Scelta);
  if Scelta='5' then
  begin
    WinHelp;
    HelpText(7,10,8,52,'masterm.hlp');
  end
  else
  begin
  if Scelta<>'6' then begin
  if scelta in ['2','4']
    then MultiColor:=true
    else MultiColor:=false;
  delay(400);
  clrscr;
  if Scelta in ['3','4']
    then
      begin
        gotoxy(5,1);write('Tentativi³Giusti al³Giusti al ³Numero delle');
        gotoxy(5,2);write('   del   ³  posto  ³  posto   ³soluzioni');
        gotoxy(5,3);write('Computer ³ giusto. ³sbagliato.³possibili.');
        gotoxy(5,4);write('ÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ');
        InComb(Soluzione,'C',MultiColor);
        GeneraTentativoCasuale(Tentativo[1],MultiColor);
        Confronta(Soluzione,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        OutComb(1,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        GeneraListaTentativi(PunT,Tentativo[1],Risultato[1,1],Risultato[1,2],Npt,MultiColor);
        gotoxy(40,5);write(Npt);
        Loop:=1;
        Repeat
          Loop:=Loop+1;
          EseguiTentativo(PunT,Npt,Tentativo[Loop]);
          Confronta(Soluzione,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          OutComb(Loop,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          AggiornaListaTentativi(PunT,Loop,Tentativo,Risultato,Npt);
          gotoxy(40,4+Loop);write(Npt);
       Until (Loop=7) or (Risultato[Loop,1]=5);
       if Risultato[Loop,1]=5 then
         begin
           writeln;
           writeln;
           textcolor(Red+Blink);
           writeln('    TROVATA');
           writeln('  LA SOLUZIONE');
           write('=>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(Red+Blink);
           write(' <=');
         end;
       repeat until keypressed;
      end
   else
     begin
        gotoxy(5,1);write('    I    ³Giusti al³Giusti al³ Numero  ³ Mossa  ³   Non ');
        gotoxy(5,2);write('  tuoi   ³  posto  ³  posto  ³soluzioni³corretta³consideri i');
        gotoxy(5,3);write('tentativi³ giusto. ³ errrato ³possibili³   ?    ³tentativi :');
        gotoxy(5,4);write('ÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ');
        GeneraTentativoCasuale(Soluzione,MultiColor);
        InComb(Tentativo[1],'T',MultiColor);
        Confronta(Soluzione,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        OutComb(1,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        GeneraListaTentativi(PunT,Tentativo[1],Risultato[1,1],Risultato[1,2],Npt,MultiColor);
        gotoxy(37,5);write(Npt:5);
        Loop:=1;
        Repeat
          Loop:=Loop+1;
          InComb(Tentativo[Loop],'T',MultiColor);
          Confronta(Soluzione,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          OutComb(Loop,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          AggiornaListaTentativi(PunT,Loop,Tentativo,Risultato,Npt);
          gotoxy(37,4+Loop);write(Npt:5);
          GiudicaTentativo(Loop,Tentativo,Risultato);
       Until (Loop=7) or (Risultato[Loop,1]=5);
       if Risultato[Loop,1]<>5 then
         begin
           writeln;
           writeln;
           textcolor(Red+Blink);
           writeln('    SOLUZIONE');
           write('=>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(Red+Blink);
           write(' <=');
         end
       else
         begin
           writeln;
           writeln;
           textcolor(Red+Blink);
           writeln('  HAI  TROVATO');
           writeln('  LA SOLUZIONE');
           write('=>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(Red+Blink);
           write(' <=');
         end;
        repeat until keypressed;
     end;
     end;
     end;
  until Scelta='6';
  window(1,1,80,25);
  gotoxy(1,24);
end.