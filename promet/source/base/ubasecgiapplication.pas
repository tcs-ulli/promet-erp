{*******************************************************************************
Dieser Sourcecode darf nicht ohne gültige Geheimhaltungsvereinbarung benutzt werden
und ohne gültigen Vertriebspartnervertrag weitergegeben oder kommerziell verwertet werden.
You have no permission to use this Source without valid NDA
and copy it without valid distribution partner agreement
Christian Ulrich
info@cu-tec.de
Created 01.06.2006
*******************************************************************************}
unit ubasecgiapplication;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, CustCGI, uBaseApplication, uBaseDBInterface,
  PropertyStorage, uData, uSystemMessage, XMLPropStorage;
type
  TBaseCGIApplication = class(TCustomCGIApplication, IBaseApplication, IBaseDbInterface)
  private
    FDBInterface: IBaseDbInterface;
    FMessageHandler: TMessageHandler;
    Properties: TXMLPropStorage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetConfigName(aName : string);
    procedure RestoreConfig;
    procedure SaveConfig;
    function GetConfig: TCustomPropertyStorage;
    function GetLanguage: string;
    procedure SetLanguage(const AValue: string);

    procedure DoLog(aMsg : string);
    function Login : Boolean;
    procedure Logout;
    procedure DoExit;
    property IData : IBaseDbInterface read FDBInterface implements IBaseDBInterface;
    property MessageHandler : TMessageHandler read FMessageHandler;
  end;
Var
  Application : TBaseCGIApplication;
implementation
uses FileUtil,Utils,uAppConsts;
resourcestring
  strFailedtoLoadMandants    = 'Mandanten konnten nicht gelanden werden !';
  strLoginFailed             = 'Anmeldung fehlgeschlagen !';
constructor TBaseCGIApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BaseApplication := Self;
  {.$Warnings Off}
  FDBInterface := TBaseDBInterface.Create;
  FDBInterface.SetOwner(Self);
  {.$Warnings On}
  Properties := TXMLPropStorage.Create(AOwner);
  Properties.FileName := GetOurConfigDir+'config.xml';
  Properties.RootNodePath := 'Config';
end;
destructor TBaseCGIApplication.Destroy;
begin
  Properties.Free;
  DoExit;
  if Assigned(FmessageHandler) then
    begin
      FMessagehandler.Terminate;
      sleep(20);
    end;
  FDBInterface.Data.Free;
  inherited Destroy;
end;
procedure TBaseCGIApplication.SetConfigName(aName: string);
begin
  if GetOurConfigDir <> '' then
    begin
      if not DirectoryExistsUTF8(GetOurConfigDir) then
        ForceDirectoriesUTF8(GetOurConfigDir);
      if not DirectoryExistsUTF8(GetGlobalConfigDir(vAppname)) then
        ForceDirectoriesUTF8(GetGlobalConfigDir(vAppname));
    end;
  Properties.FileName := GetConfigDir(vAppname)+aName+'.xml';
end;
procedure TBaseCGIApplication.RestoreConfig;
begin
  Properties.Restore;
end;
procedure TBaseCGIApplication.SaveConfig;
begin
  Properties.Save;
end;
function TBaseCGIApplication.GetConfig: TCustomPropertyStorage;
begin
  Result := Properties;
end;
function TBaseCGIApplication.GetLanguage: string;
begin

end;
procedure TBaseCGIApplication.SetLanguage(const AValue: string);
begin

end;
procedure TBaseCGIApplication.DoLog(aMsg: string);
begin

end;
function TBaseCGIApplication.Login: Boolean;
begin
  Result := False;
  with Self as IBaseDbInterface do
    begin
      if not LoadMandants then
        raise Exception.Create(strFailedtoLoadMandants);
      if not DBLogin(Properties.StoredValue['MANDANT'],'') then
        raise Exception.Create(strLoginFailed);
      uData.Data := Data;
    end;
  Result := True;
end;
procedure TBaseCGIApplication.Logout;
begin
end;
procedure TBaseCGIApplication.DoExit;
begin
  with Self as IBaseDbInterface do
    DBLogout;
end;
initialization
  Application := TBaseCGIApplication.Create(nil);
finalization
  Application.Destroy;
end.

