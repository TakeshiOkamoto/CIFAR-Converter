unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    Button4: TButton;
    Button7: TButton;
    Button6: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    SaveDialog1: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses
  unit2;

{$R *.lfm}

{ TForm1 }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure ImageResize(src:TBitmap;size :Dword);
var
   bmp : TBitmap;
begin
   bmp := TBitmap.create;
   try
     bmp.Width  := size;
     bmp.height := size;
     bmp.Canvas.Brush.Color:= clWhite;
     bmp.Canvas.FillRect(0,0,size,size);
     bmp.Canvas.StretchDraw(Rect(0,0,size,size),src);
     src.Assign(bmp);
   finally
     bmp.free;
   end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Button1Click(Sender: TObject);
begin
    if (Sender as TButton).Name = 'Button1' then
    begin
      if OpenDialog1.Execute then
      begin
         edit1.Text:= OpenDialog1.FileName;
      end;
    end
    else if  (Sender as TButton).Name = 'Button2' then
    begin
      if SelectDirectoryDialog1.Execute then
      begin
          Edit2.Text := SelectDirectoryDialog1.FileName + '\';
      end;
    end;

    if not (edit1.Text = '') and
       not (edit2.Text = '') then
      Button3.Enabled := true
    else
      Button3.Enabled := false
end;

// run "CIFAR to IMAGE"
procedure TForm1.Button3Click(Sender: TObject);
var
   i,x,y,Row,Col,size,index:integer;
   rows,columns : Dword;
   bmp : TBitmap;
   pic : TPicture;
   list: TStringList;
   ext : string;
   stream : TMemoryStream;
   class_number : byte;
   r : array[0..1024] of  Byte;
   g : array[0..1024] of  Byte;
   b : array[0..1024] of  Byte;
begin
    if edit1.Text = '' then exit;
    if edit2.Text = '' then exit;
    if Edit2.Text = '' then exit;

    ext := '.bmp';
    if(RadioButton1.Checked) then ext := '.jpg';
    if(RadioButton2.Checked) then ext := '.png';

    list := TStringList.create;
    pic  := TPicture.create;
    stream := TMemoryStream.create;
    PageControl1.Enabled:= false;
    try
      stream.LoadFromFile(edit1.text);

      // Calculation of number of images (画像数の算出)
      size:=  trunc(stream.size/3072) - trunc(stream.size/3072/3073);
      rows := 32; columns := 32;

      form2.Show;
      form2.ProgressBar1.Max:= size - 1;
      form2.ProgressBar1.Position := 0;
      form2.Caption:= 'processing ... ' +'0/' + inttostr(size) ;

      for i:= 0 to size-1 do
      begin
        Application.ProcessMessages;

        class_number := Stream.ReadByte;
        Stream.Read(r,1024);
        Stream.Read(g,1024);
        Stream.Read(b,1024);

        bmp := TBitmap.create;
        bmp.Width := columns;
        bmp.Height:= rows;
        bmp.PixelFormat := pf24bit;
        try
          // 24bit
          index := 0;
          for y := 0 to rows-1 do
          begin
            Row:= (y * columns * 3);
            for x := 0 to columns-1 do
            begin
              Col := Row + (x * 3);
              bmp.RawImage.Data[Col]   := r[index];
              bmp.RawImage.Data[Col+1] := g[index];
              bmp.RawImage.Data[Col+2] := b[index];
              inc(index);
            end;
          end;
          pic.Bitmap.Assign(bmp);
          pic.SaveToFile(Edit2.text + format('%.6d',[i+1])  +'-'+ format('%.3d',[class_number]) + ext);
        finally
          bmp.free;
        end;

        form2.Caption:= 'processing ... ' + inttostr(i) +'/' + inttostr(size) ;
        form2.ProgressBar1.Position:= i;
      end;

    finally
      list.free;
      pic.free;
      stream.free;
      form2.Close;
      PageControl1.Enabled:= true;
    end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  list : TStringList;
