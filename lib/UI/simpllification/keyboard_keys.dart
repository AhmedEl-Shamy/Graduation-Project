part of 'simplification.dart';

class KeyboardKeys extends StatelessWidget {
  KeyboardKeys({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    theme =
        checkTheme(BlocProvider.of<ThemeCubit>(context).currentTheme, context);
    return BlocConsumer<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state is ThemeStateLight)
          theme = 'light';
        else if (state is ThemeStateDark)
          theme = 'dark';
        else {
          if (Theme.of(context).brightness == 'light')
            theme = 'light';
          else
            theme = 'dark';
        }
      },
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) => GridView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            mainAxisExtent: constraints.maxHeight / 10,
          ),
          children: [
            //========================= 1st Row ================================//
            createButton(
              child: const Text('AC'),
              onPressed: () =>
                  BlocProvider.of<SimplificationCubit>(context).clearAll(),
              type: 'ac',
            ),
            createButton(
              child: const Icon(Icons.backspace_outlined),
              onPressed: BlocProvider.of<SimplificationCubit>(context).del,
              type: 'del',
            ),
            createButton(
              child: const Text('('),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('(', ' ( '),
              type: 'opr',
            ),
            createButton(
              child: const Text(')'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr(')', ' ) '),
              type: 'opr',
            ),
            //========================= 2nd Row ================================//
            createButton(
              child: const Text('AND'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('&', ' AND '),
              type: 'opr',
            ),
            createButton(
              child: const Text('NAND'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('!&', ' NAND '),
              type: 'opr',
            ),
            createButton(
              child: const Text('OR'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('|', ' OR '),
              type: 'opr',
            ),
            createButton(
              child: const Text('NOR'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('!|', ' NOR '),
              type: 'opr',
            ),
            //========================= 3rd Row ================================//
            createButton(
              child: const Text('XOR'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('^', ' XOR '),
              type: 'opr',
            ),
            createButton(
              child: const Text('XNOR'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('!^', ' XNOR '),
              type: 'opr',
            ),
            createButton(
              child: const Text('LSH'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('<<', ' << '),
              type: 'opr',
            ),
            createButton(
              child: const Text('RSH'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('>>', ' >> '),
              type: 'opr',
            ),
            //========================= 4th Row ================================//
            createButton(
              child: const Text('A'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('A', 'A'),
              type: 'letter',
            ),
            createButton(
              child: const Text('B'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('B', 'B'),
              type: 'letter',
            ),
            createButton(
              child: const Text('C'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('C', 'C'),
              type: 'letter',
            ),
            createButton(
              child: const Text('NOT'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('~', ' NOT '),
              type: 'opr',
            ),
            //========================= 5th Row ================================//
            createButton(
              child: const Text('D'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('D', 'D'),
              type: 'letter',
            ),
            createButton(
              child: const Text('E'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('E', 'E'),
              type: 'letter',
            ),
            createButton(
              child: const Text('F'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('F', 'F'),
              type: 'letter',
            ),
            createButton(
              child: const Text('G'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('G', 'G'),
              type: 'letter',
            ),
            //========================= 6th Row ================================//
            createButton(
              child: const Text('H'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('H', 'H'),
              type: 'letter',
            ),
            createButton(
              child: const Text('I'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('I', 'I'),
              type: 'letter',
            ),
            createButton(
              child: const Text('J'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('J', 'J'),
              type: 'letter',
            ),
            createButton(
              child: const Text('K'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('K', 'K'),
              type: 'letter',
            ),
            //========================= 7th Row ================================//
            createButton(
              child: const Text('L'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('L', 'L'),
              type: 'letter',
            ),
            createButton(
              child: const Text('M'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('M', 'M'),
              type: 'letter',
            ),
            createButton(
              child: const Text('N'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('N', 'N'),
              type: 'letter',
            ),
            createButton(
              child: const Text('O'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('O', 'O'),
              type: 'letter',
            ),
            //========================= 8th Row ================================//
            createButton(
              child: const Text('P'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('P', 'P'),
              type: 'letter',
            ),
            createButton(
              child: const Text('Q'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('Q', 'Q'),
              type: 'letter',
            ),
            createButton(
              child: const Text('R'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('R', 'R'),
              type: 'letter',
            ),
            createButton(
              child: const Text('S'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('S', 'S'),
              type: 'letter',
            ),
            //========================= 9th Row ================================//
            createButton(
              child: const Text('T'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('T', 'T'),
              type: 'letter',
            ),
            createButton(
              child: const Text('U'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('U', 'U'),
              type: 'letter',
            ),
            createButton(
              child: const Text('V'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('V', 'V'),
              type: 'letter',
            ),
            createButton(
              child: const Text('W'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('W', 'W'),
              type: 'letter',
            ),
            //========================= 10th Row ===============================//
            createButton(
              child: const Text('X'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('X', 'X'),
              type: 'letter',
            ),
            createButton(
              child: const Text('Y'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('Y', 'Y'),
              type: 'letter',
            ),
            createButton(
              child: const Text('Z'),
              onPressed: () => BlocProvider.of<SimplificationCubit>(context)
                  .updateExpr('Z', 'Z'),
              type: 'letter',
            ),
            createButton(
              child: const Text('='),
              onPressed: () {},
              type: '=',
            ),
          ],
        ),
      ),
    );
  }

  TextButton createButton(
      {required Widget child,
      required void Function() onPressed,
      required String type}) {
    Color fgColor = (theme == 'light')
        ? ThemeColors.lightBlackText
        : ThemeColors.darkWhiteText;
    if (type == 'opr')
      fgColor = (theme == 'light')
          ? ThemeColors.lightForegroundTeal
          : ThemeColors.darkForegroundTeal;
    else if (type == 'ac' || type == 'del')
      fgColor = ThemeColors.blueColor;
    else if (type == '=') fgColor = ThemeColors.redColor;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        foregroundColor: fgColor,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.heightBlock! * 3,
          fontFamily: SizeConfig.fontName,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightBlock!,
          horizontal: SizeConfig.widthBlock!,
        ),
        child: FittedBox(
          child: child,
        ),
      ),
    );
  }
}
