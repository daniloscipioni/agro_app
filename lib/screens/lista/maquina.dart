import 'package:bavaresco/database/machine_dao.dart';
import 'package:bavaresco/database/machine_historico_dao.dart';
import 'package:bavaresco/repository/machineInfoApontamentoAcumRepository.dart';
import 'package:bavaresco/screens/lista/historico.dart';
import 'package:flutter/material.dart';
import '../menu.dart';

final String _ultimoAbastecimento = 'Último Abastecimento';
final String _horimetro = 'Horímetro';
final String _consumoMedio = 'Consumo Medio';
final String _custoHorario = 'Custo Horário';

class ListaMaquinas extends StatelessWidget {
  final MachineDao _dao = MachineDao();
  final String _title = "Máquinas";
  final String _updating = "Sincronizando Banco de Dados!";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.greenAccent[700],
          bottom: TabBar(
            tabs: [
              Tab(text: "Trator"),
              Tab(text: "Colheitadeira"),
              Tab(text: "Plantadeira"),
              Tab(text: "Pulverizador"),
              Tab(text: "Implemento"),
            ],
            isScrollable: true,
          ),
          centerTitle: true,
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Text(_updating),
                  );

                  // Find the Scaffold in the widget tree and use
                  // it to show a SnackBar.
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              );
            })
          ],
        ),
        // body: _machinesList(),
        body: TabBarView(
          children: [
            _machinesList(1),
            _machinesList(2),
            _machinesList(3),
            _machinesList(4),
            _machinesList(5),
          ],
        ),
        drawer: MenuHamburger(),
      ),
    );
    // });
  }
}

class _machinesList extends StatelessWidget {
  final MachineHistoricoDao _daoAcum = MachineHistoricoDao();

  int index;

  _machinesList(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<InfoApontamentoAcumRepository>>(
        initialData: List(),
        //Traz as máquinas do banco local
        future: _daoAcum.findAllInfoApontamentoByMachineAcum(index),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<InfoApontamentoAcumRepository> machines =
                  snapshot.data;
              if(snapshot.data.length == 0){
                return _semMaquinasCadastradas();
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final InfoApontamentoAcumRepository machine = machines[index];

                  return _machineItem(machine);
                },
                itemCount: machines.length,
              );

              break;
          }

          return Text('Unknown error');
        },
      ),
    );
  }
}

class _machineItem extends StatelessWidget {
  final InfoApontamentoAcumRepository machine;

  _machineItem(this.machine);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: InkWell(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          machine.mainTitle(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  _rowItemAcumulado(
                      Icons.local_gas_station,
                      _ultimoAbastecimento,
                      machine.ultimoAbastecimentoToString()),
                  _rowItemAcumulado(Icons.access_time, _horimetro,
                      machine.horimetroAtualToString()),
                  _rowItemAcumulado(Icons.agriculture, _consumoMedio,
                      machine.consumoMedioToString()),
                  _rowItemAcumulado(
                      Icons.monetization_on, _custoHorario, 'N/D'),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return new ListaHistoricoMaquina(machine: machine);
              }),
            ).then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ListaMaquinas())));
          },
        ),
      ),
    ); //;
  }

  /**
   * Itens com valores acumulados
   */
  Row _rowItemAcumulado(IconData icon, String title, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Icon(
            icon,
            color: Colors.grey[600],
          ),
        ),
        Expanded(flex: 3, child: Text(title)),
        Expanded(flex: 1, child: Text(value))
      ],
    );
  }
}

class Tabs extends StatefulWidget {
  @override
  _RoomTabsState createState() => _RoomTabsState();
}

class _RoomTabsState extends State<Tabs> with TickerProviderStateMixin {
  var _scrollViewController;
  var _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (context, bool) => [
        SliverAppBar(
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: [
              Tab(text: "Trator"),
              Tab(text: "Colheitadeira"),
              Tab(text: "Plantadeira"),
              Tab(text: "Pulverizador"),
              Tab(text: "Implemento"),
            ],
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
        ],
      ),
    );
  }
}
class _semMaquinasCadastradas extends StatelessWidget {
  const _semMaquinasCadastradas({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Nenhuma máquina cadastrada',
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          fontSize: 20,
        ),
      ),
    );
  }
}