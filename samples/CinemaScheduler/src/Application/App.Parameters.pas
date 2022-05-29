unit App.Parameters;

interface

uses
  Spring.Collections;

type
  TAppCommand = (acDefault, acShows, acAddTickets, acHelp, acUnknown);

  IAppParameters = interface
    ['{973C33F7-8847-4846-83AF-3EEC478ED848}']
    procedure ValidateParameters;
    function AppCommand: TAppCommand;
    function ShowDate: TDateTime;
    function ShowID: integer;
    function TicketRow: integer;
    function TicketSeats: IList<integer>;
  end;

implementation

end.
