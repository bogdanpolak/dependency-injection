unit InvoiceServiceC;

interface

uses
  System.SysUtils,
  Spring.Container.Common,
  {}
  InvoiceService,
  DataLayer,
  Utils.InterfacedTrackingObject;

type
  TInvoiceService = class(TInterfacedTrackingObject, IInvoiceService)
  private
    fDatabaseContext: IDatabaseContext;
  public
    [Inject]
    constructor Create(aDatabaseContext: IDatabaseContext);
    function GetDependencyTree(): string;
  end;

implementation

constructor TInvoiceService.Create(aDatabaseContext: IDatabaseContext);
begin
  inherited Create();
  self.fDatabaseContext := aDatabaseContext;
end;

function TInvoiceService.GetDependencyTree: string;
begin
  Result := self.ClassNameWithInstanceId() + '{' +
    fDatabaseContext.GetDependencyTree() + '}';
end;

end.
