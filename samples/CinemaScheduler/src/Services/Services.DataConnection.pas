unit Services.DataConnection;

interface

uses
  Spring.Collections,
  Model.Cinema;

type
  IDataConnection = interface(IInvokable)
    ['{BF9E366B-8853-4D34-861B-DA8DAA7E825A}']
    procedure Connect(const aConnectionStr: string);
    function GetMovies: IEnumerable<TMovie>;
    function GetShows: IEnumerable<TShow>;
    procedure AddTicket(const aShow: TShow; aSeat: TSeat); overload;
    procedure AddTicket(const aShow: TShow;
      const aSeats: TArray<TSeat>); overload;
  end;

{$M+}

  TDataConnectionFactory = reference to function(const name: string)
    : IDataConnection;
{$M-}

implementation

end.
