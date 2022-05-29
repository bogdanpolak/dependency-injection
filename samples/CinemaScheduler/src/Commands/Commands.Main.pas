unit Commands.Main;

interface

type
  IMainCommand = interface(IInvokable)
    ['{D45AB54B-A6CD-4557-81D2-954CFF4A752B}']
    procedure Run(const date: TDateTime);
  end;

implementation

end.
