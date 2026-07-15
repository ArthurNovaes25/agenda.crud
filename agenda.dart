import 'dart:io';

import 'contato.dart';

class Agenda {
  List<Contato> _contatos = [];
  List<String> historico = [];

  bool indiceValido(int i) {
    return i >= 0 && i < _contatos.length;
  }

  String lerNome() {
    while (true) {
      stdout.write('Nome: ');
      String nome = stdin.readLineSync() ?? '';

      if (nome.trim().isNotEmpty && !nome.contains(';')) {
        return nome.trim();
      }

      print('Não pode ficar vazio e nem conter ponto e vírgula.');
    }
  }

  String lerTelefone() {
    while (true) {
      stdout.write('Telefone padrão: (00)00000-0000 ');
      String telefone = stdin.readLineSync() ?? '';

      if (RegExp(r'^\(\d{2}\)\s?\d{4,5}-\d{4}$').hasMatch(telefone)) {
        return telefone;
      }

      print(
        'Telefone inválido. O telefone tem  que ser neste padrão: (00)00000-0000.',
      );
    }
  }

  String lerEmail() {
    while (true) {
      stdout.write('E-mail: ');
      String email = stdin.readLineSync() ?? '';

      if (RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(email)) {
        return email;
      }

      print('E-mail inválido. Use o formato nome@dominio.com.');
    }
  }

  bool existe(String nome) {
    for (int i = 0; i < _contatos.length; i++) {
      if (_contatos[i].nome.toLowerCase() == nome.toLowerCase()) {
        return true;
      }
    }

    return false;
  }

  void adicionar() {
    print('Adicionando contato Empresarial ou Pessoal? (E/P)');
    String tipo = stdin.readLineSync()?.toLowerCase() ?? '';
    if (tipo != 'e' && tipo != 'p') {
    print('Tipo inválido.');
    return;
  }
    String nome = lerNome();

    if (existe(nome)) {
      print('Já existe um contato com esse nome.');
      return;
    }

    String telefone = lerTelefone();
    String email = lerEmail();
  if (tipo == 'e') {
    stdout.write('Empresa: ');
    String empresa = stdin.readLineSync() ?? '';
    _contatos.add(ContatoEmpresarial(nome, telefone, email, empresa));
  } else if (tipo == 'p') {
    stdout.write('Apelido: ');
    String apelido = stdin.readLineSync() ?? '';
    _contatos.add(ContatoPessoal(nome, telefone, email, apelido));
  } 
    historico.add('Adicionou $nome');

    print('✓ Contato adicionado.');
  }

  void listar() {
    if (_contatos.isEmpty) {
      print('Agenda vazia.');
      return;
    }

    for (int i = 0; i < _contatos.length; i++) {
      print('$i - ID');
     _contatos[i].imprimirContato();
      print('---');
    }
  }

  void editar() {
    listar();

    if (_contatos.isEmpty) {
      return;
    }

    stdout.write('Índice para editar: ');
    int i = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

    if (!indiceValido(i)) {
      print('Índice inválido.');
      return;
    }

    String nomeAntigo = _contatos[i].nome;

    stdout.write('Novo nome: ');
    String novoNome = stdin.readLineSync() ?? '';

    if (novoNome.trim().isEmpty || novoNome.contains(';')) {
      print('Nome inválido.');
      return;
    }

    if (novoNome.toLowerCase() != nomeAntigo.toLowerCase() &&
        existe(novoNome)) {
      print('Já existe um contato com esse nome.');
      return;
    }

    String novoTelefone = lerTelefone();
    String novoEmail = lerEmail();

  if (_contatos[i] is ContatoPessoal) {
    stdout.write('Novo apelido: ');
    String novoApelido = stdin.readLineSync() ?? '';
    _contatos[i] = ContatoPessoal(novoNome.trim(), novoTelefone, novoEmail, novoApelido);
  } else if (_contatos[i] is ContatoEmpresarial) {
    stdout.write('Nova empresa: ');
    String novaEmpresa = stdin.readLineSync() ?? '';
    _contatos[i] = ContatoEmpresarial(novoNome.trim(), novoTelefone, novoEmail, novaEmpresa);
  }
    historico.add('Editou $nomeAntigo');

    print('✓ Atualizado.');
  }

