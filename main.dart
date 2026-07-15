import 'dart:io';

import 'agenda.dart';

void main() {
  Agenda agenda = Agenda();
  agenda.carregar();

  while (true) {
    print('''
=====================
       📓 AGENDA 📓
=====================
1 - Adicionar
2 - Listar
3 - Editar
4 - Remover
5 - Buscar
6 - Histórico
7 - Estatísticas
8 - SAIR
=====================
''');

    stdout.write('> ');
    String opcao = stdin.readLineSync() ?? '';

    switch (opcao) {
      case '1':
        agenda.adicionar();
        break;
      case '2':
        agenda.listar();
        break;
      case '3':
        agenda.editar();
        break;
      case '4':
        agenda.remover();
        break;
      case '8':
        agenda.salvar();
        print('Saindo...');
        return;
      case '5':
        agenda.buscar();
        break;
      case '7':
        agenda.estatisticas();
        break;
      case '6':
        agenda.mostrarHistorico();
        break;
      default:
        print('Opção inválida.');
    }
  }
}
