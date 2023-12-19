import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:the_rive_player/player/state_machine.dart';

class PlayerPage extends StatefulWidget {
  final String file;

  const PlayerPage({super.key, required this.file});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final List<SMIInput> inputs = [];
  Artboard? artboard;

  List<TheStateMachine>? stateMachines;

  StateMachineController? _controller;
  TheStateMachine? selectedStateMachine;

  double slider = 0;

  @override
  void initState() {
    super.initState();

    // Load the animation river from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    File(widget.file).readAsBytes().then(
      (data) async {
        // Load the RiveFile from the binary data.
        final river = RiveFile.import(ByteData.view(data.buffer));

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        artboard = river.mainArtboard;

        setState(() {
          stateMachines = artboard?.stateMachines
              .map((element) =>
                  TheStateMachine(name: element.name, machine: element))
              .toList();
        });
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: artboard == null
          ? const Center(
              child: Text("Loading Artwork."),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 500,
                        height: 500,
                        child: Rive(
                          artboard: artboard!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildSidebar()
                  ],
                ),
              ],
            ),
    );
  }

  buildSidebar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select State Machine"),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 200,
            child: DropdownButton<TheStateMachine>(
                value: selectedStateMachine,
                items: stateMachines
                        ?.map(
                          (e) => DropdownMenuItem<TheStateMachine>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    selectedStateMachine = value;
                    _controller = StateMachineController.fromArtboard(
                        artboard!, selectedStateMachine?.name ?? "");
                    _controller?.isActive = true;
                    artboard?.addController(_controller!);
                  });
                }),
          ),
          if (selectedStateMachine != null &&
              selectedStateMachine!.machine.inputs.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                const Text("Inputs: "),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: selectedStateMachine?.machine.inputs.map(
                        (element) {
                          SMIInput? inp = _controller?.findSMI((element.name));

                          if (inp is SMINumber) {
                            return Row(
                              children: [
                                Text(element.name),
                                const Spacer(),
                                InkWell(
                                  child: const Icon(Icons.remove),
                                  onTap: () {
                                    setState(() {
                                      inp.value = ((inp.value) - 1);
                                    });
                                  },
                                ),
                                Text(inp.value.toString()),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      inp.value = ((inp.value) + 1);
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                )
                              ],
                            );
                          }
                          if (inp is SMITrigger) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(element.name),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      inp.fire();
                                      print(inp.value);
                                    },
                                    child: const Icon(
                                      Icons.play_arrow_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (inp is SMIBool) {}
                          return Row(
                            children: [
                              Text(element.name),
                              const Spacer(),
                              Checkbox(
                                value: inp?.value,
                                onChanged: (value) {
                                  setState(() {
                                    inp?.value = value;
                                  });
                                },
                              )
                            ],
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
