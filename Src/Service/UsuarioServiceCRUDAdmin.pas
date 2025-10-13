unit UsuarioServiceCRUDAdmin;

interface

uses
  System.SysUtils, System.Generics.Collections, UsuarioModelCRUDAdmin, UsuarioRepositoryCRUDAdmin,
  CargosRepositoryCRUDAdmin;

type
  TUsuarioService = class
  private
    FUsuarioRepository: TUsuarioRepository;
    FCargoRepository: TCargoRepository;

    function ValidarEmail(Email: string): Boolean;
    function ValidarCPF(CPF: string): Boolean;
    function ValidarTelefone(Telefone: string): Boolean;
    function LimparCPF(CPF: string): string;
    function LimparTelefone(Telefone: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    // Opera��es CRUD
    function CadastrarUsuario(Nome, Email, CPF, Senha, Telefone: string; IdCargo: Integer): Boolean;
    function AtualizarUsuario(IdUsuario: Integer; Nome, Email, CPF, Telefone: string; IdCargo: Integer): Boolean;
    function DesativarUsuario(IdUsuario: Integer): Boolean;
    function ReativarUsuario(IdUsuario: Integer): Boolean;

    // Consultas
    function BuscarUsuarioPorId(IdUsuario: Integer): TUsuario;
    function ListarUsuariosAtivos: TObjectList<TUsuario>;
    function ListarUsuariosInativos: TObjectList<TUsuario>;
    function BuscarUsuarios(Filtro: string; ApenasAtivos: Boolean = True): TObjectList<TUsuario>;

    // Valida��es de neg�cio
    function ValidarDadosUsuario(Nome, Email, CPF, Telefone: string; IdCargo: Integer;
                                 var MensagemErro: string; IdUsuarioIgnorar: Integer = 0): Boolean;
  end;

implementation

{ TUsuarioService }

constructor TUsuarioService.Create;
begin
  inherited Create;
  FUsuarioRepository := TUsuarioRepository.Create;
  FCargoRepository := TCargoRepository.Create;
end;

destructor TUsuarioService.Destroy;
begin
  FUsuarioRepository.Free;
  FCargoRepository.Free;
  inherited;
end;

function TUsuarioService.LimparCPF(CPF: string): string;
begin
  Result := StringReplace(CPF, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := Trim(Result);
end;

function TUsuarioService.LimparTelefone(Telefone: string): string;
begin
  Result := StringReplace(Telefone, '(', '', [rfReplaceAll]);
  Result := StringReplace(Result, ')', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := Trim(Result);
end;

function TUsuarioService.ValidarEmail(Email: string): Boolean;
begin
  // Valida��o b�sica de email
  Result := (Pos('@', Email) > 0) and (Pos('.', Email) > 0) and (Length(Email) >= 5);
end;

function TUsuarioService.ValidarCPF(CPF: string): Boolean;
var
  CPFLimpo: string;
  i, Soma, Resto: Integer;
  Digito1, Digito2: Integer;
begin
  Result := False;
  CPFLimpo := LimparCPF(CPF);

  // Verifica se tem 11 d�gitos
  if Length(CPFLimpo) <> 11 then
    Exit;

  // Verifica se todos os d�gitos s�o iguais (CPF inv�lido)
  if (CPFLimpo = '00000000000') or (CPFLimpo = '11111111111') or
     (CPFLimpo = '22222222222') or (CPFLimpo = '33333333333') or
     (CPFLimpo = '44444444444') or (CPFLimpo = '55555555555') or
     (CPFLimpo = '66666666666') or (CPFLimpo = '77777777777') or
     (CPFLimpo = '88888888888') or (CPFLimpo = '99999999999') then
    Exit;

  // Calcula o primeiro d�gito verificador
  Soma := 0;
  for i := 1 to 9 do
    Soma := Soma + StrToInt(CPFLimpo[i]) * (11 - i);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then
    Resto := 0;
  Digito1 := Resto;

  // Calcula o segundo d�gito verificador
  Soma := 0;
  for i := 1 to 10 do
    Soma := Soma + StrToInt(CPFLimpo[i]) * (12 - i);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then
    Resto := 0;
  Digito2 := Resto;

  // Valida
  Result := (Digito1 = StrToInt(CPFLimpo[10])) and (Digito2 = StrToInt(CPFLimpo[11]));
end;

function TUsuarioService.ValidarTelefone(Telefone: string): Boolean;
var
  TelefoneLimpo: string;
begin
  TelefoneLimpo := LimparTelefone(Telefone);
  // Telefone brasileiro: 10 d�gitos (fixo) ou 11 d�gitos (celular)
  Result := (Length(TelefoneLimpo) = 10) or (Length(TelefoneLimpo) = 11);
end;

function TUsuarioService.ValidarDadosUsuario(Nome, Email, CPF, Telefone: string;
  IdCargo: Integer; var MensagemErro: string; IdUsuarioIgnorar: Integer): Boolean;
begin
  Result := False;
  MensagemErro := '';

  // Validar Nome
  if Trim(Nome) = '' then
  begin
    MensagemErro := 'Nome � obrigat�rio.';
    Exit;
  end;

  if Length(Trim(Nome)) < 3 then
  begin
    MensagemErro := 'Nome deve ter no m�nimo 3 caracteres.';
    Exit;
  end;

  // Validar Email
  if Trim(Email) = '' then
  begin
    MensagemErro := 'Email � obrigat�rio.';
    Exit;
  end;

  if not ValidarEmail(Email) then
  begin
    MensagemErro := 'Email inv�lido.';
    Exit;
  end;

  // Verificar se email j� existe
  if FUsuarioRepository.EmailJaExiste(Email, IdUsuarioIgnorar) then
  begin
    MensagemErro := 'Este email j� est� cadastrado.';
    Exit;
  end;

  // Validar CPF
  if Trim(CPF) = '' then
  begin
    MensagemErro := 'CPF � obrigat�rio.';
    Exit;
  end;

  if not ValidarCPF(CPF) then
  begin
    MensagemErro := 'CPF inv�lido.';
    Exit;
  end;

  // Verificar se CPF j� existe
  if FUsuarioRepository.CpfJaExiste(LimparCPF(CPF), IdUsuarioIgnorar) then
  begin
    MensagemErro := 'Este CPF j� est� cadastrado.';
    Exit;
  end;

  // Validar Telefone
  if Trim(Telefone) = '' then
  begin
    MensagemErro := 'Telefone � obrigat�rio.';
    Exit;
  end;

  if not ValidarTelefone(Telefone) then
  begin
    MensagemErro := 'Telefone inv�lido.';
    Exit;
  end;

  // Validar Cargo
  if IdCargo <= 0 then
  begin
    MensagemErro := 'Selecione um cargo v�lido.';
    Exit;
  end;

  if not FCargoRepository.CargoExiste(IdCargo) then
  begin
    MensagemErro := 'Cargo n�o encontrado no sistema.';
    Exit;
  end;

  Result := True;
end;

function TUsuarioService.CadastrarUsuario(Nome, Email, CPF, Senha, Telefone: string;
  IdCargo: Integer): Boolean;
var
  Usuario: TUsuario;
  MensagemErro: string;
begin
  Result := False;

  // Validar senha
  if Trim(Senha) = '' then
    raise Exception.Create('Senha � obrigat�ria.');

  if Length(Trim(Senha)) < 6 then
    raise Exception.Create('Senha deve ter no m�nimo 6 caracteres.');

  // Validar dados
  if not ValidarDadosUsuario(Nome, Email, CPF, Telefone, IdCargo, MensagemErro) then
    raise Exception.Create(MensagemErro);

  // Criar objeto Usuario
  Usuario := TUsuario.Create;
  try
    Usuario.NomeUser := Trim(Nome);
    Usuario.EmailUser := Trim(Email);
    Usuario.CpfUser := LimparCPF(CPF);
    Usuario.NPhoneUser := LimparTelefone(Telefone);
    Usuario.IdCargo := IdCargo;
    Usuario.Ativo := True;

    // Inserir no banco
    Result := FUsuarioRepository.Inserir(Usuario, Senha);
  finally
    Usuario.Free;
  end;
end;

function TUsuarioService.AtualizarUsuario(IdUsuario: Integer; Nome, Email, CPF,
  Telefone: string; IdCargo: Integer): Boolean;
var
  Usuario: TUsuario;
  MensagemErro: string;
begin
  Result := False;

  // Validar ID
  if IdUsuario <= 0 then
    raise Exception.Create('ID do usu�rio inv�lido.');

  // Verificar se usu�rio existe
  Usuario := FUsuarioRepository.BuscarPorId(IdUsuario);
  if not Assigned(Usuario) then
    raise Exception.Create('Usu�rio n�o encontrado.');

  try
    // Validar dados (ignorando o pr�prio usu�rio nas verifica��es de duplicidade)
    if not ValidarDadosUsuario(Nome, Email, CPF, Telefone, IdCargo, MensagemErro, IdUsuario) then
      raise Exception.Create(MensagemErro);

    // Atualizar dados
    Usuario.NomeUser := Trim(Nome);
    Usuario.EmailUser := Trim(Email);
    Usuario.CpfUser := LimparCPF(CPF);
    Usuario.NPhoneUser := LimparTelefone(Telefone);
    Usuario.IdCargo := IdCargo;

    // Salvar no banco
    Result := FUsuarioRepository.Atualizar(Usuario);
  finally
    Usuario.Free;
  end;
end;

function TUsuarioService.DesativarUsuario(IdUsuario: Integer): Boolean;
var
  Usuario: TUsuario;
begin
  Result := False;

  // Verificar se usu�rio existe
  Usuario := FUsuarioRepository.BuscarPorId(IdUsuario);
  if not Assigned(Usuario) then
    raise Exception.Create('Usu�rio n�o encontrado.');

  try
    // Verificar se j� est� inativo
    if not Usuario.Ativo then
      raise Exception.Create('Este usu�rio j� est� inativo.');

    // Desativar
    Result := FUsuarioRepository.AlterarStatus(IdUsuario, False);
  finally
    Usuario.Free;
  end;
end;

function TUsuarioService.ReativarUsuario(IdUsuario: Integer): Boolean;
var
  Usuario: TUsuario;
begin
  Result := False;

  // Verificar se usu�rio existe
  Usuario := FUsuarioRepository.BuscarPorId(IdUsuario);
  if not Assigned(Usuario) then
    raise Exception.Create('Usu�rio n�o encontrado.');

  try
    // Verificar se j� est� ativo
    if Usuario.Ativo then
      raise Exception.Create('Este usu�rio j� est� ativo.');

    // Reativar
    Result := FUsuarioRepository.AlterarStatus(IdUsuario, True);
  finally
    Usuario.Free;
  end;
end;

function TUsuarioService.BuscarUsuarioPorId(IdUsuario: Integer): TUsuario;
begin
  Result := FUsuarioRepository.BuscarPorId(IdUsuario);

  if not Assigned(Result) then
    raise Exception.Create('Usu�rio n�o encontrado.');
end;

function TUsuarioService.ListarUsuariosAtivos: TObjectList<TUsuario>;
begin
  Result := FUsuarioRepository.ListarTodos(True);
end;

function TUsuarioService.ListarUsuariosInativos: TObjectList<TUsuario>;
begin
  Result := FUsuarioRepository.ListarTodos(False);
end;

function TUsuarioService.BuscarUsuarios(Filtro: string; ApenasAtivos: Boolean): TObjectList<TUsuario>;
begin
  if Trim(Filtro) = '' then
    Result := FUsuarioRepository.ListarTodos(ApenasAtivos)
  else
    Result := FUsuarioRepository.BuscarPorFiltro(Filtro, ApenasAtivos);
end;

end.
