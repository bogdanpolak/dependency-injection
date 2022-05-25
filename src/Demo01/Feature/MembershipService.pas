unit MembershipService;

interface

type
  IMembershipService = interface
    ['{488F4CAF-26D1-4DA8-919B-0F8FB45C54D7}']
    function IsCardActive(const aCardNumber: string): boolean;
    function GetDependencyTree(): string;
  end;

implementation

end.
