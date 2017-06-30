object Form1: TForm1
  Left = 800
  Top = 200
  Width = 542
  Height = 462
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object img1: TImage
    Left = 136
    Top = 48
    Width = 300
    Height = 300
    Stretch = True
  end
  object Label1: TLabel
    Left = 0
    Top = 280
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 48
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 32
    Top = 72
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 32
    Top = 96
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 32
    Top = 120
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object Label6: TLabel
    Left = 32
    Top = 144
    Width = 32
    Height = 13
    Caption = 'Label6'
  end
  object Label7: TLabel
    Left = 32
    Top = 168
    Width = 32
    Height = 13
    Caption = 'Label7'
  end
  object Label8: TLabel
    Left = 32
    Top = 192
    Width = 32
    Height = 13
    Caption = 'Label8'
  end
  object Label9: TLabel
    Left = 32
    Top = 216
    Width = 32
    Height = 13
    Caption = 'Label9'
  end
  object Label10: TLabel
    Left = 32
    Top = 240
    Width = 38
    Height = 13
    Caption = 'Label10'
  end
  object Label11: TLabel
    Left = 336
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Label11'
  end
  object Button1: TButton
    Left = 16
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Load Bitmap'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button5: TButton
    Left = 24
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Copy To Bitmap'
    TabOrder = 1
    OnClick = Button5Click
  end
  object Button9: TButton
    Left = 120
    Top = 16
    Width = 75
    Height = 25
    Caption = #28204#35430
    TabOrder = 2
    OnClick = Button9Click
  end
  object Button2: TButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load Jepg'
    TabOrder = 3
    OnClick = Button2Click
  end
  object OD1: TOpenDialog
    Left = 216
    Top = 16
  end
  object IdTCPServer1: TIdTCPServer
    Active = True
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 3000
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnExecute = IdTCPServer1Execute
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 264
    Top = 16
  end
end
