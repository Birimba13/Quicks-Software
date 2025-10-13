unit UsuarioControllerCRUDAdmin;

interface

uses
  System.SysUtils, System.Generics.Collections, Vcl.Dialogs,
  UsuarioModelCRUDAdmin, UsuarioServiceCRUDAdmin, CargosServiceCRUDAdmin, CargosModelCRUDAdmin;

type
  TUsuarioController = class
  private
    FUsuarioService: TUsuarioService;
    FCargoService: TCargoService;
  public
    constructor Create;
    destructor Destroy; override;

    // Opera��es de Usu�rio
    function CadastrarNovoUsuario(Nome, Email, CPF, Senha, Telefone: string;
                                  IdCargo: Integer): Boolean;
    function AtualizarDadosUsuario(IdUsuario: Integer; Nome, Email, CPF,
                                   Telefone: string; IdCargo: Integer): Boolean;
    function DesativarUsuario(IdUsuario: Integer; NomeUsuario: string): Boolean;
    function ReativarUsuario(IdUsuario: Integer; NomeUsuario: string): Boolean;

    // Consultas
    function ObterUsuarioPorId(IdUsuario: Integer): TUsuario;
    function ObterUsuariosAtivos: TObjectList<TUsuario>;
    function ObterUsuariosInativos: TObjectList<TUsuario>;
    function PesquisarUsuarios(TextoBusca: string; ApenasAtivos: Boolean = True): TObjectList<TUsuario>;

    // Cargos
    function ObterTodosCargos: TObjectList<TCargo>;
  end;

implementation

{ TUsuarioController }

constructor TUsuarioController.Create;
begin
  inherited Create;
  FUsuarioService := TUsuarioService.Create;
  FCargoService := TCargoService.Create;
end;

destructor TUsuarioController.Destroy;
begin
  FUsuarioService.Free;
  FCargoService.Free;
  inherited;
end;

function TUsuarioController.CadastrarNovoUsuario(Nome, Email, CPF, Senha,
  Telefone: string; IdCargo: Integer): Boolean;
begin
  Result := False;

  try
    Result := FUsuarioService.CadastrarUsuario(Nome, Email, CPF, Senha, Telefone, IdCargo);

    if Result then
      ShowMessage('Usu�rio cadastrado com sucesso!');

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao cadastrar usu�rio: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TUsuarioController.AtualizarDadosUsuario(IdUsuario: Integer; Nome, Email,
  CPF, Telefone: string; IdCargo: Integer): Boolean;
begin
  Result := False;

  try
    Result := FUsuarioService.AtualizarUsuario(IdUsuario, Nome, Email, CPF, Telefone, IdCargo);

    if Result then
      ShowMessage('Usu�rio atualizado com sucesso!');

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao atualizar usu�rio: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TUsuarioController.DesativarUsuario(IdUsuario: Integer; NomeUsuario: string): Boolean;
begin
  Result := False;
  // Confirmar com o usu�rio
  if MessageDlg(Format('Deseja desativar o usu�rio "%s"?', [NomeUsuario]),
                mtConfirmation, [mbYes, mbNo], 0) <> 1 then // usando o valor 1 para mrYes
    Exit;
  try
    Result := FUsuarioService.DesativarUsuario(IdUsuario);
    if Result then
      ShowMessage('Usu�rio desativado com sucesso!');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao desativar usu�rio: ' + E.Message);
      Result := False;
    end;
  end;
end;


function TUsuarioController.ReativarUsuario(IdUsuario: Integer; NomeUsuario: string): Boolean;
begin
  Result := False;
  // Confirmar com o usu�rio
  if MessageDlg(Format('Deseja restaurar o usu�rio "%s"?', [NomeUsuario]),
                mtConfirmation, [mbYes, mbNo], 0) <> 1 then // usando o valor 1 para mrYes
    Exit;
  try
    Result := FUsuarioService.ReativarUsuario(IdUsuario);
    if Result then
      ShowMessage('Usu�rio restaurado com sucesso!');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao restaurar usu�rio: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TUsuarioController.ObterUsuarioPorId(IdUsuario: Integer): TUsuario;
begin
  try
    Result := FUsuarioService.BuscarUsuarioPorId(IdUsuario);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar usu�rio: ' + E.Message);
      Result := nil;
    end;
  end;
end;

function TUsuarioController.ObterUsuariosAtivos: TObjectList<TUsuario>;
begin
  try
    Result := FUsuarioService.ListarUsuariosAtivos;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao listar usu�rios: ' + E.Message);
      Result := TObjectList<TUsuario>.Create(True);
    end;
  end;
end;

function TUsuarioController.ObterUsuariosInativos: TObjectList<TUsuario>;
begin
  try
    Result := FUsuarioService.ListarUsuariosInativos;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao listar usu�rios inativos: ' + E.Message);
      Result := TObjectList<TUsuario>.Create(True);
    end;
  end;
end;

function TUsuarioController.PesquisarUsuarios(TextoBusca: string;
  ApenasAtivos: Boolean): TObjectList<TUsuario>;
begin
  try
    Result := FUsuarioService.BuscarUsuarios(TextoBusca, ApenasAtivos);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao pesquisar usu�rios: ' + E.Message);
      Result := TObjectList<TUsuario>.Create(True);
    end;
  end;
end;

function TUsuarioController.ObterTodosCargos: TObjectList<TCargo>;
begin
  try
    Result := FCargoService.ListarTodosCargos;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar cargos: ' + E.Message);
      Result := TObjectList<TCargo>.Create(True);
    end;
  end;
end;

end.