begin
    if (Sender as TButton).Name = 'Button4' then
    begin
      if SelectDirectoryDialog1.Execute then
      begin
          list := TStringList.create;
          try
            FindAllFiles(list,SelectDirectoryDialog1.FileName, '*.jpg;*.jpeg;*.png;*.gif;*.bmp', false);
            //list.Sort;
            Memo1.Lines.Assign(list);
          finally
            list.free;
          end;
      end;
    end
    else if (Sender as TButton).Name = 'Button5' then
    begin
      if OpenDialog1.Execute then
      begin
        memo2.Lines.LoadFromFile(OpenDialog1.FileName);
      end;
    end
    else if (Sender as TButton).Name = 'Button6' then
    begin
      if SaveDialog1.Execute then
      begin
         Edit3.Text:= SaveDialog1.FileName;
      end;
    end;

    if not (memo1.Text = '') and
       not (memo2.Text = '') and
       (memo1.lines.count = memo2.lines.count) and
       not (Edit3.Text = '') then
      Button7.Enabled := true
    else
      Button7.Enabled := false
end;

// run "IMAGE to CIFAR"
procedure TForm1.Button7Click(Sender: TObject);
var
  raw : PByte;
  lable : byte;
  i,x,y,Row,Col,index:integer;
  img_list,lbl_list : TStringList;
  Picture : TPicture;
  Stream : TMemoryStream;
  r : array[0..1024] of  Byte;
  g : array[0..1024] of  Byte;
  b : array[0..1024] of  Byte;
begin
  PageControl1.Enabled := false;

  img_list := TStringList.Create;
  lbl_list := TStringList.Create;
  Picture := TPicture.create;
  Stream := TMemoryStream.create;
  try
    img_list.Assign(Memo1.Lines);
    lbl_list.Assign(Memo2.Lines);

    form2.Show;
    form2.ProgressBar1.Max:= img_list.count-1;
    form2.ProgressBar1.Position := 0;
    form2.Caption:= 'processing ... ' +'0/' + inttostr(img_list.count) ;

    for i:=0 to img_list.count-1 do
    begin
       Application.ProcessMessages;

       // resize
       Picture.LoadFromFile(img_list[i]);
       ImageResize(Picture.Bitmap,32);
       raw := Picture.Bitmap.RawImage.Data;

       // label
       lable := strtoint(lbl_list[i]) and $FF;
       stream.Write(lable,1);

       // raw
       index :=0;
       raw := Picture.Bitmap.RawImage.Data;
       for y := 0 to Picture.Bitmap.Height-1 do
       begin
         Row:= (y * Picture.Bitmap.Width * 3);
         for x := 0 to Picture.Bitmap.Width-1 do
         begin
           Col := Row + (x * 3);
           r[index] := raw[Col];
           g[index] := raw[Col+1];
           b[index] := raw[Col+2];
           inc(index)
         end;
       end;

       stream.Write(r, 1024);
       stream.Write(g, 1024);
       stream.Write(b, 1024);
       form2.Caption:= 'processing ... ' + inttostr(i) +'/' + inttostr(img_list.count) ;
       form2.ProgressBar1.Position:= i;
    end;

    Stream.SaveToFile(Edit3.Text);
  finally
    img_list.free;
    lbl_list.free;
    Picture.free;
    Stream.free;
    form2.Close;
    PageControl1.Enabled := true;
  end;
end;

procedure TForm1.Label17Click(Sender: TObject);
begin
  SysUtils.ExecuteProcess(('explorer.exe'), PChar('https://github.com/TakeshiOkamoto'), []);
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  if (Sender as TMemo).Name = 'Memo1' then
  begin
    Label19.Caption:= inttostr(Memo1.Lines.count);
  end
  else if (Sender as TMemo).Name = 'Memo2' then
  begin
    Label21.Caption:= inttostr(Memo2.Lines.count);
  end;

  if not (memo1.Text = '') and
     not (memo2.Text = '') and
     (memo1.lines.count = memo2.lines.count) and
     not (Edit3.Text = '') then
    Button7.Enabled := true
  else
    Button7.Enabled := false
end;

end.

