unit CadastroService;

interface
uses
  CadastroModel, SysUtils, vcl.Dialogs, CadastroRepository;

type
  TCadastroService = class
  private
    Repository: TCadastroRepository;
  public
    constructor Create;
    destructor Destroy; override;
    function Cadastrar(const Cadastro: TCadastroCfg): Boolean;
  end;

implementation

constructor TCadastroService.Create;
  begin
    inherited;
    Repository := TCadastroRepository.Create;
  end;

destructor TCadastroService.Destroy;
  begin
    Repository.Free;
    inherited;
  end;

function TCadastroService.Cadastrar(const Cadastro: TCadastroCfg): Boolean;
  begin
    Result := False;
    if (Cadastro.Nome = '') or (Cadastro.Email = '') or (Cadastro.Senha = '') or (Cadastro.CPF = '') or (Cadastro.NPhone = '') or (Cadastro.TipoUsuario = '') then
    begin
      raise Exception.Create('Preencha todos os campos e tente novamente.');
    end;
    if Repository.VerificarEmail(Cadastro.Email) then
    begin
      raise Exception.Create('Este e-mail j� est� cadastrado. Por favor, use outro.');
    end;
    if Cadastro.TipoUsuario = 'Cliente' then
      Result := Repository.AddUserCliente(Cadastro)
    else if Cadastro.TipoUsuario = 'Entregador' then
      Result := Repository.AddUserEntregador(Cadastro)
    else if Cadastro.TipoUsuario = 'Dono de Com�rcio' then
      Result := Repository.AddUserDonoComercio(Cadastro)
    else if Cadastro.TipoUsuario = 'Administrador' then
      Result := Repository.AddUserAdministrador(Cadastro)
    else
      raise Exception.Create('Tipo de usu�rio inv�lido. Escolha Cliente, Entregador ou Dono de com�rcio.');
    if Result then
      ShowMessage('Usu�rio ' + Cadastro.Nome + ' salvo com sucesso!');
  end;
end.
