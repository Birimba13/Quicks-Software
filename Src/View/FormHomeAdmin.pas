unit FormHomeAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, uConn, ACRUDModel, CadastroModel, CadastroController,
  Vcl.Mask;

type
  TFormHomeA = class(TForm)
    pHomeBackground: TPanel;
    pListViewMain: TPanel;
    pcMain: TPageControl;
    pctab1Selecione: TTabSheet;
    pText: TPanel;
    lblText: TLabel;
    pctab2Relatorios: TTabSheet;
    pBarraMenuLeft: TPanel;
    iButton1: TImage;
    iButton3: TImage;
    iButton2: TImage;
    iButton6: TImage;
    lblButton1: TLabel;
    lblButton2: TLabel;
    lblButton3: TLabel;
    lblButton4: TLabel;
    iButton5: TImage;
    lblButton5: TLabel;
    iButton4: TImage;
    pctab3Pedidos: TTabSheet;
    pctab4Usuarios: TTabSheet;
    pctab5Perfil: TTabSheet;
    pHeader: TPanel;
    pMainUsuarios: TPanel;
    pMainGrid: TPanel;
    pBusca: TPanel;
    DBGridUsuarios: TDBGrid;
    pButton2Excluir: TPanel;
    pButton3Atualizar: TPanel;
    pButton4Restaurar: TPanel;
    pButton5Pesquisar: TPanel;
    pButton1Adicionar: TPanel;
    pButton6Cancelar: TPanel;
    pcButtons: TPageControl;
    pctab0Clique: TTabSheet;
    pMainPTab0: TPanel;
    lblClique: TLabel;
    pctab1Add: TTabSheet;
    pctab2Ex: TTabSheet;
    pctab3Up: TTabSheet;
    pctab4Res: TTabSheet;
    pctab5Pesq: TTabSheet;
    eBuscaMain: TEdit;
    pHideTSbar: TPanel;
    pLR: TPanel;
    lblSenha: TLabel;
    lblEmail: TLabel;
    lblCPF: TLabel;
    lblNome: TLabel;
    lblNPhone: TLabel;
    meCPF: TMaskEdit;
    bCadastro: TPanel;
    eEmail: TEdit;
    eNome: TEdit;
    meSenha: TMaskEdit;
    cbOpcoes: TComboBox;
    meNPhone: TMaskEdit;
    eNPhone: TEdit;
    eCPF: TEdit;
    lblTituloMain: TLabel;
    pConfirmarRestore: TPanel;
    pButtonConfirmarRestore: TPanel;
    pUserSelectionRestore: TPanel;
    lblDescUserSelectRes: TLabel;
    lblUserSelectRes: TLabel;
    pBackgroundExcluir: TPanel;
    pButtonConfirmarExcluir: TPanel;
    pUserSelectionEx: TPanel;
    lblDescUserSelectEx: TLabel;
    lblUserSelectEx: TLabel;
    pBackgroundUpdate: TPanel;
    lblEmailUpdate: TLabel;
    lblCPFUpdate: TLabel;
    lblNomeUpdate: TLabel;
    lblNPhoneUpdate: TLabel;
    lblPreenchaUpdate: TLabel;
    meCPFUpdate: TMaskEdit;
    pButtonConfirmarUpdate: TPanel;
    e2EmailUpdate: TEdit;
    e1NomeUpdate: TEdit;
    cbUpdate: TComboBox;
    meNPhoneUpdate: TMaskEdit;
    Panel3: TPanel;
    Label7: TLabel;
    procedure iButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pButton1AdicionarClick(Sender: TObject);
    procedure pButton2ExcluirClick(Sender: TObject);
    procedure pButton3AtualizarClick(Sender: TObject);
    procedure pButton5PesquisarClick(Sender: TObject);
    procedure pButton6CancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCadastroClick(Sender: TObject);
    procedure eCPFChange(Sender: TObject);
    procedure eCPFClick(Sender: TObject);
    procedure eNPhoneChange(Sender: TObject);
    procedure pButtonConfirmarExcluirClick(Sender: TObject);
    procedure pButtonConfirmarRestoreClick(Sender: TObject);
    procedure pButton4RestaurarClick(Sender: TObject);
    procedure DBGridUsuariosCellClick(Column: TColumn);
    procedure pButtonConfirmarUpdateClick(Sender: TObject);
  private
    procedure LimparCamposUpdate;
    procedure CarregarDadosUpdate;
    procedure AtualizarGrid;
    procedure AtualizarGridFalse;
    procedure AtualizarGridTrue;
    procedure FiltrarGrid(const TextoBusca: string);
  public

  end;
