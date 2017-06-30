unit imgjpg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JPEG, IdBaseComponent, IdComponent,
  IdTCPServer;

type
  Pixel = record
      B: byte;
      G: byte;
      R: byte;
  end;
  TForm1 = class(TForm)
    img1: TImage;
    Button1: TButton;
    OD1: TOpenDialog;
    Button5: TButton;
    Button9: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    IdTCPServer1: TIdTCPServer;
    Button2: TButton;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

    procedure FormDestroy(Sender: TObject);

    procedure Button5Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  bm: TBitmap;
  JP: TJpegImage;

  Map: array of array of Pixel;
  Iw, Ih: integer;

implementation

{$R *.dfm}
 procedure TForm1.FormCreate(Sender: TObject);
begin

    bm:=TBitmap.Create;
    jp:=TJpegImage.Create;

    img1.Picture.Bitmap.Width:=bm.Width;
    img1.Picture.Bitmap.Height:=bm.Height;
    img1.Picture.Bitmap.PixelFormat:=pf24bit;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   OD1.FileName:='*.bmp';
   if OD1.Execute=true then
   begin
      bm.LoadFromFile(OD1.FileName);
       Iw:=bm.Width;  Ih:=bm.Height;

      img1.Picture.Bitmap.Assign(bm);
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   bm.Free;
   jp.Free;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
   i:integer;
   pt: pbyte;
begin
     //**** Copy Map to Bitmap ****
    for i:=0 to Ih-1 do
    begin
        pt:=bm.ScanLine[i];
        move(Map[i,0],pt^,Iw*3);
    end;
    img1.Picture.Bitmap.Assign(bm);
end;

procedure TForm1.Button9Click(Sender: TObject);
var
    i, j, k, X, Y,X1, Y1, X2, Y2, X3, Y3, a, b, c, d, a1, b1, c1, d1, XX, YY, M, M1,
    XR, YR, XR1, YR1, XX1, YY1, X4, Y4, X5, Y5, XX2, YY2, XX3, YY3, i1, j1 , sti,
    Ih1, Iw1, count, ZR, ZG, ZB: integer;


    s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10: string;
    pt: pbyte;
    p: boolean;

    cv: TCanvas;

