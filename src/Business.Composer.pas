unit Business.Composer;

interface

uses
  Spring.Container,
  {}
  Business.Interfaces,
  Business.Classes;

procedure BuildContainer(Container: TContainer);

implementation

procedure BuildContainer(Container: TContainer);
begin
  Container.RegisterType<IConnectionFactory, TConnectionFactory>().AsSingleton;
  Container.RegisterType<IOrderRepository, TOrderRepository>();
  Container.RegisterType<ISubModule, TSubModule>();
  Container.RegisterType<IMainModule, TMainModule>();
  Container.RegisterType<IApplicationRoot, TApplicationRoot>();
  // TODO: GlobalContainer.RegisterDecorator()
  // TODO: GlobalContainer.RegisterFactory()
  Container.Build;
end;

end.