  void remover() {
    listar();

    if (_contatos.isEmpty) {
      return;
    }

    stdout.write('Índice para remover: ');
    int i = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

    if (!indiceValido(i)) {
      print('Índice inválido.');
      return;
    }

    stdout.write('Remover ${_contatos[i].nome}? (s/n) ');
    String resposta = (stdin.readLineSync() ?? '').toLowerCase();

    if (resposta == 's') {
      String removido = _contatos[i].nome;

      _contatos.removeAt(i);

      historico.add('Removeu $removido');

      print('✓ Removido.');
    } else {
      print('Remoção cancelada.');
    }
  }

  void buscar() {
    stdout.write('Buscar nome: ');
    String termo = (stdin.readLineSync() ?? '').toLowerCase();

    bool achou = false;

    for (int i = 0; i < _contatos.length; i++) {
      if (_contatos[i].nome.toLowerCase().contains(termo)) {
        stdout.write(
          '$i - ${_contatos[i].nome} | ${_contatos[i].telefone} | ${_contatos[i].email} |',
        
        ); 
        if (_contatos[i] is ContatoPessoal) {
          print('Apelido: ${( _contatos[i] as ContatoPessoal).apelido ?? 'Não informado'}');
        } else if (_contatos[i] is ContatoEmpresarial) {
          print('Empresa: ${( _contatos[i] as ContatoEmpresarial).empresa ?? 'Não informada'}');
        }
        achou = true;
      }
    
    }

    if (!achou) {
      print('Nenhum contato encontrado.');
    }
  }

  void estatisticas() {
    int comEmail = 0;
    String maisLongo = '';

    for (int i = 0; i < _contatos.length; i++) {
      if (_contatos[i].email.isNotEmpty) {
        comEmail++;
      }

      if (_contatos[i].nome.length > maisLongo.length) {
        maisLongo = _contatos[i].nome;
      }
    }

    print('Total de contatos: ${_contatos.length}');
    print('Com e-mail preenchido: $comEmail');

    if (maisLongo.isEmpty) {
      print('Nome mais longo: nenhum');
    } else {
      print('Nome mais longo: $maisLongo');
    }
  }

  void mostrarHistorico() {
    if (historico.isEmpty) {
      print('Histórico vazio.');
      return;
    }

    for (int i = 0; i < historico.length; i++) {
      print('• ${historico[i]}');
    }
  }

  void salvar() {
    List<String> linhas = [];

    for (int i = 0; i < _contatos.length; i++) {
      if (_contatos[i] is ContatoPessoal) {
        linhas.add(
          '${_contatos[i].nome};${_contatos[i].telefone};${_contatos[i].email};P;${(_contatos[i] as ContatoPessoal).apelido ?? ''}',
        );
      } else if (_contatos[i] is ContatoEmpresarial) {
        linhas.add(
          '${_contatos[i].nome};${_contatos[i].telefone};${_contatos[i].email};E;${(_contatos[i] as ContatoEmpresarial).empresa ?? ''}',
        );
      } else {
        linhas.add(
          '${_contatos[i].nome};${_contatos[i].telefone};${_contatos[i].email}',
        );
      }
    }

    File('agenda.txt').writeAsStringSync(linhas.join('\n'));
  }

  void carregar() {
    File arquivo = File('agenda.txt');

    if (!arquivo.existsSync()) {
      return;
    }

    _contatos.clear();

    List<String> linhas = arquivo.readAsLinesSync();

    for (int i = 0; i < linhas.length; i++) {
      List<String> partes = linhas[i].split(';');

      if (partes.length == 3) {
        _contatos.add(Contato(partes[0], partes[1], partes[2]));
      } else if (partes.length == 5) {
        if (partes[3] == 'P') {
          _contatos.add(ContatoPessoal(partes[0], partes[1], partes[2], partes[4]));
        } else if (partes[3] == 'E') {
          _contatos.add(ContatoEmpresarial(partes[0], partes[1], partes[2], partes[4]));
        }
      }
    }
  }
}