begin
    setlength( Map, Ih );
    for i:=0 to Ih-1 do
    begin
        setlength( Map[i], Iw );
    end;

    img1.picture.Bitmap.PixelFormat:=pf24bit;

    //**** Copy Bitmap Data to Map Array ****
    for i:=0 to Ih-1 do
    begin
        pt:=img1.Picture.Bitmap.ScanLine[i];
        move( pt^, Map[i,0], Iw*3 );
    end;
    //***** 把圖片做二值化處理 *****
    for i:=0 to Ih-1 do
    begin
       for j:=0 to Iw-1 do
       begin
          if(map[i,j].R <= 128) and (map[i,j].G <= 128) and (map[i,j].B <= 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 0;
             map[i,j].B := 0;
          end;

          if(map[i,j].R > 128) and (map[i,j].G <= 128) and (map[i,j].G <= 128) then
          begin
             map[i,j].R := 255;
             map[i,j].G := 0;
             map[i,j].B := 0;
          end;

          if(map[i,j].R <= 128) and (map[i,j].G >128) and (map[i,j].G <= 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 255;
             map[i,j].B := 0;
          end;

          if(map[i,j].R <= 128) and (map[i,j].G <= 128) and (map[i,j].G > 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 0;
             map[i,j].B := 255;
          end;

          if(map[i,j].R > 128) and (map[i,j].G > 128) and (map[i,j].G > 128) then
          begin
             map[i,j].R := 255;
             map[i,j].G := 255;
             map[i,j].B := 255;
          end;
       end;
    end;


    j:=(Iw div 2)-1; //二分之一直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
         begin
             X1:=j;
             Y1:= i+4;
             break;
         end;
    end;

    for i:=Y1 to Y1+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
         begin
             X1:=j;
             Y1:= i+4;
         end;
    end;

    j:=(Iw div 3)-1; //四分之一直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
        begin
            X:=j;
            Y:= i+4;
            break;
        end;
    end;

    for i:=Y to Y+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
        begin
            X:=j;
            Y:= i+4;

        end;
    end;

    i:=(Ih div 2)-1; //二分之一橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
        (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
        (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
        begin
            X3:=j+4;
            Y3:= i;
            break;
        end;
    end;

    for j:=X3 to X3+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X3:=j+4;
            Y3:= i;
        end;
    end;

    i:=(Ih div 3)-1; //四分之一橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
        (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
        (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
        begin
            X2:=j+4;
            Y2:= i;
            break;
        end;
    end;

    for j:=X2 to X2+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X2:=j+4;
            Y2:= i;
        end;
    end;

    i:=((Ih div 3)*2)-1; //四分之三橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
          (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
          (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
          (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
          begin
              X4:=j+4;
              Y4:= i;
              break;
          end;
    end;

    for j:=X4 to X4+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X4:=j+4;
            Y4:= i;
        end;
    end;

    j:=(Iw div 3)-1; //四分之一直線(下)
    for i:=Ih-1 downto (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            X5:=j;
            Y5:= i-4;
            break;
        end;
    end;

    for i:=Y5 downto Y5-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            X5:=j;
            Y5:= i-4;
        end;
    end;

    j:=((Iw div 3)*2)-1; //四分之三直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
        begin
            XR:=j;
            YR:= i+4;
            break;
        end;
    end;

    for i:=YR to YR+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
        begin
            XR:=j;
            YR:= i+4;
        end;
    end;

    i:=(Ih div 3)-1; //四分之一橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            XR1:=j-4;
            YR1:= i;
            break;
        end;
    end;

    for j:=XR1 downto XR1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            XR1:=j-4;
            YR1:= i;
        end;
    end;

    j:=(Iw div 2)-1;//二分之一直線 (下面)
    for i:=Ih-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            a:=j;
            b:= i-4;
            break;
        end;
    end;

    for i:=b downto b-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            a:=j;
            b:= i-4;
        end;
    end;

    j:=((Iw div 3)*2)-1;//四分之三直線 (下)
    for i:=Ih-1 downto (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            c:=j;
            d:= i-4;
            break;
        end;
    end;

    for i:=d downto d-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            c:=j;
            d:= i-4;
        end;
    end;

    i:=(Ih div 2)-1; //二分之一橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            a1:=j-4;
            b1:= i;
            break;
        end;
    end;

    for j:=a1 downto a1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            a1:=j-4;
            b1:= i;
        end;
    end;

    i:=((Ih div 3)*2)-1; //四分之三橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            c1:=j-4;
            d1:= i;
            break;
        end;
    end;

    for j:=c1 downto c1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            c1:=j-4;
            d1:= i;
        end;
    end;

    //交點座標(左上角)
    if (X3 = X2) and (Y<>Y1) then
    begin
        M1:=0;
        M:=(Y1-Y) div (X1-X);
        XX:=X2;
        YY:=(XX-X)*M+Y;
    end ;

    if (Y = Y1) and (X3<>X2) then
    begin
        M:=0;
        M1:=(Y3-Y2) div(X3-X2);
        XX:=(((M*X)-(M1*X2))-Y+Y2) div (M-M1);
        YY:=Y
    end;

    if (X3=X2) and (Y=Y1) then
    begin
        M1:=0;
        M:=0 ;
        XX:=X2;
        YY:=Y;
    end;

    if (X3<>X2) and (Y<>Y1) then
    begin
        M:=(Y1-Y) div (X1-X);
        M1:=(Y3-Y2) div(X3-X2);
        XX:=(((M*X)-(M1*X2))-Y+Y2) div (M-M1); //交點x座標
        YY:=(XX-X)*M+Y;
    end;

    //交點座標(右上角)
    if (a1 = XR1) and (YR<>Y1) then
    begin
        M1:=0;
        M:=(Y1-YR) div (X1-XR);
        XX1:=XR1;
        YY1:=(XX1-XR)*M+YR;
    end;

    if (YR = Y1) and (a1<>XR1) then
    begin
        M:=0;
        M1:=(b1-YR1) div(a1-XR1);
        XX1:=(((M*XR)-(M1*XR1))-YR+YR1) div (M-M1); //交點x座標
        YY1:=YR
    end;

    if (a1=XR1) and (YR=Y1) then
    begin
        M1:=0;
        M:=0 ;
        XX1:=XR1;
        YY1:=YR;
    end;

    if (a1<>XR1) and (YR<>Y1) then
    begin
        M:=(Y1-YR) div (X1-XR);
        M1:=(b1-YR1) div(a1-XR1);
        XX1:=(((M*XR)-(M1*XR1))-YR+YR1) div (M-M1); //交點x座標
        YY1:=(XX1-XR)*M+YR;
    end;

    //交點座標(左下角)
    if (X3=X4) and (b<>Y5) then
    begin
        M1:=0;
        M:=(b-Y5) div (a-X5);
        XX2:=X4;
        YY2:=(XX2-X5)*M+Y5;
    end;

    if (b = Y5) and (X3<>X4) then
    begin
        M:=0;
        M1:=(Y3-X4) div(X3-X4);
        XX2:=(((M*X5)-(M1*X4))-Y5+Y4) div (M-M1);
        YY2:=Y5;
    end;

    if (X3=X4) and (b = Y5) then
    begin
        M1:=0;
        M:=0;
        XX2:=X4;
        YY2:=Y5;
        end;

    if (X3<>X4) and (b<>Y5) then
    begin
        M:=(b-Y5) div (a-X5);
        M1:=(Y3-X4) div(X3-X4);
        XX2:=X4;
        YY2:=(XX2-X5)*M+Y5;
    end;

    //第一格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    Ih1:= XX1-XX;
    Iw1:=YY2-YY;
    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label2.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s1:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s1:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s1:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s1:='11';
    end;

    //第二格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:= Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label3.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s2:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s2:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s2:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s2:='11';
    end;

    //第三格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label4.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s3:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s3:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s3:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s3:='11';
    end;


    //第四格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label5.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s4:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s4:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s4:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s4:='11';
    end;

    //第五格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label6.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s5:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s5:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s5:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s5:='11';
    end;

    //第六格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label7.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s6:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s6:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s6:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s6:='11';
    end;

    //第七格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label8.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s7:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s7:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s7:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s7:='11';
    end;

    //第八格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label9.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s8:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s8:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s8:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s8:='11';
    end;

    //第九格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label10.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s9:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s9:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s9:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s9:='11';
    end;

    s10:=S1+S2+S3+S4+S5+S6+S7+s8+s9;
    Label1.Caption:=s10;

    if(s10 = '010001001000110011' ) then
    begin
        //showmessage('YES');
        Label11.Caption:='Yes';
    end
    else
    begin
        //showmessage('NO');
        Label11.Caption:='No';
    end;
    
    //**** Copy Map Array to Bitmap *****
    for i:=0 to Ih-1 do
    begin
        pt:=img1.Picture.Bitmap.ScanLine[i];
        move( Map[i,0], pt^, Iw*3 );
    end;

    //畫交點(左上角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 20;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX,YY);
    img1.Picture.Bitmap.Canvas.LineTo(XX,YY);

    //畫交點(右上角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 20;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX1,YY1);
    img1.Picture.Bitmap.Canvas.LineTo(XX1,YY1);

    //畫交點(左下角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 20;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX2,YY2);
    img1.Picture.Bitmap.Canvas.LineTo(XX2,YY2);

    //交點座標(右下角)
    if (a1=c1) and (b<>d)then
    begin
        M1:=0;
        M:=(b-d) div (a-c);
        XX3:=c1;
        YY3:=(XX3-c)*M+d;
    end;
    if (a1<>c1) and (b=d)then
    begin
        M:=0;
        M1:=(b1-c1) div (a1-c1);
        XX3:=(((M*c)-(M1*c1))-d+d1) div (M-M1);
        YY3:=d;
    end;

    if (a1=c1) and (b=d)then
    begin
        M:=0;
        M1:=0;
        XX3:=c1;
        YY3:=d;
    end;

    if (a1<>c1) and (b<>d)then
    begin
        M:=(b-d) div (a-c);
        M1:=(b1-c1) div (a1-c1);
        XX3:=c1;
        YY3:=(XX3-c)*M+d;
    end;

    //畫交點(右下角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 20;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX3,YY3);
    img1.Picture.Bitmap.Canvas.LineTo(XX3,YY3);

    //top線
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X,Y);
    img1.Picture.Bitmap.Canvas.LineTo(X1,Y1);


    //left線
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X2,Y2);
    img1.Picture.Bitmap.Canvas.LineTo(X3,Y3);

    //left線下
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X3,Y3);
    img1.Picture.Bitmap.Canvas.LineTo(X4,Y4);

    //top線右
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X1,Y1);
    img1.Picture.Bitmap.Canvas.LineTo(XR,YR);

    //right線上
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a1,b1);
    img1.Picture.Bitmap.Canvas.LineTo(XR1,YR1);

    //bottom線右
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a,b);
    img1.Picture.Bitmap.Canvas.LineTo(c,d);

    //bottom線左
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a,b);
    img1.Picture.Bitmap.Canvas.LineTo(X5,Y5);

    //right線下
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a1,b1);
    img1.Picture.Bitmap.Canvas.LineTo(c1,d1);

    img1.Refresh;
end;

procedure TForm1.IdTCPServer1Execute(AThread: TIdPeerThread);
var
    k: integer;
    p: array of byte;
    s: string;
    ms: TMemoryStream;


    i, j, X, Y, X1, Y1, X2, Y2, X3, Y3, a, b, c, d, a1, b1, c1, d1, XX, YY, M, M1,
    XR, YR, XR1, YR1, XX1, YY1, X4, Y4, X5, Y5, XX2, YY2, XX3, YY3, i1, j1 , sti,
    Ih1, Iw1, count, ZR, ZG, ZB: integer;


    s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10: string;
    pt: pbyte;

begin
    ms:=TMemoryStream.Create;

    while 1=1 do
    begin
        form1.Caption:=Athread.Connection.ReadLn();
        k:=strtoint(form1.Caption);

        setlength(p,k);
        Athread.Connection.ReadBuffer(p[0],k);

        ms.Size:=0;
        ms.Position:=0;
        ms.Write(p[0],k);
        ms.Position:=0;
        ms.SaveToFile('d:\ppppp.jpg');
        ms.Position:=0;

        //jp:=TJpegImage.Create;
        jp.LoadFromStream(ms);

        //bm:=TBitmap.Create;
        bm.Assign(jp);

        Iw:=bm.Width;  Ih:=bm.Height;
        img1.Picture.Bitmap.Assign(bm);

//*********************開始影像辨識***********

    setlength( Map, Ih );
    for i:=0 to Ih-1 do
    begin
        setlength( Map[i], Iw );
    end;

    img1.picture.Bitmap.PixelFormat:=pf24bit;

    //**** Copy Bitmap Data to Map Array ****
    for i:=0 to Ih-1 do
    begin
        pt:=img1.Picture.Bitmap.ScanLine[i];
        move( pt^, Map[i,0], Iw*3 );
    end;
    //***** 把圖片做二值化處理 *****
    for i:=0 to Ih-1 do
    begin
       for j:=0 to Iw-1 do
       begin
          if(map[i,j].R <= 128) and (map[i,j].G <= 128) and (map[i,j].B <= 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 0;
             map[i,j].B := 0;
          end;

          if(map[i,j].R > 128) and (map[i,j].G <= 128) and (map[i,j].G <= 128) then
          begin
             map[i,j].R := 255;
             map[i,j].G := 0;
             map[i,j].B := 0;
          end;

          if(map[i,j].R <= 128) and (map[i,j].G >128) and (map[i,j].G <= 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 255;
             map[i,j].B := 0;
          end;

          if(map[i,j].R <= 128) and (map[i,j].G <= 128) and (map[i,j].G > 128) then
          begin
             map[i,j].R := 0;
             map[i,j].G := 0;
             map[i,j].B := 255;
          end;

          if(map[i,j].R > 128) and (map[i,j].G > 128) and (map[i,j].G > 128) then
          begin
             map[i,j].R := 255;
             map[i,j].G := 255;
             map[i,j].B := 255;
          end;
       end;
    end;

  j:=(Iw div 2)-1; //二分之一直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
         begin
             X1:=j;
             Y1:= i+4;
             break;
         end;
    end;

    for i:=Y1 to Y1+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
         begin
             X1:=j;
             Y1:= i+4;
         end;
    end;

    j:=(Iw div 3)-1; //四分之一直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
        begin
            X:=j;
            Y:= i+4;
            break;
        end;
    end;

    for i:=Y to Y+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
        begin
            X:=j;
            Y:= i+4;

        end;
    end;

    i:=(Ih div 2)-1; //二分之一橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
        (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
        (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
        begin
            X3:=j+4;
            Y3:= i;
            break;
        end;
    end;

    for j:=X3 to X3+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X3:=j+4;
            Y3:= i;
        end;
    end;

    i:=(Ih div 3)-1; //四分之一橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
        (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
        (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
        begin
            X2:=j+4;
            Y2:= i;
            break;
        end;
    end;

    for j:=X2 to X2+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X2:=j+4;
            Y2:= i;
        end;
    end;

    i:=((Ih div 3)*2)-1; //四分之三橫線
    for j:=0 to (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
          (map[i,j+1].R = 255) and (map[i,j+1].G = 255) and (map[i,j+1].B = 255) and
          (map[i,j+2].R = 255) and (map[i,j+2].G = 255) and (map[i,j+2].B = 255) and
          (map[i,j+3].R = 255) and (map[i,j+3].G = 255) and (map[i,j+3].B = 255) then
          begin
              X4:=j+4;
              Y4:= i;
              break;
          end;
    end;

    for j:=X4 to X4+((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j+1].R = 0) and (map[i,j+1].G = 0) and (map[i,j+1].B = 0) and
        (map[i,j+2].R = 0) and (map[i,j+2].G = 0) and (map[i,j+2].B = 0) and
        (map[i,j+3].R = 0) and (map[i,j+3].G = 0) and (map[i,j+3].B = 0) then
        begin
            X4:=j+4;
            Y4:= i;
        end;
    end;

    j:=(Iw div 3)-1; //四分之一直線(下)
    for i:=Ih-1 downto (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            X5:=j;
            Y5:= i-4;
            break;
        end;
    end;

    for i:=Y5 downto Y5-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            X5:=j;
            Y5:= i-4;
        end;
    end;

    j:=((Iw div 3)*2)-1; //四分之三直線
    for i:=0 to (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i+1,j].R = 255) and (map[i+1,j].G = 255) and (map[i+1,j].B = 255) and
        (map[i+2,j].R = 255) and (map[i+2,j].G = 255) and (map[i+2,j].B = 255) and
        (map[i+3,j].R = 255) and (map[i+3,j].G = 255) and (map[i+3,j].B = 255) then
        begin
            XR:=j;
            YR:= i+4;
            break;
        end;
    end;

    for i:=YR to YR+((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i+1,j].R = 0) and (map[i+1,j].G = 0) and (map[i+1,j].B = 0) and
        (map[i+2,j].R = 0) and (map[i+2,j].G = 0) and (map[i+2,j].B = 0) and
        (map[i+3,j].R = 0) and (map[i+3,j].G = 0) and (map[i+3,j].B = 0) then
        begin
            XR:=j;
            YR:= i+4;
        end;
    end;

    i:=(Ih div 3)-1; //四分之一橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            XR1:=j-4;
            YR1:= i;
            break;
        end;
    end;

    for j:=XR1 downto XR1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            XR1:=j-4;
            YR1:= i;
        end;
    end;

    j:=(Iw div 2)-1;//二分之一直線 (下面)
    for i:=Ih-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            a:=j;
            b:= i-4;
            break;
        end;
    end;

    for i:=b downto b-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            a:=j;
            b:= i-4;
        end;
    end;

    j:=((Iw div 3)*2)-1;//四分之三直線 (下)
    for i:=Ih-1 downto (Ih div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i-1,j].R = 255) and (map[i-1,j].G = 255) and (map[i-1,j].B = 255) and
        (map[i-2,j].R = 255) and (map[i-2,j].G = 255) and (map[i-2,j].B = 255) and
        (map[i-3,j].R = 255) and (map[i-3,j].G = 255) and (map[i-3,j].B = 255) then
        begin
            c:=j;
            d:= i-4;
            break;
        end;
    end;

    for i:=d downto d-((Ih div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i-1,j].R = 0) and (map[i-1,j].G = 0) and (map[i-1,j].B = 0) and
        (map[i-2,j].R = 0) and (map[i-2,j].G = 0) and (map[i-2,j].B = 0) and
        (map[i-3,j].R = 0) and (map[i-3,j].G = 0) and (map[i-3,j].B = 0) then
        begin
            c:=j;
            d:= i-4;
        end;
    end;

    i:=(Ih div 2)-1; //二分之一橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            a1:=j-4;
            b1:= i;
            break;
        end;
    end;

    for j:=a1 downto a1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            a1:=j-4;
            b1:= i;
        end;
    end;

    i:=((Ih div 3)*2)-1; //四分之三橫線 (右)
    for j:=Iw-1 downto (Iw div 2)-1 do
    begin
        if(map[i,j].R = 255) and (map[i,j].G = 255) and (map[i,j].B = 255) and
        (map[i,j-1].R = 255) and (map[i,j-1].G = 255) and (map[i,j-3].B = 255) and
        (map[i,j-2].R = 255) and (map[i,j-2].G = 255) and (map[i,j-2].B = 255) and
        (map[i,j-3].R = 255) and (map[i,j-3].G = 255) and (map[i,j-1].B = 255) then
        begin
            c1:=j-4;
            d1:= i;
            break;
        end;
    end;

    for j:=c1 downto c1-((Iw div 8)-1) do
    begin
        if(map[i,j].R = 0) and (map[i,j].G = 0) and (map[i,j].B = 0) and
        (map[i,j-1].R = 0) and (map[i,j-1].G = 0) and (map[i,j-3].B = 0) and
        (map[i,j-2].R = 0) and (map[i,j-2].G = 0) and (map[i,j-2].B = 0) and
        (map[i,j-3].R = 0) and (map[i,j-3].G = 0) and (map[i,j-1].B = 0) then
        begin
            c1:=j-4;
            d1:= i;
        end;
    end;

    //交點座標(左上角)
    if (X3 = X2) and (Y<>Y1) then
    begin
        M1:=0;
        M:=(Y1-Y) div (X1-X);
        XX:=X2;
        YY:=(XX-X)*M+Y;
    end ;

    if (Y = Y1) and (X3<>X2) then
    begin
        M:=0;
        M1:=(Y3-Y2) div(X3-X2);
        XX:=(((M*X)-(M1*X2))-Y+Y2) div (M-M1);
        YY:=Y
    end;

    if (X3=X2) and (Y=Y1) then
    begin
        M1:=0;
        M:=0 ;
        XX:=X2;
        YY:=Y;
    end;

    if (X3<>X2) and (Y<>Y1) then
    begin
        M:=(Y1-Y) div (X1-X);
        M1:=(Y3-Y2) div(X3-X2);
        XX:=(((M*X)-(M1*X2))-Y+Y2) div (M-M1); //交點x座標
        YY:=(XX-X)*M+Y;
    end;

    //交點座標(右上角)
    if (a1 = XR1) and (YR<>Y1) then
    begin
        M1:=0;
        M:=(Y1-YR) div (X1-XR);
        XX1:=XR1;
        YY1:=(XX1-XR)*M+YR;
    end;

    if (YR = Y1) and (a1<>XR1) then
    begin
        M:=0;
        M1:=(b1-YR1) div(a1-XR1);
        XX1:=(((M*XR)-(M1*XR1))-YR+YR1) div (M-M1); //交點x座標
        YY1:=YR
    end;

    if (a1=XR1) and (YR=Y1) then
    begin
        M1:=0;
        M:=0 ;
        XX1:=XR1;
        YY1:=YR;
    end;

    if (a1<>XR1) and (YR<>Y1) then
    begin
        M:=(Y1-YR) div (X1-XR);
        M1:=(b1-YR1) div(a1-XR1);
        XX1:=(((M*XR)-(M1*XR1))-YR+YR1) div (M-M1); //交點x座標
        YY1:=(XX1-XR)*M+YR;
    end;

    //交點座標(左下角)
    if (X3=X4) and (b<>Y5) then
    begin
        M1:=0;
        M:=(b-Y5) div (a-X5);
        XX2:=X4;
        YY2:=(XX2-X5)*M+Y5;
    end;

    if (b = Y5) and (X3<>X4) then
    begin
        M:=0;
        M1:=(Y3-X4) div(X3-X4);
        XX2:=(((M*X5)-(M1*X4))-Y5+Y4) div (M-M1);
        YY2:=Y5;
    end;

    if (X3=X4) and (b = Y5) then
    begin
        M1:=0;
        M:=0;
        XX2:=X4;
        YY2:=Y5;
        end;

    if (X3<>X4) and (b<>Y5) then
    begin
        M:=(b-Y5) div (a-X5);
        M1:=(Y3-X4) div(X3-X4);
        XX2:=X4;
        YY2:=(XX2-X5)*M+Y5;
    end;

    //第一格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    Ih1:= XX1-XX;
    Iw1:=YY2-YY;
    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label2.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s1:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s1:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s1:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s1:='11';
    end;

    //第二格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:= Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label3.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s2:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s2:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s2:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s2:='11';
    end;

    //第三格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= YY to (YY+(Ih1 div 3)) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label4.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s3:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s3:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s3:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s3:='11';
    end;


    //第四格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label5.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s4:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s4:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s4:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s4:='11';
    end;

    //第五格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label6.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s5:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s5:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s5:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s5:='11';
    end;

    //第六格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)) to (YY+(Ih1 div 3)*2) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label7.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s6:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s6:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s6:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s6:='11';
    end;

    //第七格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= XX to (XX+(Iw1 div 3)) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label8.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s7:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s7:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s7:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s7:='11';
    end;

    //第八格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= (XX+(Iw1 div 3)) to (XX+(Iw1 div 3)*2) do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label9.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s8:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s8:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s8:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s8:='11';
    end;

    //第九格
    ZR:=0;
    ZG:=0;
    ZB:=0;
    count:=0;

    for i:= (YY+(Ih1 div 3)*2) to (YY+(YY2-YY)) do
    begin
        for j:= (XX+(Iw1 div 3)*2) to XX1 do
        begin
            ZR:= Map[i,j].R + ZR;
            ZG:= Map[i,j].G + ZG;
            ZB:=  Map[i,j].B + ZB;
            count:=count + 1;
        end;
    end;

    ZR:= ZR div count;
    ZG:= ZG div count;
    ZB:= ZB div count;

    Label10.Caption:=inttostr(ZR)+','+inttostr(ZG)+','+inttostr(ZB);

    if(ZR >= ZG) and (ZR >=  ZB) then
    begin
        s9:='00';
    end;

    if(ZG >= ZR) and (ZG >=  ZB) then
    begin
        s9:='01';
    end;

    if(ZB >= ZR) and (ZB >=  ZG) then
    begin
        s9:='10';
    end;

    if(ZR >= 180 ) and (ZG >= 180) and (ZB >= 180) then
    begin
        s9:='11';
    end;

    s10:=S1+S2+S3+S4+S5+S6+S7+s8+s9;
    Label1.Caption:=s10;

    if(s10 = '010001001000110011' ) then
    begin
        Athread.Connection.WriteLn('0');
        Label11.Caption:='Yes';
    end
    else
    begin
        Athread.Connection.WriteLn('1');
        Label11.Caption:='No';
    end;
    
    //**** Copy Map Array to Bitmap *****
    for i:=0 to Ih-1 do
    begin
        pt:=img1.Picture.Bitmap.ScanLine[i];
        move( Map[i,0], pt^, Iw*3 );
    end;

    //畫交點(左上角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 8;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX,YY);
    img1.Picture.Bitmap.Canvas.LineTo(XX,YY);

    //畫交點(右上角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 8;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX1,YY1);
    img1.Picture.Bitmap.Canvas.LineTo(XX1,YY1);

    //畫交點(左下角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 8;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX2,YY2);
    img1.Picture.Bitmap.Canvas.LineTo(XX2,YY2);

    //交點座標(右下角)
    if (a1=c1) and (b<>d)then
    begin
        M1:=0;
        M:=(b-d) div (a-c);
        XX3:=c1;
        YY3:=(XX3-c)*M+d;
    end;
    if (a1<>c1) and (b=d)then
    begin
        M:=0;
        M1:=(b1-c1) div (a1-c1);
        XX3:=(((M*c)-(M1*c1))-d+d1) div (M-M1);
        YY3:=d;
    end;

    if (a1=c1) and (b=d)then
    begin
        M:=0;
        M1:=0;
        XX3:=c1;
        YY3:=d;
    end;

    if (a1<>c1) and (b<>d)then
    begin
        M:=(b-d) div (a-c);
        M1:=(b1-c1) div (a1-c1);
        XX3:=c1;
        YY3:=(XX3-c)*M+d;
    end;

    //畫交點(右下角)
    img1.Picture.Bitmap.Canvas.Pen.Width := 8;
    img1.Picture.Bitmap.Canvas.Pen.Color := $00FFFF;
    img1.Picture.Bitmap.Canvas.MoveTo(XX3,YY3);
    img1.Picture.Bitmap.Canvas.LineTo(XX3,YY3);

    //top線
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X,Y);
    img1.Picture.Bitmap.Canvas.LineTo(X1,Y1);


    //left線
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X2,Y2);
    img1.Picture.Bitmap.Canvas.LineTo(X3,Y3);

    //left線下
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X3,Y3);
    img1.Picture.Bitmap.Canvas.LineTo(X4,Y4);

    //top線右
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(X1,Y1);
    img1.Picture.Bitmap.Canvas.LineTo(XR,YR);

    //right線上
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a1,b1);
    img1.Picture.Bitmap.Canvas.LineTo(XR1,YR1);

    //bottom線右
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a,b);
    img1.Picture.Bitmap.Canvas.LineTo(c,d);

    //bottom線左
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a,b);
    img1.Picture.Bitmap.Canvas.LineTo(X5,Y5);

    //right線下
    img1.Picture.Bitmap.Canvas.Pen.Width := 5;
    img1.Picture.Bitmap.Canvas.Pen.Color := $FFFF00;
    img1.Picture.Bitmap.Canvas.MoveTo(a1,b1);
    img1.Picture.Bitmap.Canvas.LineTo(c1,d1);

    img1.Refresh;
end;
    ms.Free;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 OD1.FileName:='*.jpg';
    if OD1.Execute=true then
    begin
        jp.LoadFromFile(OD1.FileName);
        bm.Assign(jp);
        Iw:=bm.Width; Ih:=bm.Height;
        img1.Picture.Bitmap.Assign(bm);
    end;
end;

end.

