import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:the_rive_player/player/state_machine.dart';
import 'package:the_rive_player/utils/the_inputs.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: artboard == null
                  ? const Center(
                      child: Text("Loading Artwork."),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: LayoutBuilder(builder: (context, size) {
                            return SizedBox(
                              width: size.maxWidth,
                              height: size.maxHeight,
                              child: Center(
                                child: Rive(
                                  artboard: artboard!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }),
                        ),
                        const VerticalDivider(),
                        buildSidebar()
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  buildSidebar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "State Machines",
          ),
          const SizedBox(
            height: 8,
          ),
          TheDropDown(
            value: selectedStateMachine,
            onChanged: (value) {
              setState(() {
                selectedStateMachine = value;
                _controller = StateMachineController.fromArtboard(
                    artboard!, selectedStateMachine?.name ?? "");
                _controller?.isActive = true;
                artboard?.addController(_controller!);
              });
            },
            items: stateMachines ?? [],
            hint: "Select State Machine",
          ),
          if (selectedStateMachine != null &&
              selectedStateMachine!.machine.inputs.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Inputs ",
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: selectedStateMachine?.machine.inputs.map(
                        (element) {
                          SMIInput? inp = _controller?.findSMI((element.name));

                          if (inp is SMINumber) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(element.name)),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          child: const Icon(Icons.remove),
                                          onTap: () {
                                            setState(() {
                                              inp.value = ((inp.value) - 1);
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: TheInputField(
                                              hint: "#",
                                              controller: TextEditingController(
                                                text: inp.value.toString(),
                                              ),
                                              label: "#",
                                              onSubmit: (value) {
                                                setState(() {
                                                  inp.value =
                                                      (double.tryParse(value) ??
                                                          0);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              inp.value = ((inp.value) + 1);
                                            });
                                          },
                                          child: const Icon(Icons.add),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          if (inp is SMITrigger) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(element.name),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      inp.fire();
                                      print(inp.value);
                                    },
                                    icon: const Icon(
                                      Icons.play_circle_outline,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (inp is SMIBool) {}
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  element.name,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      inp?.value = !(inp.value ?? false);
                                    });
                                  },
                                  icon: !(inp?.value ?? false)
                                      ? Icon(Icons.circle_outlined)
                                      : Icon(Icons.check_circle),
                                )
                              ],
                            ),
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
