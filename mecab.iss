[Setup]
AppName=MeCab
AppVersion=0.996/ko-0.9.2
AppVerName=MeCab 0.996/ko-0.9.2
DefaultDirName={pf}\MeCab
AllowNoIcons=Yes
DefaultGroupName=MeCab
LicenseFile=BSD
Compression=bzip
OutputBaseFileName=mecab-0.996/ko-0.9.2
OutputDir=.
AppPublisher=Taku Kudo
AppPublisherURL=http://mecab.sourceforge.net/
ShowLanguageDialog=yes

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "jp"; MessagesFile: "compiler:Japanese.isl"

[Files]
Source: "AUTHORS";               DestDir: "{app}"
Source: "COPYING";               DestDir: "{app}"
Source: "GPL";                   DestDir: "{app}"
Source: "LGPL";                  DestDir: "{app}"
Source: "BSD";                   DestDir: "{app}"
Source: "src\mecab.exe";         DestDir: "{app}\bin"

Source: "src\mecab-*-*.exe";     DestDir: "{app}\bin"
Source: "src\libmecab.dll";      DestDir: "{app}\bin"
Source: "wintmp\mecabrc";    DestDir: "{app}\etc"
Source: "src\libmecab.lib";  DestDir: "{app}\sdk"
Source: "src\libmecab.dll";      DestDir: "{app}\bin"
Source: "wintmp\*.c";   DestDir: "{app}\sdk"
Source: "wintmp\*.cpp"; DestDir: "{app}\sdk"
Source: "src\mecab.h";  DestDir: "{app}\sdk"
Source: "doc\*.html";   DestDir: "{app}\doc"
Source: "doc\*.png";   DestDir: "{app}\doc"
Source: "doc\*.css";    DestDir: "{app}\doc"
Source: "wintmp\dic\*.csv";  DestDir: "{app}\dic\ipadic"
Source: "wintmp\dic\*.def";  DestDir: "{app}\dic\ipadic"
Source: "wintmp\dic\dicrc";  DestDir: "{app}\dic\ipadic"

[Icons]
Name: "{commonprograms}\MeCab\MeCab";           Filename: "{app}\bin\mecab.exe"
Name: "{commonprograms}\MeCab\Recompile SHIFT-JIS Dictionary"; WorkingDir: "{app}\dic\ipadic"; Filename: "{app}\bin\mecab-dict-index.exe"; Parameters: "-f SHIFT-JIS -t SHIFT-JIS"; Comment: "Recompile SHIFT-JIS dictionary"
Name: "{commonprograms}\MeCab\Recompile UTF-8 Dictionary"; WorkingDir: "{app}\dic\ipadic";  Filename: "{app}\bin\mecab-dict-index.exe"; Parameters: "-f SHIFT-JIS -t UTF-8"; Comment: "Recompile UTF-8 dictionary"
Name: "{commonprograms}\MeCab\Recompile UTF-16 Dictionary"; WorkingDir: "{app}\dic\ipadic";  Filename: "{app}\bin\mecab-dict-index.exe"; Parameters: "-f SHIFT-JIS -t UTF-16"; Comment: "Recompile UTF-16 dictionary"
Name: "{commonprograms}\MeCab\Recompile EUC-JP Dictionary"; WorkingDir: "{app}\dic\ipadic";  Filename: "{app}\bin\mecab-dict-index.exe"; Parameters: "-f SHIFT-JIS -t EUC-JP"; Comment: "Recompile EUC-JP dictionary"
Name: "{commonprograms}\MeCab\Uninstall MeCab"; Filename: "{app}\unins000.exe"
Name: "{commonprograms}\MeCab\MeCab Document";  Filename: "{app}\doc\index.html"
Name: "{userdesktop}\MeCab"; Filename:  "{app}\bin\mecab.exe"

[Run]
Filename: "{app}\bin\mecab-dict-index.exe"; Parameters: "-f SHIFT-JIS -t {code:GetCharCode}"; WorkingDir: "{app}\dic\ipadic"

[UninstallDelete]
Type: files; Name: "{app}\dic\ipadic\*.bin"
Type: files; Name: "{app}\dic\ipadic\*.dic"

[Registry]
Root: HKLM; Subkey: "software\MeCab"; Flags: uninsdeletekey; ValueType: string; ValueName: "mecabrc"; ValueData: "{app}\etc\mecabrc" ; Check: IsAdmin
Root: HKCU; Subkey: "software\MeCab"; Flags: uninsdeletekey; ValueType: string; ValueName: "mecabrc"; ValueData: "{app}\etc\mecabrc"

[Code]
Program Setup;
var
  IsAdminFlg:         boolean;
  IsAdminCheckedFlg:  boolean;
  UserPage: TInputOptionWizardPage;

Function IsAdmin (): Boolean;
var
  conf: String;
begin
  if not IsAdminLoggedOn () then
  begin
    Result := false;
  end
  else
  begin
    conf := 'You have administrator privileges. Do you permit all users to run MeCab';
    if ActiveLanguage = 'jp' then
    begin
      conf := '管理者権限をお持ちのようです。このコンピュータの全ユーザにMeCabの実行を許可しますか?';
    end
    if not IsAdminCheckedFlg then
       IsAdminFlg := MsgBox (conf, mbInformation, mb_YesNo) = idYes;
    IsAdminCheckedFlg := true;
    Result := IsAdminFlg;
  end;
end;

Function GetCharCode (Param: String): String;
var
  msg: String;
begin
  msg := 'Start compiling MeCab dictionary. It will take 30-60secs.';
  if ActiveLanguage = 'jp' then
  begin
    msg := 'MeCabの辞書を作成します。作業には1分ほどかかる場合がございます。';
  end;
  MsgBox(msg, mbInformation, mb_OK);
  Result := 'SHIFT-JIS';
  if UserPage.Values[0] = True then
  begin
     Result := 'SHIFT-JIS';
  end;
  if UserPage.Values[1] = True then
  begin
     Result := 'UTF-8';
  end;
  if UserPage.Values[2] = True then
  begin
     Result := 'UTF-16';
  end;
  if UserPage.Values[3] = True then
  begin
     Result := 'EUC-JP';
  end;
end;

procedure InitializeWizard;
var
  msg : array[0..3] of String;
begin
  msg[0] := 'Dictionary Charset'
  msg[1] := 'Please choose character set';
  msg[2] := 'Please specify charset set of dictionary, then click Next.';
  if ActiveLanguage = 'jp' then
  begin
    msg[0] := '辞書の文字コードの選択'
    msg[1] := '辞書の文字コードを選択してください。';
    msg[2] := 'インストールする辞書の文字コードを選択し(通常はSHIFT-JIS)、次へをクリックしてください。';
  end;
  UserPage := CreateInputOptionPage(wpWelcome, msg[0], msg[1], msg[2], True, True);
  UserPage.Add('SHIFT-JIS');
  UserPage.Add('UTF-8');
  UserPage.Add('UTF-16');
  UserPage.Add('EUC-JP');
  UserPage.Values[0] := True;
end;
