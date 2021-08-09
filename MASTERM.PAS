program MasterMind;

{$R+V+}

uses Turbo3, Graph3, Crt;

type
  TComb=array[1..5] of 1..7;
  TTentativi=array[1..7] of TComb;
  TRisultati=array[1..7,1..2] of byte;
  TPunt=^TLista;
  TLista=record
           PComb:TComb;
           Next:TPunt;
         end;

const
  CodColori:  array[1..7] of byte=(Brown,LightCyan,LightGreen,
                                   LightRed,Yellow,White,Magenta);
  NomeColori: array[1..7] of char=('M','A','V','R','G','B','W');
  SetColori:  set of char=['M','A','V','R','G','B','W'];

var
  Soluzione: TComb;
  Tentativo: TTentativi;
  Risultato: TRisultati;
  PunT:TPunt;
  Loop,Npt: integer;
  Scelta:char;
  MultiColor: boolean;

{ ************************************************************************* }
{                            P R O C E D U R E                              }
{ ************************************************************************* }

procedure InComb(var Combinazione:TComb;Mode:char;MC:boolean);

var
  Loop,Loop2 :integer;
  Car        :char;
  SetComb    : set of 1..7;

begin
  SetComb:=[];
  gotoXY(45,19);
  if Mode='C'
    then write('Inserisci la Combinazione da cercare')
    else write('    Inserisci il tuo tentativo');
  gotoxy(45,20);
  write('      con le seguenti lettere.');
  gotoxy(56,21);
  for Loop:= 1 to 7 do
    begin
      textcolor(CodColori[Loop]);
      write(NomeColori[Loop],' ');
    end;
  textcolor(White);
  gotoxy(58,23);
  write('1 2 3 4 5');
  gotoxy(58,24);
  write('           ');
  gotoxy(58,24);
  Loop:=1;
  while (Loop<=5) or (Car<>#13) do
    begin
      read(kbd,Car);
      Car:=upcase(Car);
      if (Car in SetColori) and (Loop<=5) then
        begin
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
      else
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

var
  Loop:integer;

begin
  gotoxy(5,3+2*Numero);
  write(Numero,'     ');
  for Loop:=1 to 5 do
    begin
      textcolor(CodColori[Combinazione[Loop]]);
      write('* ');
    end;
  textcolor(White);
  if Numero<>0 then
    write('    ',Gpg,'               ',Gps);
  textcolor(Yellow);
end;

procedure GeneraTentativoCasuale(var Tentativo:TComb; MC:boolean);

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
  If MC then
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
  else begin
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
            write('         No      ',Loop);
            Giusto:=false;
          end
        else
          write(',',Loop);
    end;
  if giusto then write('         Si');
end;

{ ************************************************************************* }
{ ************************************************************************* }
{                            P R I N C I P A L E                            }
{ ************************************************************************* }
{ ************************************************************************* }

begin
  clrscr;
  writeln;
  writeln;
  writeln;
  writeln('                             M A S T E R    M I N D ');
  writeln('                                 di Minudel Luca');
  writeln;
  writeln;
  writeln('        1 -  Per giocare; la soluzione ha tutti i colori diversi');
  writeln;
  writeln('        2 -  Per giocare; la soluzione potrebbe avere colori uguali');
  writeln;
  writeln('        3 -  Gioca il computer, indica la soluzione con tutti i colori diversi');
  writeln;
  writeln('        4 -  Gioca il computer, indica la soluzione anche con colori uguali');
  writeln;writeln;writeln;writeln;
  write('                                     => ');
  repeat
    read(kbd,Scelta);
    Scelta:=upcase(Scelta);
  until Scelta in ['1','2','3','4'];
  write(Scelta);
  if scelta in ['2','4']
    then MultiColor:=true
    else MultiColor:=false;
  delay(400);
  clrscr;
  gotoxy(1,22);
  if Scelta in ['3','4']
    then
      begin
        gotoxy(11,1);write('Tentativi ³ Giusti al ³ Giusti al  ³  Numero delle');
        gotoxy(11,2);write('   del    ³   posto   ³   posto    ³  soluzioni');
        gotoxy(11,3);write('Computer  ³  giusto.  ³ sbagliato. ³  possibili.');
        InComb(Soluzione,'C',MultiColor);
        GeneraTentativoCasuale(Tentativo[1],MultiColor);
        Confronta(Soluzione,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        OutComb(1,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        GeneraListaTentativi(PunT,Tentativo[1],Risultato[1,1],Risultato[1,2],Npt,MultiColor);
        gotoxy(50,5);write(Npt);
        Loop:=1;
        Repeat
          Loop:=Loop+1;
          EseguiTentativo(PunT,Npt,Tentativo[Loop]);
          Confronta(Soluzione,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          OutComb(Loop,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          AggiornaListaTentativi(PunT,Loop,Tentativo,Risultato,Npt);
         gotoxy(50,3+2*Loop);write(Npt);
       Until (Loop=7) or (Risultato[Loop,1]=5);
       if Risultato[Loop,1]=5 then
         begin
           writeln;
           writeln;
           textcolor(LightMagenta+Blink);
           writeln('    TROVTA LA SOLUZIONE !');
           write('     ==>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(LightMagenta+Blink);
           write(' <==');
         end
      end
   else
     begin
        gotoxy(11,1);write('    I     ³ Giusti al ³ Giusti al ³  Numero   ³  Mossa   ³    Non ');
        gotoxy(11,2);write('  tuoi    ³   posto   ³   posto   ³ soluzioni ³ corretta ³ considera i');
        gotoxy(11,3);write('tentativi ³  giusto.  ³  errrato  ³ possibili ³    ?     ³ tentativi :');
        GeneraTentativoCasuale(Soluzione,MultiColor);
        InComb(Tentativo[1],'T',MultiColor);
        Confronta(Soluzione,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        OutComb(1,Tentativo[1],Risultato[1,1],Risultato[1,2]);
        GeneraListaTentativi(PunT,Tentativo[1],Risultato[1,1],Risultato[1,2],Npt,MultiColor);
        gotoxy(48,5);write(Npt:5);
        Loop:=1;
        Repeat
          Loop:=Loop+1;
          InComb(Tentativo[Loop],'T',MultiColor);
          Confronta(Soluzione,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          OutComb(Loop,Tentativo[Loop],Risultato[Loop,1],Risultato[Loop,2]);
          AggiornaListaTentativi(PunT,Loop,Tentativo,Risultato,Npt);
          gotoxy(48,3+2*Loop);write(Npt:5);
          GiudicaTentativo(Loop,Tentativo,Risultato);
       Until (Loop=7) or (Risultato[Loop,1]=5);
       if Risultato[Loop,1]<>5 then
         begin
           writeln;
           writeln;
           textcolor(LightMagenta+Blink);
           writeln('          SOLUZIONE ');
           write('     ==>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(LightMagenta+Blink);
           write(' <==');
         end
       else
         begin
           writeln;
           writeln;
           textcolor(LightMagenta+Blink);
           writeln(' HAI TROVATO LA SOLUZIONE !!');
           write('     ==>  ');
           for Loop:=1 to 5 do
             begin
               textcolor(CodColori[Soluzione[Loop]]);
               write('* ');
            end;
           textcolor(LightMagenta+Blink);
           write(' <==');
         end
     end;
  gotoxy(1,24);
end.