var
  FormHomeA: TFormHomeA;
  SqlQr: TACRUDCfg;

implementation
{$R *.dfm}
procedure TFormHomeA.AtualizarGrid;
  begin
    if not Assigned(DM) then
      begin
        ShowMessage('DataModule n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDQr) then
      begin
        ShowMessage('FDQuery n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDConn) or not DM.FDConn.Connected then
      begin
        ShowMessage('Banco de dados n�o conectado.');
        Exit;
      end;
    if not Assigned(DBGridUsuarios.DataSource) then
      begin
        ShowMessage('DataSource n�o est� conectado ao Grid.');
        Exit;
      end;
    try
      with DM.FDQr do
      begin
        try
          DisableControls;
          if Active then
            Close;
          SQL.Clear;
          SQL.Add('SELECT id_user, nome_user, email_user, senha_user, cpf_user, nphone_user, ativo');
          SQL.Add('FROM usuarios');
          SQL.Add('ORDER BY id_user');
          Open;
          if IsEmpty then
          begin
            ShowMessage('Nenhum usu�rio encontrado no banco de dados.');
          end
          else
          begin
            First;
          end;
          Filtered := False;
          Filter := '';
          Refresh;
        finally
          EnableControls;
        end;
      end;
      eBuscaMain.Clear;
    except
      on E: Exception do
        ShowMessage('Erro ao atualizar grid: ' + E.Message);
    end;
  end;

procedure TFormHomeA.AtualizarGridFalse;
begin
    SqlQr:=TACRUDCfg.Create;
    if not Assigned(DM) then
      begin
        ShowMessage('DataModule n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDQr) then
      begin
        ShowMessage('FDQuery n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDConn) or not DM.FDConn.Connected then
      begin
        ShowMessage('Banco de dados n�o conectado.');
        Exit;
      end;
    if not Assigned(DBGridUsuarios.DataSource) then
      begin
        ShowMessage('DataSource n�o est� conectado ao Grid.');
        Exit;
      end;
    try
      with DM.FDQr do
      begin
        try
          DisableControls;
          if Active then
            Close;
          SqlQr.sqladd:=('WHERE ativo = False');
          SQL.Clear;
          SQL.Add('SELECT id_user, nome_user, email_user, senha_user, cpf_user, nphone_user, ativo');
          SQL.Add('FROM usuarios');
          SQL.Add(SqlQr.sqladd);
          SQL.Add('ORDER BY id_user');
          Open;
          if IsEmpty then
          begin
            ShowMessage('Nenhum usu�rio encontrado no banco de dados.');
          end
          else
          begin
            First;
          end;
          Filtered := False;
          Filter := '';
          Refresh;
        finally
          EnableControls;
        end;
      end;
      eBuscaMain.Clear;
    except
      on E: Exception do
        ShowMessage('Erro ao atualizar grid: ' + E.Message);
    end;
  end;

procedure TFormHomeA.AtualizarGridTrue;
begin
    SqlQr:=TACRUDCfg.Create;
    if not Assigned(DM) then
      begin
        ShowMessage('DataModule n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDQr) then
      begin
        ShowMessage('FDQuery n�o est� dispon�vel.');
        Exit;
      end;
    if not Assigned(DM.FDConn) or not DM.FDConn.Connected then
      begin
        ShowMessage('Banco de dados n�o conectado.');
        Exit;
      end;
    if not Assigned(DBGridUsuarios.DataSource) then
      begin
        ShowMessage('DataSource n�o est� conectado ao Grid.');
        Exit;
      end;
    try
      with DM.FDQr do
      begin
        try
          DisableControls;
          if Active then
            Close;
          SqlQr.sqladd:=('WHERE ativo = True');
          SQL.Clear;
          SQL.Add('SELECT id_user, nome_user, email_user, senha_user, cpf_user, nphone_user, ativo');
          SQL.Add('FROM usuarios');
          SQL.Add(SqlQr.sqladd);
          SQL.Add('ORDER BY id_user');
          Open;
          if IsEmpty then
          begin
            ShowMessage('Nenhum usu�rio encontrado no banco de dados.');
          end
          else
          begin
            First;
          end;
          Filtered := False;
          Filter := '';
          Refresh;
        finally
          EnableControls;
        end;
      end;
      eBuscaMain.Clear;
    except
      on E: Exception do
        ShowMessage('Erro ao atualizar grid: ' + E.Message);
    end;
  end;

procedure TFormHomeA.bCadastroClick(Sender: TObject);
var
  Cadastro: TCadastroCfg;
  Controller: TCadastroController;
begin
  Cadastro := TCadastroCfg.Create;
  Controller := TCadastroController.Create;
  try
    Cadastro.Nome := eNome.Text;
    Cadastro.Email := eEmail.Text;
    Cadastro.CPF := meCPF.Text;
    Cadastro.Senha := meSenha.Text;
    Cadastro.NPhone := meNPhone.Text;
    Cadastro.TipoUsuario := cbOpcoes.Text;
    if Controller.ProcessoCadastro(Cadastro) then
    begin
      eNome.Clear;
      eEmail.Clear;
      meCPF.Clear;
      meSenha.Clear;
      meNPhone.Clear;
      cbOpcoes.ItemIndex := 0;
    end;
  finally
    Cadastro.Free;
    Controller.Free;
  end;
end;

procedure TFormHomeA.CarregarDadosUpdate;
begin
  if not Assigned(DM) or not Assigned(DM.FDQr) then
  begin
    ShowMessage('DataModule n�o dispon�vel.');
    Exit;
  end;

  if DM.FDQr.IsEmpty then
  begin
    ShowMessage('Selecione um usu�rio para editar.');
    Exit;
  end;

  try
    with DM.FDQr do
    begin
      e1NomeUpdate.Text := FieldByName('nome_user').AsString;
      e2EmailUpdate.Text := FieldByName('email_user').AsString;
      meCPFUpdate.Text := FieldByName('cpf_user').AsString;
      meNPhoneUpdate.Text := FieldByName('nphone_user').AsString;
    end;
    pcButtons.ActivePageIndex := 3;

  except
    on E: Exception do
      ShowMessage('Erro ao carregar dados: ' + E.Message);
  end;
end;

procedure TFormHomeA.DBGridUsuariosCellClick(Column: TColumn);
begin
  lblUserSelectEx.Caption:=DBGridUsuarios.DataSource.DataSet.FieldByName('nome_user').AsString;
  lblUserSelectRes.Caption:=DBGridUsuarios.DataSource.DataSet.FieldByName('nome_user').AsString;
  CarregarDadosUpdate;
end;

procedure TFormHomeA.eCPFChange(Sender: TObject);
begin
  eCPF.Hide;
  meCPF.SetFocus;
end;

procedure TFormHomeA.eCPFClick(Sender: TObject);
begin
  eCPF.Hide;
  meCPF.SetFocus;
end;

procedure TFormHomeA.eNPhoneChange(Sender: TObject);
begin
  eNPhone.Hide;
  meNPhone.SetFocus;
end;

procedure TFormHomeA.FiltrarGrid(const TextoBusca: string);
  var
    Filtro: string;
  begin
    if not Assigned(DM) or not Assigned(DM.FDQr) then
    begin
      ShowMessage('DataModule ou FDQuery n�o dispon�vel.');
      Exit;
    end;
    try
      with DM.FDQr do
      begin
        Filtered := False;
        Filter := '';
        if Trim(TextoBusca) <> '' then
        begin
          Filtro := Format('(nome_user LIKE ''%%%s%%'') OR (email_user LIKE ''%%%s%%'') OR (cpf_user LIKE ''%%%s%%'')',[TextoBusca, TextoBusca, TextoBusca]);
          Filter := Filtro;
          Filtered := True;
          if IsEmpty then
            ShowMessage('Nenhum usu�rio encontrado com o termo: ' + TextoBusca);
        end;
        First;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao filtrar: ' + E.Message);
    end;
  end;

procedure TFormHomeA.FormCreate(Sender: TObject);
  begin
    eBuscaMain.Clear;
    eBuscaMain.TextHint := 'Para digitar clique no bot�o "Pesquisar"';
  end;

procedure TFormHomeA.FormShow(Sender: TObject);
  begin
    if Assigned(DM) and Assigned(DM.FDQr) and Assigned(DM.FDConn) then
    begin
      try
        if DM.FDConn.Connected then
          AtualizarGridTrue;
      except
        on E: Exception do
          ShowMessage('Erro ao carregar dados: ' + E.Message);
      end;
    end;
  end;

procedure TFormHomeA.iButton1Click(Sender: TObject);
  begin
   if pBarraMenuLeft.Width = 89 then begin
      pBarraMenuLeft.Width := 200;
    end else begin
      pBarraMenuLeft.Width := 89;
    end;
  end;

procedure TFormHomeA.LimparCamposUpdate;
  begin
    e1NomeUpdate.Clear;
    e2EmailUpdate.Clear;
    meCPFUpdate.Clear;
    meNPhoneUpdate.Clear;
    cbUpdate.ItemIndex:=-1;
  end;

procedure TFormHomeA.pButton1AdicionarClick(Sender: TObject);
begin
  if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 1;
  AtualizarGridTrue;
end;

procedure TFormHomeA.pButton2ExcluirClick(Sender: TObject);
  begin
    if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 2;
    AtualizarGridTrue;
    lblUserSelectEx.Caption:=DBGridUsuarios.DataSource.DataSet.FieldByName('nome_user').AsString;
  end;

procedure TFormHomeA.pButton3AtualizarClick(Sender: TObject);
  begin
    if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 3;
    CarregarDadosUpdate;
    AtualizarGrid;
  end;

procedure TFormHomeA.pButton4RestaurarClick(Sender: TObject);
begin
  if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 4;
  AtualizarGridFalse;
end;

procedure TFormHomeA.pButton5PesquisarClick(Sender: TObject);
  begin
    if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 5;
    if Trim(eBuscaMain.Text) = '' then
    begin
      ShowMessage('Digite um nome ou email para pesquisar.');
      eBuscaMain.SetFocus;
      Exit;
    end;
    FiltrarGrid(Trim(eBuscaMain.Text));
  end;

procedure TFormHomeA.pButton6CancelarClick(Sender: TObject);
  begin
    if not Assigned(DM) or not Assigned(DM.FDQr) then
    begin
      eBuscaMain.Clear;
      Exit;
    end;
    try
      with DM.FDQr do
      begin
        if State in [dsEdit, dsInsert] then
          Cancel;
      end;
      eBuscaMain.Clear;
      AtualizarGridTrue;
      ShowMessage('Opera��o cancelada. Grid restaurado.');
      if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 0;
  AtualizarGridTrue;
    except
      on E: Exception do
        ShowMessage('Erro ao cancelar: ' + E.Message);
    end;
  end;
procedure TFormHomeA.pButtonConfirmarExcluirClick(Sender: TObject);
  var
    IdUsuario: Integer;
    NomeUsuario: string;
  begin
    if Assigned(pcButtons) then
      pcButtons.ActivePageIndex := 2;
      AtualizarGridTrue;
    if not Assigned(DM) or not Assigned(DM.FDQr) then
    begin
      ShowMessage('DataModule n�o dispon�vel.');
      Exit;
    end;
    if DM.FDQr.IsEmpty then
    begin
      ShowMessage('Selecione um usu�rio para excluir.');
      Exit;
    end;
    try
      with DM.FDQr do
      begin
        IdUsuario := FieldByName('id_user').AsInteger;
        NomeUsuario := FieldByName('nome_user').AsString;
        if not FieldByName('ativo').AsBoolean then
        begin
          ShowMessage('Este usu�rio j� est� inativo.');
          Exit;
        end;
        if MessageDlg(Format('Deseja desativar o usu�rio "%s"?', [NomeUsuario]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          try
            Edit;
            FieldByName('ativo').AsBoolean := False;
            Post;
            AtualizarGridTrue;
            ShowMessage('Usu�rio desativado com sucesso!');
            pcButtons.ActivePageIndex := 0;
          except
            on E: Exception do
            begin
              Cancel;
              ShowMessage('Erro ao desativar usu�rio: ' + E.Message);
            end;
          end;
        end;
      end;
    except
      on E: Exception do
        ShowMessage('Erro: ' + E.Message);
    end;
  end;
procedure TFormHomeA.pButtonConfirmarRestoreClick(Sender: TObject);
var
  IdUsuario: Integer;
  NomeUsuario: string;
begin
  if not Assigned(DM) or not Assigned(DM.FDQr) then
  begin
    ShowMessage('DataModule n�o dispon�vel.');
    Exit;
  end;
  if DM.FDQr.IsEmpty then
  begin
    ShowMessage('Selecione um usu�rio para restaurar.');
    Exit;
  end;

  try
    with DM.FDQr do
    begin
      IdUsuario := FieldByName('id_user').AsInteger;
      NomeUsuario := FieldByName('nome_user').AsString;
      if FieldByName('ativo').AsBoolean then
      begin
        ShowMessage('Este usu�rio j� est� ativo.');
        Exit;
      end;
      if MessageDlg(Format('Deseja restaurar o usu�rio "%s"?', [NomeUsuario]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        try
          Edit;
          FieldByName('ativo').AsBoolean := True;
          Post;
          AtualizarGrid;
          ShowMessage('Usu�rio restaurado com sucesso!');
        except
          on E: Exception do
          begin
            Cancel;
            ShowMessage('Erro ao restaurar usu�rio: ' + E.Message);
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;
procedure TFormHomeA.pButtonConfirmarUpdateClick(Sender: TObject);
var
  IdUsuario: Integer;
  NomeUsuario, EmailUsuario, CpfUsuario, NPhoneUsuario: string;
begin
  if not Assigned(DM) or not Assigned(DM.FDQr) then
  begin
    ShowMessage('DataModule n�o dispon�vel.');
    pcButtons.ActivePageIndex := 0;
    Exit;
  end;

  if DM.FDQr.IsEmpty then
  begin
    ShowMessage('Selecione um usu�rio para atualizar.');
    pcButtons.ActivePageIndex := 0;
    Exit;
  end;

  // Capturar os valores dos campos
  NomeUsuario := Trim(e1NomeUpdate.Text);
  EmailUsuario := Trim(e2EmailUpdate.Text);
  CpfUsuario := meCPFUpdate.Text;
  NPhoneUsuario := meNPhoneUpdate.Text;

  // Valida��es
  if NomeUsuario = '' then
  begin
    ShowMessage('O nome n�o pode estar vazio.');
    e1NomeUpdate.SetFocus;
    Exit;
  end;

  if EmailUsuario = '' then
  begin
    ShowMessage('O email n�o pode estar vazio.');
    e2EmailUpdate.SetFocus;
    Exit;
  end;

  // Confirma��o
  if MessageDlg(
    Format('Deseja atualizar os dados do usu�rio?'#13#10 +
           'Nome: %s'#13#10 +
           'Email: %s'#13#10 +
           'CPF: %s'#13#10 +
           'Telefone: %s',
           [NomeUsuario, EmailUsuario, CpfUsuario, NPhoneUsuario]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      with DM.FDQr do
      begin
        Edit;
        FieldByName('nome_user').AsString := NomeUsuario;
        FieldByName('email_user').AsString := EmailUsuario;
        FieldByName('cpf_user').AsString := CpfUsuario;
        FieldByName('nphone_user').AsString := NPhoneUsuario;
        Post;
      end;

      AtualizarGrid;
      ShowMessage('Usu�rio atualizado com sucesso!');

      // Limpar os campos ap�s atualizar
      LimparCamposUpdate;

      pcButtons.ActivePageIndex := 0;
    except
      on E: Exception do
      begin
        DM.FDQr.Cancel;
        ShowMessage('Erro ao atualizar usu�rio: ' + E.Message);
      end;
    end;
  end
  else
  begin
    pcButtons.ActivePageIndex := 0;
  end;
end;

end.
