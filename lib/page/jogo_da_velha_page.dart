import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_jogo_da_velha_flutter/models/jogador_model.dart';

class JogoDaVelhaPage extends StatefulWidget {
  @override
  _JogoDaVelhaPageSate createState() => _JogoDaVelhaPageSate();
}

class _JogoDaVelhaPageSate extends State<JogoDaVelhaPage> {
  Jogador _jogadorDaVez;
  Jogador _jogadorX = Jogador(player: 'X');
  Jogador _jogadorO = Jogador(player: 'O');
  int totalDeJogadas = 0;
  bool ganho = false;

  List<List<Jogador>> _tabuleiro = [
    [null, null, null],
    [null, null, null],
    [null, null, null],
  ];

  @override
  void initState() {
    _jogadorDaVez = _jogadorX;
    super.initState();
  }

  _restart() {
    setState(() {
      for (var row = 0; row < _tabuleiro.length; row++) {
        _tabuleiro[row] = List(3);
        for (var column = 0; column < _tabuleiro.length; column++) {
          _tabuleiro[row][column] = null;
        }
      }
    });
    _jogadorDaVez = _jogadorX;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text('Jogo da velha, jogador da vez: ${_jogadorDaVez.player}'),
      centerTitle: true,
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBoard(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    final List<int> listaFixa =
        Iterable<int>.generate(_tabuleiro.length).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listaFixa.map((j) => _createLinha(_tabuleiro[j], j)).toList(),
    );
  }

  Widget _createLinha(List<Jogador> linha, int j) {
    final List<int> listaFixa = Iterable<int>.generate(linha.length).toList();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            listaFixa.map((i) => _createPosition(linha[i], j, i)).toList(),
      ),
    );
  }

  Widget _createPosition(Jogador jogador, int j, int i) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _jogada(j, i);
        },
        child: Container(
          height: 150,
          width: 120,
          color: Colors.grey[350],
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(
              width: 1.0,
            )),
            child: Center(
              child: _criaImagemPosicao(jogador),
            ),
          ),
        ),
      ),
    );
  }

  Image _criaImagemPosicao(Jogador jogador) {
    if (jogador == null) {
      return null;
    }
    if (jogador.player == 'X') {
      return Image.asset('/x.png');
    } else {
      return Image.asset('/o.png');
    }
  }

  void _jogada(int j, int i) {
    if (_tabuleiro[j][i] == null) {
      setState(() => _tabuleiro[j][i] = _jogadorDaVez);
      _verificaGanhador();
      _trocaJogador();
    } else {
      final snackBar = SnackBar(
        content: Text('Está posição já está ocupada, tente outra'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _trocaJogador() {
    setState(() {
      _jogadorDaVez = _jogadorDaVez.player == 'X' ? _jogadorO : _jogadorX;
    });
    totalDeJogadas++;
  }

  void _mensagem(String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(msg),
            content: new Text("Click em restart para começar outro jogo!"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Restart"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _restart();
                  ganho = false;
                  totalDeJogadas = 0;
                },
              ),
            ],
          );
        });
  }

  void _verificaGanhador() {
    _verificarHorizontal();
    _verificarVertical();
    _verificaDiagonal();
    _verificaSeImpatou();
  }

  void _verificarHorizontal() {
    for (var i = 0; i < 3; i++) {
      if (_tabuleiro[i][0] != null &&
          _tabuleiro[i][0] == _tabuleiro[i][1] &&
          _tabuleiro[i][0] == _tabuleiro[i][2]) {
        _mensagem('O jogador ${_tabuleiro[i][0].player} ganhou!');
        ganho = true;
      }
    }
  }

  void _verificarVertical() {
    for (var i = 0; i < 3; i++) {
      if (_tabuleiro[0][i] != null &&
          _tabuleiro[0][i] == _tabuleiro[1][i] &&
          _tabuleiro[0][i] == _tabuleiro[2][i]) {
        _mensagem('O jogador ${_tabuleiro[0][i].player} ganhou!');
        ganho = true;
      }
    }
  }

  void _verificaDiagonal() {
    if (_tabuleiro[0][0] != null &&
        _tabuleiro[0][0] == _tabuleiro[1][1] &&
        _tabuleiro[0][0] == _tabuleiro[2][2]) {
      _mensagem('O jogador ${_tabuleiro[0][0].player} ganhou!');
      ganho = true;
    } else if (_tabuleiro[0][2] != null &&
        _tabuleiro[0][2] == _tabuleiro[1][1] &&
        _tabuleiro[0][2] == _tabuleiro[2][0]) {
      _mensagem('O jogador ${_tabuleiro[0][2].player} ganhou!');
      ganho = true;
    }
  }

  void _verificaSeImpatou() {
    if (totalDeJogadas == 8 && ganho == false) {
      _mensagem('Ninguem ganhou!');
      ganho = true;
    }
    print(totalDeJogadas);
  }
}
