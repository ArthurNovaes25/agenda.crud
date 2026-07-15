class Contato {
  String nome;
  String telefone;
  String email;
  Contato(this.nome, this.telefone, this.email);

  void imprimirContato() {
    print('Nome: $nome');
    print('Telefone: $telefone');
    print('Email: $email');
  }
}

class ContatoPessoal extends Contato {
    String? apelido;
 
  ContatoPessoal(
      String nomePessoal,
      String telefonePessoal,
      String emailPessoal,
      this.apelido,
  ) : super(nomePessoal, telefonePessoal, emailPessoal);
 
  @override
  void imprimirContato() {
    super.imprimirContato();
    print('Apelido: ${apelido ?? 'Não informado'}');
 
  }
}
 
 
class ContatoEmpresarial extends Contato {
  String? empresa;
 
  ContatoEmpresarial(
      String nomeEmpresa,
      String telefoneEmpresarial,
      String emailEmpresarial,
     this.empresa,
  ) : super(nomeEmpresa, telefoneEmpresarial, emailEmpresarial);
 
  @override
  void imprimirContato() {
    super.imprimirContato();
    print('Empresa: ${empresa ?? 'Não informada'}');
 
  }
}
